\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{UConnLH}[2017/10/20 Univ of Connecticut, Statistics, letterhead]
% \ProvidesClass{UConnLH}[2008/01/26 Univ of Connecticut, Statistics, letterhead]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UConnLH.cls                                           %
% Author    Jun Yan adapted from UIlh.cls by Russ Lenth %
% Version   2.0  October 20, 2017                       %
% Version   1.0  January 26, 2008                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Changes in Version 2.0: UConn has a new logo

%%% Root name of masthead graphic file
% \newcommand{\UConnLogo}{UConnStatTop} % File name for UConnStat logo PostScript file
\newcommand{\UConnLogo}{UConn-stacked} % File name for UConn logo
% \newcommand{\UConnStatFoot}{UConnStatLowerLeft} 

%%% Options
\newcommand{\@sigpic}{} % default signature "graphic"
\newcommand{\@sigput}{\put(0,0)} % signature location in inches
\DeclareOption{signed}{
  \renewcommand{\@sigpic}{\put(8,-0.55){\includegraphics[height=1cm]{\SigPic}}}
  \renewcommand{\@sigput}{\SigPut}}
\DeclareOption{initialed}{
  \renewcommand{\@sigpic}{\includegraphics{\InitPic}}
  \renewcommand{\@sigput}{\InitPut}}
