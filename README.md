# UConn Statistics Letterhead

LaTeX letterhead for the University of Connecticut Department of Statistics,
maintained by the Statistics Computing Committee (`scc-uconn`).

## Getting started

Install a LaTeX distribution such as TeX Live or MacTeX, including the
`bookman`, `graphicx`, and `ifthen` packages. From this directory, run:

```sh
pdflatex SampleLetter.tex
```

This generates `SampleLetter.pdf`. The repository includes the original sample
PDF as a preview; rebuilding replaces it with your version.

## Customizing a letter

1. Edit `letterinfo.sty` to set your name, title, contact information, and
   signature image (`\SigPic`, without its file extension).
2. Copy `SampleLetter.tex` to a new `.tex` file in this directory and edit the
   recipient, salutation, and body. The first argument of `\to` contains the
   organization/address; the second contains the recipient's name.
3. Compile your file with `pdflatex YourLetter.tex`.

The `signed` class option inserts the signature image. Remove it to produce
an unsigned letter:

```tex
\documentclass[11pt]{UConnLH}
```

The class also provides `\memo`, `\fax`, `\cc`, and `\encl`. Its `initialed`
and `firstname` options require additional image files configured in
`letterinfo.sty`; those images are not included in the original archive.

## Included files

| File | Purpose |
| --- | --- |
| `UConnLH.cls` | Letterhead class, version 2.0 (October 20, 2017) |
| `letterinfo.sty` | Example personal information and signature settings |
| `UConn-stacked.png` | UConn logo used by the class |
| `sampleSig.png` | Example signature image |
| `SampleLetter.tex` | Example letter source |
| `SampleLetter.pdf` | Original compiled example |

## Source and attribution

Imported from the **UConn Stat Department Letter Head** download on
[Jun Yan's Miscellaneous page](https://statcomp.org/misc.html):
[UConnStatLH.tgz](https://merlot.stat.uconn.edu/~jyan/docs/UConnStatLH.tgz).

The class was adapted by Jun Yan from `UIlh.cls` by Russ Lenth. The website
dates the latest update to October 20, 2017, incorporating the new UConn logo.
The source, images, and example PDF are preserved as distributed; generated
`.aux` and `.log` files from the archive were omitted.

The original archive contains no license file. No new license is assigned by
this import.
