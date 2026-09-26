\NeedsTeXFormat{LaTeX2e}[2020/10/01]
\ProvidesClass{UConnLH}[2026/09/26 v3.0 UConn Statistics letterhead]
% Jun Yan; adapted originally from UIlh.cls by Russ Lenth.
% Version 3 replaces coordinate-based layout with measured, flowing boxes.
\newif\ifUConnLH@signed
\newif\ifUConnLH@head
\newif\ifUConnLH@foot
\UConnLH@headtrue
\newcount\UConnLH@sigoptions
\def\UConnLH@sigmode{signature}
\DeclareOption{signed}{\UConnLH@signedtrue\advance\UConnLH@sigoptions by 1}
\DeclareOption{initialed}{\UConnLH@signedtrue\def\UConnLH@sigmode{initials}\advance\UConnLH@sigoptions by 1}
\DeclareOption{firstname}{\UConnLH@signedtrue\def\UConnLH@sigmode{firstname}\advance\UConnLH@sigoptions by 1}
\DeclareOption{nohead}{\UConnLH@headfalse}
\DeclareOption{footer}{\UConnLH@foottrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\PassOptionsToClass{letterpaper,11pt}{article}
\ProcessOptions\relax
\ifnum\UConnLH@sigoptions>1
  \ClassError{UConnLH}{Conflicting signature options}{Choose only one of signed, initialed, or firstname.}
\fi
\LoadClass{article}
\RequirePackage[T1]{fontenc}
\RequirePackage{bookman}
\RequirePackage{graphicx}
\RequirePackage{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{keyval}
\geometry{left=1in,right=1in,top=.75in,bottom=.85in,headheight=14pt,headsep=.2in}
\setlength{\parindent}{0pt}
\setlength{\parskip}{.65\baselineskip plus 1pt}
\AtBeginDocument{\raggedright}

% Public fields retain the original commands for existing letters.
\newcommand{\me}{}
\newcommand{\mytitle}{}
\newcommand{\phone}{}
\newcommand{\sincerely}{Sincerely yours}
\newcommand{\UConnLogo}{UConn-stacked.png}
\def\UConnLH@department{Department of Statistics}
\def\UConnLH@address{}
\def\UConnLH@email{}
\def\UConnLH@website{}
\def\UConnLH@date{\today}
\def\UConnLH@signature{}
\def\UConnLH@initials{}
\def\UConnLH@firstname{}
\newlength{\UConnLH@logowidth}
\setlength{\UConnLH@logowidth}{2.4in}
\newlength{\UConnLH@sigheight}
\setlength{\UConnLH@sigheight}{1cm}
\newlength{\UConnLH@closingwidth}
\setlength{\UConnLH@closingwidth}{.45\textwidth}
\newcommand{\extend}[1]{#1} % Compatibility; no artificial letter spacing.
\newcommand{\personal}{%
  \UConnLH@department
  \ifx\me\@empty\else\\\me\fi
  \ifx\mytitle\@empty\else\\\mytitle\fi
  \ifx\UConnLH@address\@empty\else\\\UConnLH@address\fi
  \ifx\phone\@empty\else\\\phone\fi
  \ifx\UConnLH@email\@empty\else\\\UConnLH@email\fi
  \ifx\UConnLH@website\@empty\else\\\UConnLH@website\fi}
\define@key{UConnLH}{name}{\renewcommand{\me}{#1}}
\define@key{UConnLH}{title}{\renewcommand{\mytitle}{#1}}
\define@key{UConnLH}{phone}{\renewcommand{\phone}{#1}}
\define@key{UConnLH}{department}{\def\UConnLH@department{#1}}
\define@key{UConnLH}{address}{\def\UConnLH@address{#1}}
\define@key{UConnLH}{email}{\def\UConnLH@email{#1}}
\define@key{UConnLH}{website}{\def\UConnLH@website{#1}}
\define@key{UConnLH}{date}{\def\UConnLH@date{#1}}
\define@key{UConnLH}{signature}{\def\UConnLH@signature{#1}}
\define@key{UConnLH}{initials}{\def\UConnLH@initials{#1}}
\define@key{UConnLH}{firstname}{\def\UConnLH@firstname{#1}}
\define@key{UConnLH}{logo}{\renewcommand{\UConnLogo}{#1}}
\define@key{UConnLH}{logo-width}{\setlength{\UConnLH@logowidth}{#1}}
\define@key{UConnLH}{signature-height}{\setlength{\UConnLH@sigheight}{#1}}
\define@key{UConnLH}{closing-width}{\setlength{\UConnLH@closingwidth}{#1}}
\define@key{UConnLH}{closing}{\renewcommand{\sincerely}{#1}}
\newcommand{\UConnLHsetup}[1]{\setkeys{UConnLH}{#1}}
% Load only the working-directory profile, never an unrelated TeX installation file.
\InputIfFileExists{./letterinfo.sty}{}{}
\providecommand{\SigPic}{}
\providecommand{\InitPic}{}
\providecommand{\NickPic}{}
\newcommand{\noHead}{\UConnLH@headfalse}
\newcommand{\noFoot}{\UConnLH@footfalse}

% A separate recipient label avoids multiline addresses in running headers.
\def\UConnLH@recipient{}
\def\UConnLH@organization{}
\renewcommand{\to}[2]{\def\UConnLH@organization{#1}\def\UConnLH@recipient{#2}}
\fancypagestyle{UConnLH}{%
  \fancyhf{}
  \fancyhead[L]{\small\me}
  \fancyhead[R]{\small\UConnLH@date}
  \fancyfoot[C]{\small\thepage}
  \renewcommand{\headrulewidth}{0pt}}
\fancypagestyle{UConnLHfirst}{%
  \fancyhf{}
  \fancyfoot[C]{\ifUConnLH@foot\small\UConnLH@department\fi}
  \renewcommand{\headrulewidth}{0pt}}
\pagestyle{UConnLH}

\newcommand{\makeLetterhead}[1]{%
  \clearpage\setcounter{page}{1}\thispagestyle{UConnLHfirst}%
  \ifUConnLH@head
    \noindent\begin{minipage}[t]{.53\textwidth}
      \vspace{0pt}%
      \IfFileExists{\UConnLogo}{\includegraphics[width=\UConnLH@logowidth]{\UConnLogo}}{%
        \ClassError{UConnLH}{Logo file '\UConnLogo' not found}{Set logo to an existing image with \string\UConnLHsetup.}}
    \end{minipage}\hfill
    \begin{minipage}[t]{.43\textwidth}
      \vspace{0pt}\raggedright\sffamily\fontsize{9}{11}\selectfont\personal
    \end{minipage}\par\vspace{.4in}%
  \fi
  #1\par\vspace{.25in}}
\newcommand{\opening}[1]{%
  \makeLetterhead{\UConnLH@date}%
  \ifx\UConnLH@recipient\@empty\else\UConnLH@recipient\par\nopagebreak\fi
  \ifx\UConnLH@organization\@empty\else
    {\setlength{\parskip}{0pt}\UConnLH@organization\par}\nopagebreak
  \fi
  \vspace{.5\baselineskip}#1\par\nobreak}

% Graphics are resolved only when needed; legacy extensionless names work.
\newcommand{\UConnLH@insertSignature}{%
  \edef\UConnLH@image{\csname UConnLH@\UConnLH@sigmode\endcsname}%
  \ifx\UConnLH@image\@empty
    \def\UConnLH@signaturemode{signature}\def\UConnLH@initialsmode{initials}%
    \ifx\UConnLH@sigmode\UConnLH@signaturemode\edef\UConnLH@image{\SigPic}%
    \else\ifx\UConnLH@sigmode\UConnLH@initialsmode\edef\UConnLH@image{\InitPic}%
    \else\edef\UConnLH@image{\NickPic}\fi\fi
  \fi
  \ifx\UConnLH@image\@empty
    \ClassError{UConnLH}{No signature image configured}{Set signature, initials, or firstname with \string\UConnLHsetup, or remove the signature option.}%
  \else
    \includegraphics[height=\UConnLH@sigheight,width=\linewidth,keepaspectratio]{\UConnLH@image}%
  \fi}
\newcommand{\closing}[1][\sincerely]{%
  \par\addvspace{\baselineskip}\noindent\hfill
  \begin{minipage}{\UConnLH@closingwidth}
    \raggedright #1,\par\smallskip
    \ifUConnLH@signed\UConnLH@insertSignature\par\smallskip
    \else\vspace{.45in}\fi
    \ifx\me\@empty
      \ClassWarning{UConnLH}{Sender name is empty; set name with \string\UConnLHsetup}%
    \else\me\fi
    \ifx\mytitle\@empty\else\\\mytitle\fi
  \end{minipage}\par}
\newcommand{\encl}[2][Encl:]{\par\addvspace{\baselineskip}%
  \noindent\begin{tabular}{@{}l@{\quad}p{.8\linewidth}@{}}#1&#2\end{tabular}\par}
\newcommand{\cc}[1]{\encl[cc:]{#1}}
\newcommand{\memo}[3]{%
  \makeLetterhead{\textbf{Memorandum}}%
  \begin{tabular}{@{}l@{\quad}p{.8\linewidth}@{}}
    To:&#1\\From:&#2\\Date:&\UConnLH@date\\Subject:&#3
  \end{tabular}\par\addvspace{\baselineskip}}
\newcommand{\fax}[5]{%
  \makeLetterhead{\textbf{Fax transmission}}%
  \begin{tabular}{@{}l@{\quad}p{.7\linewidth}@{}}
    To:&#1\\From:&#2\\Date:&\UConnLH@date\\Subject:&#3\\Fax:&#4\\Pages:&#5
  \end{tabular}\par
  If there are problems with this transmission, please call \me\ at \phone.\par}
\endinput