\DeclareOption{firstname}{
  \renewcommand{\@sigpic}{\includegraphics{\NickPic}}
  \renewcommand{\@sigput}{\NickPut}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

%%% Use article as base class (with any leftover options)
\LoadClass{article}
\RequirePackage{bookman}
\RequirePackage{graphicx}
\RequirePackage{ifthen}

%%% Fonts
\DeclareFixedFont{\footfont}{OT1}{phv}{m}{n}{7}
\newcommand{\memofont}{\large\sc}

%%% Fancy hack to put extra space between characters
%%% Usage: \extend{STRING TO BE STRETCHED}
\def\@mygap{\rule{.5pt}{0pt}}
\def\extend#1{\@extend#1~}
\def\@extend#1{\@ifnextchar~{#1}{#1\@mygap\@extend}}

%%% Macros to allow for blocking of masthead or footer
\def\noHead{\gdef\@usehead{0}}
\def\noFoot{\gdef\@usefoot{0}}
\def\@usehead{1}
%\def\@usefoot{1}
\def\@usefoot{0}

%%% Internal macros to be used later
\newcommand{\@signature}{\parbox{8cm}{\me\\*\mytitle}}
\renewcommand{\to}[2]{\def\@to{#1}\def\@toaddr{#2}}
\to{~}{~}   %%% initialize, just in case

\def\@putSig{\begin{picture}(0,0)\@sigput{\@sigpic}\end{picture}}

\clearpage\raggedright%
\setlength{\parindent}{0pt}%
\setlength{\parskip}{8pt}%
\setlength{\oddsidemargin}{0in}%
\setlength{\evensidemargin}{\oddsidemargin}%
\setlength{\textwidth}{6.75in}%
\setlength{\topmargin}{-.5in}%{0pt}%
\setlength{\headheight}{12pt}%
\setlength{\headsep}{24pt}%
\setlength{\footskip}{25pt}%
\setlength{\textheight}{9.5in}%{8.75in}%
\large\normalsize
  
\newlength{\@part@skip}
\setlength{\@part@skip}{1\parskip plus .5\parskip minus \parskip}

% \setlength{\unitlength}{1in}%%% for picture environments
\setlength{\unitlength}{1cm}%%% for picture environments

%%% This macro initializes the page parameters and
%%% draws the letterhead.  
%%% The argument is what is put under the gold bar
\newcommand{\makeLetterhead}[1]{%
  \clearpage
  \thispagestyle{empty}\setcounter{page}{1}%
%  \begin{picture}(3,1.0)%%%(3,.5)%
  \begin{picture}(15, 2.8)%
%     \put(0,0){#1}
%     \ifthenelse{\@usehead = 1}{\put(-.325,.335){\includegraphics{\UIlogo}}}{}
%     \ifthenelse{\@usefoot = 1}{\put(4.5,-8.5){\@myfoot}}{}
    \put(0,0){#1}
    \ifthenelse{\@usehead = 1}{\put(0, 2.5){\includegraphics[width=6cm]{\UConnLogo}}}{}%
    \ifthenelse{\@usehead = 1}{\put(13.5, 3){\@myfoot}}{}%
    \ifthenelse{\@usefoot = 1}{\put(13.5, -22){\@myfoot}}{}%
    \ifthenelse{\@usefoot = 1}{\put(-1.8,-22){\includegraphics[width=5cm]{\UConnStatFoot}}}{}%
  \end{picture}
  \enlargethispage{-.5in}}

%%% Opening of the letter
\newcommand{\opening}[1]{%
  \makeLetterhead{\today}%
  \vspace{\parskip}\vfill 
  % \vspace{\parskip}\vspace{4pt}
  {\raggedright \@to \\ \@toaddr}\par%%% \\*[\@part@skip]
  {\def\\{\noexpand\\}\def~{\noexpand~}\def\emph{\noexpand\emph}%
     \def\em{\noexpand\em}\def\bf{\noexpand\bf}%
     \immediate\write12{\noexpand\envelope|\@to \\ 
     \@toaddr|Russell V.~Lenth|}}%%%%%% (Put entry in the envelope file)
  \markright{{\@to: \today}}
  #1\par\nobreak}

%%% Closing of the letter
\newcommand{\closing}[1][\hspace{8cm}\sincerely]{%
    \vspace{\@part@skip}\par \nobreak 
    \hspace{8cm} 
    \parbox{.95\textwidth}{%
    \@putSig%
    #1,\vspace{.55in} 

    \hspace{8cm}\@signature}\vfill\vfill}


%%% \memo{TO}{FROM}{TOPIC} %%%
%%% Note the custom macro \me (see above) is handy for the FROM argument
\newcommand{\memo}[3]{%
    \to{Memorandum}{}%
    \makeLetterhead{{\memofont Memorandum}}%
    \vspace{\parskip}\par
    \markright{{{\sc Memorandum} to #1: \today}}
    {\raggedright
        \begin{picture}(0,0)\put(2.5,-.4){\@sigpic}\end{picture}%
        \makebox[.65in][l]{To:}\parbox[t]{5in}{#1}\\[8pt] 
        \makebox[.65in][l]{From:}\parbox[t]{5in}{#2}\\[8pt] 
        \makebox[.65in][l]{Date:}\today\\[8pt] 
        \makebox[.65in][l]{Topic:}\parbox[t]{5in}{#3}\vspace{\parskip}%
            \par\nobreak}}
    
%%% \fax{TO}{FROM}{TOPIC}{FAX NO}{PAGES}
\newcommand{\fax}[5]{%
  \makeLetterhead{{\memofont FAX Transmission for #1}}
    \vspace{\parskip}\par
    \markright{{{\sc FAX transmission} for #1: \today}}
    {\raggedright 
        {\bf Number of pages (including this sheet):\quad#5}\\
        If there are problems with this transmission, 
        please call \me, \phone
               
        \begin{picture}(0,0)\put(2.5,-.7){\@sigpic}\end{picture}%
        \makebox[1in][l]{To:}#1\\[8pt] 
        \makebox[1in][l]{FAX no.:}#4\\[8pt]
        \makebox[1in][l]{From:}#2\\[8pt] 
        \makebox[1in][l]{Date:}\today\\[8pt] 
        \makebox[1in][l]{Topic:}#3\vspace{\parskip}%
        \par\nobreak}}


%%% Commands for CCs and enclosures.  
%%% \encl generalizes, as can be seen in def of \cc
\newcommand{\encl}[2][encl:]{\par\nobreak\makebox[.5in][l]%
    {#1}\parbox[t]{6in}{#2}}
\newcommand{\cc}[1]{\encl[cc:]{#1}}

%%% The page style for subsequent pages
%%% (note that \opening and \memo set \thispagestyle{empty})
\pagestyle{myheadings}

%%% Needed information
%%% Customize in letterinfo.sty
\newcommand{\sincerely}{Sincerely yours}
\newcommand{\me}{Jun Yan}
\newcommand{\mytitle}{itle}
\newcommand{\phone}{860-486-3416}
\newcommand{\personal}{%
    \extend{Jun\ Yan}\\
    \extend{326\ CLAS\ }\\
    \extend{860-486-3416}\\
    \extend{jun.yan@uconn.edu}\\
    \extend{http://www.stat.uconn.edu/~jyan/}}

%%% Read personal information
\InputIfFileExists{letterinfo.sty}{}{%
    \ClassWarningNoLine{UConnLH}{%
        No letterinfo.sty file found. \MessageBreak
        \space \space No personal information will be
        included in the letterhead.
    }
}

%%% Set up footer
\newcommand{\@footinfo}{{\footfont\def\arraystretch{.667}%
  \begin{tabular}[b]{@{}l@{}}\personal\end{tabular}}}
\newlength{\@footht}
\settoheight{\@footht}{\@footinfo}
\addtolength{\@footht}{-1.5pt}
\newcommand{\@myfoot}{\rule{2.8pt}{\@footht}\hspace{.125in}\@footinfo}



%%% Set up envelope file
%\AtBeginDocument{\immediate\openout 12 = /tmp/envelope.data}
%\AtEndDocument{\closeout 12}

