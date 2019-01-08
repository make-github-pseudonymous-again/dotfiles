%% socg-lipics-v2018.cls 
%% Author:     Michael Hoffmann <hoffmann@inf.ethz.ch>
%% Revision: $Rev: 5935 $ from $Date: 2018-09-04 13:20:57 +0200 (Tue, 04 Sep 2018) $
%% wrapper around lipics-v2018 to obtain a more consistent line numbering
%% we patch/hack some relevant commands and environments and see what happens...

\NeedsTeXFormat{LaTeX2e}[2015/01/01]
\ProvidesClass{eurocg19-submission}[2018/10/29 v0.1 socg-wrapper]

%% prefix output by classname
\newcommand{\socgtypeout}[1]{\typeout{socg-lipics-v2018: #1}}%

%% process options
\RequirePackage{ifthen}
\RequirePackage{letltxmacro}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This block is copied over from the original lipics style to include
%% linenumbers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage[left,mathlines]{lineno}
\linenumbers
\renewcommand\linenumberfont{\normalfont\tiny\sffamily}
%%%% patch to cope with amsmath
%%%% http://phaseportrait.blogspot.de/2007/08/lineno-and-amsmath-compatibility.html
\newcommand*\patchAmsMathEnvironmentForLineno[1]{%
  \expandafter\let\csname old#1\expandafter\endcsname\csname #1\endcsname
  \expandafter\let\csname oldend#1\expandafter\endcsname\csname end#1\endcsname
  \renewenvironment{#1}%
     {\linenomath\csname old#1\endcsname}%
     {\csname oldend#1\endcsname\endlinenomath}}%
\newcommand*\patchBothAmsMathEnvironmentsForLineno[1]{%
  \patchAmsMathEnvironmentForLineno{#1}%
  \patchAmsMathEnvironmentForLineno{#1*}}%
\AtBeginDocument{%
  \patchBothAmsMathEnvironmentsForLineno{equation}%
  \patchBothAmsMathEnvironmentsForLineno{align}%
  \patchBothAmsMathEnvironmentsForLineno{flalign}%
  \patchBothAmsMathEnvironmentsForLineno{alignat}%
  \patchBothAmsMathEnvironmentsForLineno{gather}%
  \patchBothAmsMathEnvironmentsForLineno{multline}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% End block copied from lipics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% with noalgorithm2e, do not try to fix algorithm2e environments
\newboolean{socgnoalgorithm2e}\setboolean{socgnoalgorithm2e}{false}
\DeclareOption{noalgorithm2e}{\setboolean{socgnoalgorithm2e}{true}}
%% with noalgorithms, do not try to fix algorithms (algorithm/algorithmic) package
\newboolean{socgnoalgorithms}\setboolean{socgnoalgorithms}{false}
\DeclareOption{noalgorithms}{\setboolean{socgnoalgorithms}{true}}
%% with nosubfigcap, do not try to fix subcaptions
\newboolean{socgnosubfigcap}\setboolean{socgnosubfigcap}{false}
\DeclareOption{nosubfigcap}{\setboolean{socgnosubfigcap}{true}}
%% with notab, do not wrap tabular into edtable
\newboolean{socgnotab}\setboolean{socgnotab}{false}
\DeclareOption{notab}{\setboolean{socgnotab}{true}}
%% with notcolorbox, do not try to fix tcolorbox
\newboolean{socgnotcolorbox}\setboolean{socgnotcolorbox}{false}
\DeclareOption{notcolorbox}{\setboolean{socgnotcolorbox}{true}}
%% pass all the rest to LIPIcs
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{eurocg19}}
\ProcessOptions\relax

%% set all line numbering options for algorithm2e
\ifthenelse{\boolean{socgnoalgorithm2e}}{%
}{%
  \PassOptionsToPackage{linesnumbered,commentsnumbered,inoutnumbered,titlenumbered}{algorithm2e}
}%
%% set longtable -> edtable option to handle tabular
\ifthenelse{\boolean{socgnotab}}{%
}{%
  \PassOptionsToPackage{longtable}{lineno}}%
%% load LIPIcs class
\LoadClass{eurocg19}[2018/04/09]%

%% hide LIPIcs DOI
\def\@DOIPrefix{}

%% \socgnl = number line: allows to manually add the current linenumber to a
%% single line if placed at the start of that line
\newsavebox{\socgnlbox}%
\newcommand{\socgnl}{%
  \sbox{\socgnlbox}{\mbox{\linenumberfont\LineNumber\hskip\linenumbersep}}%
  \hspace*{-\wd\socgnlbox}\usebox{\socgnlbox}\stepcounter{linenumber}%
}

%% used in captions
\newcommand{\socglipicsyellowdot}{%
  \kern0.05em{\color[rgb]{0.99,0.78,0.07}\rule{0.73em}{0.73em}}\hspace*{0.67em}}

%% add line numbers to all captions
\DeclareCaptionTextFormat{socgnumberitall}{\internallinenumbers #1}
\captionsetup{textformat=socgnumberitall}%

%% handle subcaptions (this is a hack, really)
\ifthenelse{\boolean{socgnosubfigcap}}{
}{%
  \socgtypeout{fix subcaptions}
  \RequirePackage{zref-savepos}
  \newcounter{socgstartofnewfloat}\setcounter{socgstartofnewfloat}{0}
  \newcounter{socglinenumbertmp}\newcounter{socglinenumbermax}
  \newcounter{socgsubfigcount}\setcounter{socgsubfigcount}{0}
  \newcounter{socgsubfiglastpos}\setcounter{socgsubfiglastpos}{0}
  \let\socgsubcaption\subcaption%
  \def\subcaption#1{%
    \stepcounter{socgsubfigcount}%
    \zsavepos{\arabic{socgsubfigcount}}%
    \ifthenelse{\value{socgstartofnewfloat}=1\and\value{socgsubfiglastpos}>\zposx{\arabic{socgsubfigcount}}}{%
      \socgtypeout{add newline in Fig. \thefigure : \thesubfigure}%
      \setcounter{socgstartofnewfloat}{0}%
    }{%
    }%
    \setcounter{socgsubfiglastpos}{\zposx{\arabic{socgsubfigcount}}}%
    \ifthenelse{\value{socgstartofnewfloat}=0}{%
      \setcounter{socgstartofnewfloat}{1}%
      \setcounter{socglinenumbermax}{0}%
      \setcounter{socglinenumbertmp}{\value{linenumber}}%
    }{%
      \setcounter{linenumber}{\value{socglinenumbertmp}}
    }%
    \socgsubcaption{\internallinenumbers #1}%
    \ifthenelse{\value{linenumber} >\value{socglinenumbermax}}{%
      \setcounter{socglinenumbermax}{\value{linenumber}}}%
    {%
    }%
    \setcounter{linenumber}{\value{socglinenumbermax}}%
  }
  \let\socgendfigure\endfigure
  \def\endfigure{\setcounter{socgstartofnewfloat}{0}\socgendfigure}
  \let\socgendtable\endtable
  \def\endtable{\setcounter{socgstartofnewfloat}{0}\socgendtable}

  %% replace subfigure/caption by subcaption
  \renewcommand*\subcaption@minipage[2]{%
    \minipage#1{#2}%
    \renewcommand{\caption}[1]{\subcaption{##1}}\relax}%
}

%% number footnotes by wrapping them into a minipage
\let\socgfootnote=\footnote
\newcommand{\socgnumberfootnotes}{%
  \gdef\footnote##1{%
    \socgfootnote{%
      \begin{minipage}[t]{.978\linewidth}\internallinenumbers\setlength\linenumbersep{2em}
        ##1
      \end{minipage}\vspace{1pt plus .5pt minus .5pt}%
    }%
  }%
}

%% don't number frontmatter 
\let\socgrealmaketitle=\maketitle
\renewcommand{\maketitle}{\nolinenumbers\socgrealmaketitle\linenumbers}

%% ... not even subject classification, doi, etc.
\let\socgabstract=\abstract
\let\socgendabstract=\endabstract
\newcounter{socglastlinecounter}
\renewenvironment{abstract}{%
  \socgabstract%
}{%
  \par\begin{nolinenumbers}
    \socgendabstract
    \vskip\baselineskip\noindent
    \textcolor{darkgray}{\fontsize{9.5}{12.5}\sffamily\bfseries Lines\enskip}
    {\ifnum\value{socglastlinecounter}>500\color{red}\fi\arabic{socglastlinecounter}}
  \end{nolinenumbers}%
  \socgnumberfootnotes%
}
%% to list the lines, look where the references start
\AtBeginDocument{%
  \let\socgthebibliography=\thebibliography
  \renewcommand{\thebibliography}{%
    \setcounter{socglastlinecounter}{\value{linenumber}}%
    \addtocounter{socglastlinecounter}{-1}%
    \makeatletter\write\@auxout{\noexpand\setcounter{socglastlinecounter}{\thesocglastlinecounter}}\makeatother%
    \socgthebibliography}}

%% wrap tabular into edtable
\ifthenelse{\boolean{socgnotab}}{%
}{%
  \socgtypeout{fix tabular}
  \let\socgtabular\tabular%
  \let\endsocgtabular\endtabular%
  \renewenvironment{tabular}{\begin{edtable}{socgtabular}}{\end{edtable}}%
}

%% fix align etc. "double line number issue"
%% see https://tex.stackexchange.com/questions/436011/linenomath-printing-extra-numbers-on-last-line-of-multline-align-flalign-envir
\newcommand*{\socgPatchAmsMathEnvironmentForLineno}[1]{%
  \renewenvironment{#1}%
  {\linenomath\postdisplaypenalty=0\csname old#1\endcsname}%
  {\csname oldend#1\endcsname\endlinenomath}}%
\newcommand*\socgpatchBothAmsMathEnvironmentsForLineno[1]{%
  \socgPatchAmsMathEnvironmentForLineno{#1}%
  \socgPatchAmsMathEnvironmentForLineno{#1*}}%
\AtBeginDocument{%
  \socgpatchBothAmsMathEnvironmentsForLineno{align}%
  \socgpatchBothAmsMathEnvironmentsForLineno{flalign}%
  \socgpatchBothAmsMathEnvironmentsForLineno{alignat}%
  \socgpatchBothAmsMathEnvironmentsForLineno{gather}%
  \socgpatchBothAmsMathEnvironmentsForLineno{multline}}%

%% number tcolorboxes (just the vanilla ones...)
\ifthenelse{\boolean{socgnotcolorbox}}{%
}{%
  \socgtypeout{fix tcolorbox}
  \AtBeginDocument{%
    \@ifpackageloaded{tcolorbox}{%
      \LetLtxMacro\socgtcolorbox\tcolorbox%
      \LetLtxMacro\endsocgtcolorbox\endtcolorbox%
      \renewenvironment{tcolorbox}[1][]{%
        \nolinenumbers%
        \socgtcolorbox[#1]\internallinenumbers%
        \addtolength{\linenumbersep}{\kvtcb@leftupper}%
        \addtolength{\linenumbersep}{\kvtcb@boxsep}}{%
        \endsocgtcolorbox%
        \endnolinenumbers}%
    }{%
    }% package tcolorbox loaded 
  }% AtBeginDocument
}% if socgtcolorbox

%% fix algorithms
\ifthenelse{\boolean{socgnoalgorithms}}{%
}{%
  \newboolean{socgalgorithmicorx}\setboolean{socgalgorithmicorx}{false}
  \AtBeginDocument{%
    \@ifpackageloaded{algorithmic}{\setboolean{socgalgorithmicorx}{true}}{}
    \@ifpackageloaded{algorithmicx}{\setboolean{socgalgorithmicorx}{true}}{}
    \ifthenelse{\boolean{socgalgorithmicorx}}{%
      \socgtypeout{fix algorithmic(x)}%
      \LetLtxMacro\socgalgorithmic\algorithmic%
      \LetLtxMacro\endsocgalgorithmic\endalgorithmic%
      \renewenvironment{algorithmic}[1][]{%
        \socgalgorithmic[#1]\internallinenumbers}{%
        \endsocgalgorithmic}% end of environment algorithmic
    }{%
    }% package algorithmic or algorithmicx loaded 
    \@ifpackageloaded{algorithm}{%
      \socgtypeout{fix algorithm}
      \LetLtxMacro\socgalgorithms\algorithm%
      \LetLtxMacro\endsocgalgorithms\endalgorithm%
      \renewenvironment{algorithm}[1][]{%
        \socgalgorithms[#1]%
        \LetLtxMacro\socgcaption\caption%
        \renewcommand{\caption}[2][]{%
          \socgcaption[##1]{\internallinenumbers ##2}}%
      }{\endsocgalgorithms}% end of environment algorithm
    }{%
    }% package algorithm loaded 
  }% AtBeginDocument
}% if socgalgo
    
%% fix algorithm2e
\ifthenelse{\boolean{socgnoalgorithm2e}}{%
}{%
  \AtBeginDocument{%
    \@ifpackageloaded{algorithm2e}{%
      \socgtypeout{fix algorithm2e}%
      \expandafter\LetLtxMacro\expandafter\socgalgorithmte\csname\algocf@envname\endcsname%
      \expandafter\LetLtxMacro\expandafter\endsocgalgorithmte\csname end\algocf@envname\endcsname%
      \renewenvironment{\algocf@envname}[1][]{%
        \begin{nolinenumbers}%
          \socgalgorithmte[#1]%
          \SetAlCapFnt{\small\sffamily}%
          \SetAlCapNameFnt{\small\upshape}%
          \setcounter{AlgoLine}{\value{linenumber}}\addtocounter{AlgoLine}{-1}%
        }{%
          \ifthenelse{\value{linenumber}<\value{AlgoLine}}{%
            \setcounter{linenumber}{\value{AlgoLine}}\stepcounter{linenumber}%
          }{%
          }%
          \endsocgalgorithmte%
        \end{nolinenumbers}%
      }% end of environment algorithm2e
      %% font for line numbers
      \renewcommand{\relsize}[1]{\normalfont\tiny\sffamily}%
      \newcommand{\socgalgocaption}[2]{%
        \begin{minipage}[t]{\hsize}\internallinenumbers%
          \socglipicsyellowdot{#1}{~}\AlCapNameSty{\AlCapNameFnt{}#2}%
        \end{minipage}%
      }%
      %% there are two caption types: (1) above the code
      \renewcommand{\algocf@makecaption@ruled}[2]{%
        \global\sbox\algocf@capbox{\socgalgocaption{#1}{#2}}%
        \setcounter{AlgoLine}{\value{linenumber}}\addtocounter{AlgoLine}{-1}%
      }% end of algocf@makecaption@ruled
      %% ... and (2) below, which we dress more like the LIPIcs style
      \renewcommand{\algocf@makecaption}[2]{%
        \setcounter{linenumber}{\value{AlgoLine}}\stepcounter{linenumber}%
        \socgalgocaption{#1}{#2}%
      }% end of algocf@makecaption
    }{}% package algorithm2e loaded 
  }% AtBeginDocument
}% if socgalgo2e
    
\endinput

% Local Variables:
% mode: latex
% End: