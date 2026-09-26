# UConn Statistics Letterhead

LaTeX letterhead for the University of Connecticut Department of Statistics,
maintained by the Statistics Computing Committee (`scc-uconn`). Version 3 provides
a flowing layout, configurable sender information, and continuation-page headers.

[View the example letter](SampleLetter.pdf).

## Getting started

Install TeX Live, MacTeX, or MiKTeX with `bookman`, `graphicx`, `geometry`, and
`fancyhdr`. From this directory, run:

```sh
pdflatex SampleLetter.tex
```

Edit `letterinfo.sty` to supply your own name, title, contact details, and signature.
Copy `SampleLetter.tex` to a new file in this directory and replace its recipient
and body. Compile it with `pdflatex YourLetter.tex`.

The profile is loaded only from `./letterinfo.sty` in the working directory. You
can omit that file and configure the sender directly in the document preamble:

```tex
\documentclass[signed]{UConnLH}
\UConnLHsetup{
  name = {Alex Example},
  title = {Associate Professor},
  department = {Department of Statistics},
  address = {University of Connecticut\\Storrs, CT},
  email = {alex.example@uconn.edu},
  signature = {my-signature.png}
}
\begin{document}
\to{Example University\\123 College Road}{Dr. Recipient}
\opening{Dear Dr. Recipient:}
Thank you for your correspondence.
\closing
\end{document}
```

Settings in the preamble override the local profile. Values containing commas
must be enclosed in braces. Use `\\` for address line breaks. The recipient's
name prints first, followed by the organization/address supplied to `\to`.

## Configuration

| Key | Meaning / default |
| --- | --- |
| `name`, `title`, `phone`, `email`, `website`, `address` | Sender fields; empty without a profile |
| `department` | Department of Statistics |
| `date` | `\today`; override for a fixed date |
| `closing` | Sincerely yours; `\closing[Best regards]` overrides it for one letter |
| `signature`, `initials`, `firstname` | Image path for the corresponding class option |
| `logo` | `UConn-stacked.png` |
| `logo-width` | `2.4in` |
| `signature-height` | `1cm`; image width is also constrained to the closing block |
| `closing-width` | `0.45\textwidth` |

Use ordinary LaTeX escaping for special characters in text, such as `\&` and `\_`.
Keep URLs short enough to fit the contact block, or insert deliberate line breaks.
The included logo is the image from the original archive.

## Options and other commands

- US Letter and 11-point type are the defaults. `a4paper`, `10pt`, and `12pt` are
  supported through the base `article` class. Set custom margins with `\geometry`
  in the preamble if needed.
- `signed` includes the configured signature. Without a signature option, the
  closing leaves space for a handwritten signature.
- `initialed` and `firstname` use their respective configured images. Select only
  one signature option. Missing configuration or files produce compilation errors.
- `nohead` omits the logo and contact block; `\noHead` has the same effect.
- `footer` adds the department name to the first-page footer; `\noFoot` disables it.
  Continuation pages show the sender name, date, and page number.
- `\cc{Names}` and `\encl{Items}` add copies and enclosures.
- `\memo{To}{From}{Subject}` and `\fax{To}{From}{Subject}{Fax number}{Pages}`
  start a new document section with a masthead and metadata.
- A new `\opening` starts a new letter and resets its page count. The closing is
  an indivisible block and moves to the next page if necessary.

## Migration from version 2

Existing `\to`, `\opening`, `\closing`, `\memo`, `\fax`, `\cc`, and `\encl`
commands remain available. Legacy profiles redefining `\me`, `\mytitle`, `\phone`,
and `\personal` still work. Extensionless `\SigPic`, `\InitPic`, and `\NickPic`
image names are supported as fallbacks.

The visual layout has changed intentionally: measured masthead columns, normal
recipient order, fixed opening spacing, and an aligned closing replace absolute
coordinates and stretchable vertical gaps. Legacy `\SigPut`, `\InitPut`, and
`\NickPut` coordinates no longer affect positioning. `\extend` now prints ordinary
text without artificial letter spacing. The old optional footer graphic and
unfinished envelope export have been removed. No sender identity is built into
the class; the included profile remains an example that must be personalized.

## Validation

Run the compilation checks with Python 3 and `pdflatex`:

```sh
python3 tests/check.py
```

They cover signed/unsigned and multipage letters, longer sender information,
A4 and 12-point type, legacy profiles, absent profiles, memos/faxes, alternative
signature modes, and expected failures. If `pdftotext` is installed, they also
check continuation-page text and absence of inherited sender details.

## Source and attribution

Based on the **UConn Stat Department Letter Head** download on
[Jun Yan's Miscellaneous page](https://statcomp.org/misc.html):
[UConnStatLH.tgz](https://merlot.stat.uconn.edu/~jyan/docs/UConnStatLH.tgz).

Jun Yan adapted the original class from `UIlh.cls` by Russ Lenth. Version 2 was
dated October 20, 2017. Version 3 redesigns the class and examples; the original
logo and signature assets are retained. The initial Git commit preserves the
imported source and sample PDF.

The original archive contains no license file. No new license is assigned by
this revision.
