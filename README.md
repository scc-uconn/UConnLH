# UConn Statistics Letterhead

LaTeX letterhead for the University of Connecticut Department of Statistics,
maintained by the Statistics Computing Committee (`scc-uconn`). Version 3 provides
a flowing layout, configurable sender information, and continuation-page headers.

[View the example letter](SampleLetter.pdf).

## Getting started

Install TeX Live, MacTeX, or MiKTeX with `bookman`, `graphicx`, `geometry`,
`fancyhdr`, and `xurl`, using LaTeX dated June 2022 or later. From this directory, run:

```sh
pdflatex SampleLetter.tex
```

Copy `SampleLetter.tex` to a new file in this directory. Edit its
`\UConnLHsetup` block to supply your name, title, contact details, and signature,
then replace the recipient and body. Compile it with `pdflatex YourLetter.tex`.
No separate sender setup file is required:

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

Values containing commas
must be enclosed in braces. Use `\\` for address line breaks. The recipient's
name prints first, followed by the organization/address supplied to `\to`.

## Optional shared sender settings

If you write many letters, personalize the included [letterinfo.sty](letterinfo.sty)
template once and reuse it:

1. Keep `letterinfo.sty` in the directory from which you compile your letters.
2. Edit its `\UConnLHsetup{...}` block with your contact details and signature
   image path. Set `website = {}` if you do not have a website.
3. Remove the sender settings block from your letter's preamble and replace it
   with `\input{./letterinfo.sty}`, immediately after `\documentclass`.
4. Add any per-letter overrides after that input; later settings take precedence.

```tex
\documentclass[signed]{UConnLH}
\input{./letterinfo.sty}
% Optional overrides for this letter:
\UConnLHsetup{title={Professor}}
\begin{document}
\to{Example University}{Dr. Recipient}
\opening{Dear Dr. Recipient:}
Thank you for your correspondence.
\closing
\end{document}
```

This file is optional and is not loaded automatically. Keep the settings inline
when you prefer one editable letter source. The same shared file can be used
with memos and fax cover sheets. Use `\input`, rather than `\usepackage`, to load
this settings template. Image paths are relative to the compilation directory.

## Configuration

| Key | Meaning / default |
| --- | --- |
| `name`, `title`, `phone`, `email`, `website`, `address` | Sender fields; empty unless configured |
| `department` | Department of Statistics |
| `date` | `\today`; override for a fixed date |
| `closing` | Sincerely yours; `\closing[Best regards]` overrides it for one letter |
| `signature`, `initials`, `firstname` | Image path for the corresponding class option |
| `logo` | `UConn-stacked.png` |
| `logo-width` | `2.4in` |
| `signature-height` | `1cm`; image width is also constrained to the closing block |
| `closing-width` | `0.45\textwidth` |
| `masthead-overhang` | `0.35in` into each side margin |
| `masthead-lift` | `0.5in` upward into the top margin |
| `sender-width` | `2in`; increasing it expands the block leftward |
| `sender-xshift` | `-0.15in`; negative moves left, positive moves right |
| `sender-yshift` | `0in`: sender and logo share a horizontal centerline; positive moves up, negative moves down |
| `sender-font-size` | `7` points, in Helvetica; supply a number without units |
| `date-gap` | `0.3in` below the masthead |

Use ordinary LaTeX escaping for special characters in text, such as `\&` and `\_`.
Website URLs wrap automatically, including long paths. Supply the URL as ordinary
text, such as `website = {https://example.edu/people/alex_example}`. To omit the
website, set `website = {}` (this also clears the website inherited from a profile).
The sender's name and title share a line when they fit and wrap when needed.
The included logo is the image from the original archive.
The masthead extends into the top and side margins, independently of the body
text. Its sender block is 2 inches wide; longer fields wrap within that block.
The sender uses the original Helvetica font at 7 points, without artificial
letter spacing. Sender width and horizontal position can be adjusted independently
of the logo, and `date-gap` controls the space below the masthead.
The sender block is measured after text wrapping and vertically centered against
the logo. Fewer rows shrink it around that centerline; additional rows expand it
above and below. Omitting the website therefore adjusts placement automatically.

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
  an indivisible block and stays with the end of the preceding paragraph. When
  space is insufficient, the final body lines move with it to the next page.
  Remaining vertical space is divided above and below the closing, centering
  the signature block in the space left after the body.
  To keep a borderline letter on one page, shorten its text or adjust margins;
  the class does not automatically shrink type or overflow the bottom margin.

