"""Compile realistic letter variants in isolated temporary directories."""
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_SETUP = ROOT.joinpath('SampleLetter.tex').read_text().split(r'\begin{document}')[0].split(r'\UConnLHsetup', 1)[1]
DEFAULT_SETUP = r'\UConnLHsetup' + DEFAULT_SETUP
BODY = r"\to{Department of Statistics\\University of Connecticut}{Dr. Example}\opening{Dear colleague:}" + '\n'
PARAGRAPH = "This paragraph checks the flowing letter layout and continuation pages. " * 6 + '\n\\par\n'
LEGACY = r"""\renewcommand{\me}{Legacy Sender}
\renewcommand{\mytitle}{Professor}
\renewcommand{\personal}{\extend{Legacy Sender}\\Department of Statistics}
\newcommand{\SigPic}{sampleSig}
\newcommand{\SigPut}{\put(-.2,-.65)}
"""
cases = [
    ('copies-enclosures', 'signed', '', BODY + PARAGRAPH + r'\closing[Best regards]\cc{Dr. Colleague\\Department administrator}\encl[Attachments:]{Curriculum vitae\\Research statement}', None, None),
    ('closing-with-body', 'signed', '', BODY + PARAGRAPH + r'\par\vspace*{\dimexpr\pagegoal-\pagetotal-4\baselineskip\relax}' + '\n' + r'Final paragraph stays with the closing, even when the available space on this page is insufficient. The closing and signature stay together.\closing', None, None),
    ('sender-controls', '', r'\UConnLHsetup{sender-width={2.3in},sender-xshift={-.25in},sender-yshift={.2in},sender-font-size={8},date-gap={.2in}}', BODY + PARAGRAPH + r'\closing', None, None),
    ('long-url', '', r'\UConnLHsetup{website={https://example.edu/people/alex_example/aVeryLongUnbrokenWebsitePathWithManyCharactersAndNumbers1234567890}}', BODY + PARAGRAPH + r'\closing', None, None),
    ('no-website', '', r'\UConnLHsetup{website={}}', BODY + PARAGRAPH + r'\closing', None, None),
    ('signed', 'signed', '', BODY + PARAGRAPH + r'\closing', None, None),
    ('unsigned', '', '', BODY + PARAGRAPH + r'\closing', None, None),
    ('multipage', 'signed', '', BODY + PARAGRAPH * 18 + r'\closing', None, None),
    ('long-profile-a4', 'a4paper,12pt', r'\UConnLHsetup{name={Alexandra Example-Surname},title={Associate Professor and Director of Graduate Studies},address={A longer departmental address\\University of Connecticut},date={October 1, 2026}}', BODY + PARAGRAPH + r'\closing', None, None),
    ('legacy', 'signed', '', BODY + PARAGRAPH + r'\closing', LEGACY, None),
    ('no-profile', '', r'\UConnLHsetup{name={Independent Sender},title={Professor}}', BODY + PARAGRAPH + r'\closing', '', None),
    ('memo-fax', 'nohead,footer', '', r'\memo{Committee}{Jun Yan}{Computing resources}' + PARAGRAPH + r'\fax{Committee}{Jun Yan}{Resources}{123}{1}' + PARAGRAPH, None, None),
    ('initials', 'initialed', r'\UConnLHsetup{initials={sampleSig.png}}', BODY + PARAGRAPH + r'\closing', None, None),
    ('firstname', 'firstname', r'\UConnLHsetup{firstname={sampleSig.png}}', BODY + PARAGRAPH + r'\closing', None, None),
    ('missing-signature', 'signed', '', BODY + r'\closing', '', 'No signature image configured'),
    ('missing-file', 'signed', r'\UConnLHsetup{signature={nonexistent.png}}', BODY + r'\closing', None, 'nonexistent.png'),
    ('conflicting-options', 'signed,firstname', '', BODY + r'\closing', None, 'Conflicting signature options'),
]
sender_centers = {}
for name, options, setup, body, profile, error in cases:
    with tempfile.TemporaryDirectory(prefix='uconnlh-') as tmp:
        work = Path(tmp)
        for filename in ('UConnLH.cls', 'UConn-stacked.png', 'sampleSig.png'):
            shutil.copy2(ROOT / filename, work)
        sender_setup = DEFAULT_SETUP if profile is None else ''
        if profile:
            (work / 'letterinfo.sty').write_text(profile)
            sender_setup = r'\input{./letterinfo.sty}'
        (work / 'test.tex').write_text(r'\documentclass[' + options + r']{UConnLH}' + '\n' + sender_setup + '\n' + setup + '\n' + r'\begin{document}' + '\n' + body + '\n' + r'\end{document}')
        result = subprocess.run(['pdflatex', '-interaction=nonstopmode', '-halt-on-error', 'test.tex'], cwd=work, capture_output=True, text=True)
        log = (work / 'test.log').read_text()
        if error:
            assert result.returncode != 0 and error in log, (name, log)
        else:
            assert result.returncode == 0, (name, log)
            assert not re.search(r'Overfull|Underfull|Package fancyhdr Warning|\\envelope', log), (name, log)
            pages = int(re.search(r'Output written .*?\((\d+) pages?', log).group(1))
            if name == 'multipage':
                assert pages >= 3, pages
                if shutil.which('pdftotext'):
                    text = subprocess.check_output(['pdftotext', '-layout', str(work / 'test.pdf'), '-'], text=True)
                    blocks = [page for page in text.split('\f') if page.strip()]
                    assert 'Jun Yan' in blocks[1] and re.search(r'20\d\d', blocks[1])
                    assert 'Sincerely yours' in blocks[-1] and 'Professor' in blocks[-1]
            if name == 'no-profile' and shutil.which('pdftotext'):
                text = subprocess.check_output(['pdftotext', str(work / 'test.pdf'), '-'], text=True)
                assert 'Independent Sender' in ' '.join(text.split()) and 'Jun Yan' not in text, repr(text)
            if name == 'no-website' and shutil.which('pdftotext'):
                text = subprocess.check_output(['pdftotext', str(work / 'test.pdf'), '-'], text=True)
                assert 'statcomp.org' not in text
            if name in ('signed', 'long-url', 'no-website') and shutil.which('pdftotext'):
                bbox = subprocess.check_output(['pdftotext', '-bbox', str(work / 'test.pdf'), '-'], text=True)
                page = ET.fromstring(bbox).find('.//{http://www.w3.org/1999/xhtml}page')
                contact = [w for w in page.findall('.//{http://www.w3.org/1999/xhtml}word')
                           if float(w.attrib['xMin']) > 350 and float(w.attrib['yMax']) < 110]
                sender_centers[name] = (min(float(w.attrib['yMin']) for w in contact)
                                        + max(float(w.attrib['yMax']) for w in contact)) / 2
            if name == 'closing-with-body' and shutil.which('pdftotext'):
                text = subprocess.check_output(['pdftotext', str(work / 'test.pdf'), '-'], text=True)
                blocks = [page for page in text.split('\f') if page.strip()]
                assert len(blocks) == 2
                assert 'Final paragraph stays' in blocks[-1] and 'Sincerely yours' in blocks[-1], repr(blocks)
                bbox = subprocess.check_output(['pdftotext', '-bbox', str(work / 'test.pdf'), '-'], text=True)
                tree = ET.fromstring(bbox)
                ns = {'x': 'http://www.w3.org/1999/xhtml'}
                page = tree.findall('.//x:page', ns)[-1]
                sincerely = next(word for word in page.findall('.//x:word', ns) if word.text == 'Sincerely')
                words = page.findall('.//x:word', ns)
                body_end = next(w for w in words if w.text == 'together.')
                title = [w for w in words if w.text == 'Professor'][-1]
                above = float(sincerely.attrib['yMin']) - float(body_end.attrib['yMax'])
                below = float(page.attrib['height']) - .85 * 72 - float(title.attrib['yMax'])
                assert abs(above - below) < 40, (above, below)
        print(f'PASS {name}')
if sender_centers:
    assert max(sender_centers.values()) - min(sender_centers.values()) < 3, sender_centers
    print('PASS sender center stays aligned with absent and wrapped websites')
