"""Check closing placement across lengths and page-boundary conditions.

Requires pdflatex and pdftotext. Optional --output keeps PDFs and a CSV report.
"""
import argparse
import csv
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
SENDER_SETUP = r'\UConnLHsetup' + ROOT.joinpath('SampleLetter.tex').read_text().split(r'\begin{document}')[0].split(r'\UConnLHsetup', 1)[1]
NS = {'x': 'http://www.w3.org/1999/xhtml'}
PARAGRAPH = ('A professional letter should maintain readable spacing and a consistent layout '
             'as its content grows across pages. ') * 5
OPENING = r'\to{Example University\\123 College Road}{Dr. Recipient}\opening{Dear colleague:}'
ENDING = ('The final paragraph provides the concluding remarks for this correspondence. '
          'Thank you for your consideration and your continued collaboration. Finalbodymarker.')


def run_case(work, name, options, content, output):
    source = (r'\documentclass[' + options + r']{UConnLH}' + '\n'
              + SENDER_SETUP + '\n'
              + r'\begin{document}' + '\n' + OPENING + '\n'
              + content + '\n' + r'\closing\end{document}')
    (work / 'test.tex').write_text(source)
    result = subprocess.run(['pdflatex', '-interaction=nonstopmode', '-halt-on-error', 'test.tex'],
                            cwd=work, capture_output=True, text=True)
    log = (work / 'test.log').read_text()
    assert result.returncode == 0, (name, result.stdout[-1500:])
    assert not re.search(r'Overfull|Underfull|Package fancyhdr Warning', log), (name, log[-1500:])
    bbox = subprocess.check_output(['pdftotext', '-bbox', str(work / 'test.pdf'), '-'], text=True)
    pages = ET.fromstring(bbox).findall('.//x:page', NS)
    words = pages[-1].findall('.//x:word', NS)
    height = float(pages[-1].attrib['height'])
    closing = [w for p in pages for w in p.findall('.//x:word', NS) if w.text == 'Sincerely']
    assert len(closing) == 1 and closing[0] in words, (name, 'closing split or missing')
    finalbody = next((w for w in words if w.text == 'Finalbodymarker.'), None)
    assert finalbody is not None, (name, 'closing orphaned from final body')
    closing_top = float(closing[0].attrib['yMin'])
    assert float(finalbody.attrib['yMax']) < closing_top, (name, 'body overlaps closing')
    title = [w for w in words if w.text == 'Professor'][-1]
    closing_bottom = float(title.attrib['yMax'])
    bottom_gap = height - closing_bottom
    # The closing ends at the body margin, allowing font descent/rounding.
    assert bottom_gap > 50, (name, 'closing violates bottom margin', bottom_gap)
    above = closing_top - float(finalbody.attrib['yMax'])
    below = bottom_gap - .85 * 72
    assert abs(above - below) < 40, (name, 'closing not centered in remaining space', above, below)
    assert len(pages) == int(re.search(r'Output written .*?\((\d+) pages?', log).group(1))
    if output:
        shutil.copy2(work / 'test.pdf', output / f'{name}.pdf')
    return (name, len(pages), round(closing_top, 2), round(bottom_gap, 2))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    if args.output:
        args.output.mkdir(parents=True, exist_ok=True)
    rows = []
    with tempfile.TemporaryDirectory(prefix='uconnlh-sweep-') as tmp:
        work = Path(tmp)
        for filename in ('UConnLH.cls', 'UConn-stacked.png', 'sampleSig.png'):
            shutil.copy2(ROOT / filename, work)
        for label, options in [('signed-letter', 'signed'), ('unsigned-letter', ''),
                               ('signed-a4', 'signed,a4paper'), ('signed-12pt', 'signed,12pt')]:
            for length in list(range(25)) + [32, 40]:
                content = (PARAGRAPH + '\n\n') * length + ENDING
                rows.append(run_case(work, f'{label}-{length:02d}', options, content, args.output))
            print(f'PASS {label}: 27 lengths, {min(r[1] for r in rows[-27:])}–{max(r[1] for r in rows[-27:])} pages', flush=True)
        # Deliberately leave 0–160pt before the final paragraph and closing.
        # Includes exact-fit and almost-fit cases at 4pt intervals.
        for remaining in range(0, 161, 4):
            content = (PARAGRAPH + '\n\n'
                       + r'\par\vspace*{\dimexpr\pagegoal-\pagetotal-'
                       + str(remaining) + 'pt\\relax}\n' + ENDING)
            rows.append(run_case(work, f'boundary-{remaining:03d}', 'signed', content, args.output))
        print('PASS page boundaries: 41 remaining-space cases', flush=True)
    if args.output:
        with (args.output / 'report.csv').open('w', newline='') as stream:
            writer = csv.writer(stream)
            writer.writerow(['case', 'pages', 'closing_top_pt', 'space_below_closing_pt'])
            writer.writerows(rows)
    print(f'PASS {len(rows)} layouts; closing intact, final body present, remaining space balanced, bottom margin respected')


if __name__ == '__main__':
    main()