## Memos

See [SampleMemo.tex](SampleMemo.tex) for a complete editable example and
[SampleMemo.pdf](SampleMemo.pdf) for its output. Compile it with
`pdflatex SampleMemo.tex`; its sender settings are included in the preamble.

Use `\memo{To}{From}{Subject}` instead of `\to` and `\opening`. It starts a new
page, prints the masthead and a **Memorandum** heading, and supplies To, From,
Date, and Subject fields. Write the memo body immediately afterward:

```tex
\documentclass{UConnLH}
\UConnLHsetup{name={Jun Yan},title={Professor},email={jun.yan@uconn.edu}}
\begin{document}
\memo{Statistics Computing Committee}{Jun Yan}{Computing resources}
Please review the proposed computing resources before our next meeting.
\end{document}
```

Memos do not insert a signature automatically. For a signed memo, use the
`signed` option, configure `signature`, and add `\closing` after the body.
Use `\UConnLHsetup{date={October 1, 2026}}` in the preamble to set a fixed date.

## Fax cover sheets

The five arguments of `\fax` are **recipient, sender, subject, fax number,
page count**, in that order. It prints a masthead, metadata, and a contact sentence
using the configured sender name and phone number:

```tex
\documentclass{UConnLH}
\UConnLHsetup{name={Jun Yan},title={Professor},phone={(860) 486-3416}}
\begin{document}
\fax{Dr. Recipient}{Jun Yan}{Requested documents}{(860) 555-0100}{3}
Please find the requested documents attached.
\end{document}
```

Supply the total page count yourself, including the cover sheet; it is not
calculated automatically. Neither `\opening` nor `\to` is needed for a fax.

## Copies, enclosures, and custom closings

These commands are optional additions to a letter:

```tex
\closing[Best regards]
\cc{Dr. Colleague\\Department administrator}
\encl{Curriculum vitae\\Research statement}
```

`\closing` adds the comma after the closing phrase, so do not include one in
its optional argument. `\encl[Attachments:]{Report}` supplies a custom label.
Use `\\` to separate multiple recipients or enclosure items.

## Multiple letters in one document

Repeat `\to`, `\opening`, the body, and `\closing` for each letter. Each opening
starts a new page and resets numbering. To change the sender or date between
letters, issue `\clearpage` before calling `\UConnLHsetup`, so the previous
letter's running header retains its settings. Each `\memo` or `\fax` also starts a new
page and resets numbering.

## Migration from version 2

Existing `\to`, `\opening`, `\closing`, `\memo`, `\fax`, `\cc`, and `\encl`
commands remain available. Legacy profiles redefining `\me`, `\mytitle`, `\phone`,
and `\personal` still work when explicitly loaded with `\input{./letterinfo.sty}`
after `\documentclass`. Extensionless `\SigPic`, `\InitPic`, and `\NickPic`
image names are supported as fallbacks.

The visual layout has changed intentionally: measured masthead columns, normal
recipient order, fixed opening spacing, and an aligned closing replace absolute
coordinates and stretchable vertical gaps. Legacy `\SigPut`, `\InitPut`, and
`\NickPut` coordinates no longer affect positioning. `\extend` now prints ordinary
text without artificial letter spacing. The old optional footer graphic and
unfinished envelope export have been removed. No sender identity is built into
the class; the sample letter contains example settings that must be personalized.

## Validation

Run the compilation checks with Python 3 and `pdflatex`:

```sh
python3 tests/check.py
python3 tests/layout_sweep.py
```

They cover signed/unsigned and multipage letters, longer sender information,
A4 and 12-point type, legacy profiles, absent profiles, memos/faxes, alternative
signature modes, and expected failures. If `pdftotext` is installed, they also
check continuation-page text and absence of inherited sender details.
The layout sweep requires `pdftotext` and checks 149 layouts across varying
letter lengths, paper sizes, font sizes, and closely spaced page boundaries.

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
