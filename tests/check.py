"""Compile realistic letter variants in isolated temporary directories."""
from pathlib import Path
import re
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
BODY = r"\to{Department of Statistics\\University of Connecticut}{Dr. Example}\opening{Dear colleague:}" + '\n'
PARAGRAPH = "This paragraph checks the flowing letter layout and continuation pages. " * 6 + '\n\\par\n'
LEGACY = r"""\renewcommand{\me}{Legacy Sender}
\renewcommand{\mytitle}{Professor}
\renewcommand{\personal}{\extend{Legacy Sender}\\Department of Statistics}
\newcommand{\SigPic}{sampleSig}
\newcommand{\SigPut}{\put(-.2,-.65)}
"""
cases = [
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
for name, options, setup, body, profile, error in cases:
    with tempfile.TemporaryDirectory(prefix='uconnlh-') as tmp:
        work = Path(tmp)
        for filename in ('UConnLH.cls', 'UConn-stacked.png', 'sampleSig.png'):
            shutil.copy2(ROOT / filename, work)
        if profile is None:
            shutil.copy2(ROOT / 'letterinfo.sty', work)
        elif profile:
            (work / 'letterinfo.sty').write_text(profile)
        (work / 'test.tex').write_text(r'\documentclass[' + options + r']{UConnLH}' + '\n' + setup + '\n' + r'\begin{document}' + '\n' + body + '\n' + r'\end{document}')
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
        print(f'PASS {name}')
