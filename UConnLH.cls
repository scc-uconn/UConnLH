\NeedsTeXFormat{LaTeX2e}[2022/06/01]
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
\RequirePackage{xurl}
\geometry{left=1in,right=1in,top=.75in,bottom=.85in,headheight=14pt,headsep=.2in}
\setlength{\parindent}{0pt}
\setlength{\parskip}{.65\baselineskip plus 1pt}
\AtBeginDocument{\raggedright\widowpenalty=10000\displaywidowpenalty=10000}

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
\newlength{\UConnLH@mastheadoverhang}
\setlength{\UConnLH@mastheadoverhang}{.35in}
\newlength{\UConnLH@mastheadlift}
\setlength{\UConnLH@mastheadlift}{.5in}
\newlength{\UConnLH@senderwidth}
\setlength{\UConnLH@senderwidth}{2in}
\newlength{\UConnLH@senderxshift}
\setlength{\UConnLH@senderxshift}{-.15in}
\newlength{\UConnLH@senderyshift}
\setlength{\UConnLH@senderyshift}{0in}
\newlength{\UConnLH@dategap}
\setlength{\UConnLH@dategap}{.3in}
\def\UConnLH@senderfontsize{7}
\newsavebox{\UConnLH@contactbox}
\newsavebox{\UConnLH@logobox}
\newsavebox{\UConnLH@encllabel}
\newlength{\UConnLH@senderraise}
\newcommand{\extend}[1]{#1} % Compatibility; no artificial letter spacing.
\newcommand{\personal}{%
  \ifx\me\@empty\else\me\ifx\mytitle\@empty\else, \fi\fi
  \ifx\mytitle\@empty\else\mytitle\\\fi
  \ifx\mytitle\@empty\ifx\me\@empty\else\\\fi\fi
  \UConnLH@department
  \ifx\UConnLH@address\@empty\else\\\UConnLH@address\fi
  \ifx\phone\@empty\else\\\phone\fi
  \ifx\UConnLH@email\@empty\else\\\UConnLH@email\fi
  \ifx\UConnLH@website\@empty\else\\{\urlstyle{same}%
    \expandafter\url\expandafter{\UConnLH@website}}\fi}
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
\define@key{UConnLH}{masthead-overhang}{\setlength{\UConnLH@mastheadoverhang}{#1}}
\define@key{UConnLH}{masthead-lift}{\setlength{\UConnLH@mastheadlift}{#1}}
\define@key{UConnLH}{sender-width}{\setlength{\UConnLH@senderwidth}{#1}}
\define@key{UConnLH}{sender-xshift}{\setlength{\UConnLH@senderxshift}{#1}}
\define@key{UConnLH}{sender-yshift}{\setlength{\UConnLH@senderyshift}{#1}}
\define@key{UConnLH}{sender-font-size}{\def\UConnLH@senderfontsize{#1}}
\define@key{UConnLH}{date-gap}{\setlength{\UConnLH@dategap}{#1}}
\define@key{UConnLH}{closing}{\renewcommand{\sincerely}{#1}}
\newcommand{\UConnLHsetup}[1]{\setkeys{UConnLH}{#1}}
% Sender configuration belongs in the document preamble. An optional shared
% profile can be loaded explicitly with \input{./letterinfo.sty} after the class.
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
    \sbox{\UConnLH@logobox}{%
      \IfFileExists{\UConnLogo}{\includegraphics[width=\UConnLH@logowidth]{\UConnLogo}}{%
        \ClassError{UConnLH}{Logo file '\UConnLogo' not found}{Set logo to an existing image with \string\UConnLHsetup.}}}%
    % The masthead deliberately occupies the margins; the letter body does not.
    \vspace*{-\UConnLH@mastheadlift}%
    \noindent\makebox[\textwidth][l]{%
    \hspace*{-\UConnLH@mastheadoverhang}%
    \begin{minipage}{\dimexpr\textwidth+2\UConnLH@mastheadoverhang\relax}
    \begin{minipage}[t]{.53\linewidth}
      \vspace{0pt}%
      \usebox{\UConnLH@logobox}%
    \end{minipage}\hfill
    \begin{minipage}[t]{\UConnLH@senderwidth}
      \vspace{0pt}%
      \sbox{\UConnLH@contactbox}{%
        \begin{minipage}[t]{\linewidth}
          \raggedright\fontfamily{phv}%
          \fontsize{\UConnLH@senderfontsize}{\fpeval{1.2*\UConnLH@senderfontsize}}\selectfont\personal
        \end{minipage}}%
      % The rule occupies the gap to the left, keeping the text position fixed.
      % Align vertical centers after wrapping, then apply an optional offset.
      \setlength{\UConnLH@senderraise}{\dimexpr
        .5\dp\UConnLH@contactbox-.5\ht\UConnLH@logobox-.5\dp\UConnLH@logobox
        +\UConnLH@senderyshift\relax}%
      \raisebox{\UConnLH@senderraise}[0pt][%
        \dimexpr\dp\UConnLH@contactbox-\UConnLH@senderraise\relax]{%
      \makebox[0pt][r]{%
        \rule[-\dp\UConnLH@contactbox]{2.8pt}{%
          \dimexpr\ht\UConnLH@contactbox+\dp\UConnLH@contactbox\relax}%
        \hspace{.125in}}%
      \usebox{\UConnLH@contactbox}}%
    \end{minipage}\hspace*{-\UConnLH@senderxshift}%
    \end{minipage}}\par
    \vspace{\UConnLH@dategap}%
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
    \ifx\UConnLH@sigmode\UConnLH@signaturemode
      \ifcsname SigPic\endcsname\edef\UConnLH@image{\SigPic}\fi
    \else\ifx\UConnLH@sigmode\UConnLH@initialsmode
      \ifcsname InitPic\endcsname\edef\UConnLH@image{\InitPic}\fi
    \else\ifcsname NickPic\endcsname\edef\UConnLH@image{\NickPic}\fi\fi\fi
  \fi
  \ifx\UConnLH@image\@empty
    \ClassError{UConnLH}{No signature image configured}{Set signature, initials, or firstname with \string\UConnLHsetup, or remove the signature option.}%
  \else
    \includegraphics[height=\UConnLH@sigheight,width=\linewidth,keepaspectratio]{\UConnLH@image}%
  \fi}
\newcommand{\closing}[1][\sincerely]{%
  \par\nobreak\addvspace{\baselineskip}\nobreak
  % Equal stretch above and below centers the closing in the remaining space,
  % including when the last body lines and closing move to a new page.
  \vfill\nobreak\noindent\hfill
  \begin{minipage}{\UConnLH@closingwidth}
    \setlength{\parskip}{0pt}%
    \raggedright #1,\par\smallskip
    \ifUConnLH@signed\UConnLH@insertSignature\par\smallskip
    \else\vspace{.45in}\fi
    \ifx\me\@empty
      \ClassWarning{UConnLH}{Sender name is empty; set name with \string\UConnLHsetup}%
    \else\me\fi
    \ifx\mytitle\@empty\else\\\mytitle\fi
  \end{minipage}\par\nobreak\vfill}
\newcommand{\encl}[2][Encl:]{\par\addvspace{\baselineskip}%
  \begingroup\sbox{\UConnLH@encllabel}{#1}%
  \noindent\usebox{\UConnLH@encllabel}\hspace{.25in}%
  \begin{minipage}[t]{\dimexpr\linewidth-\wd\UConnLH@encllabel-.25in\relax}
    \raggedright #2
  \end{minipage}\par\endgroup}
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
