" Keyword mappings are simply a dictionary. Dictionaries are of the form
" "quicktex_" and then the filetype. The result of a keyword is either a
" literal string or a double quoted string, depending on what you want.
"
" In a literal string, the result is just a simple literal substitution
"
" In a double quoted string, \'s need to be escape (i.e. "\\"), however, you
" can use nonalphanumberical keypresses, like "\<CR>", "\<BS>", or "\<Right>"
"
" Unfortunately, comments are not allowed inside multiline vim dictionaries.
" Thus, sections and comments must be included as entries themselves. Make
" sure that the comment more than one word, that way it could never be called
" by the ExpandWord function

" Math Mode Keywords {{{

let g:quicktex_math = {
    \' ' : "\<ESC>/<+.*+>\<CR>\"_c/+>/e\<CR>",
\'Section: Lowercase Greek Letters' : 'COMMENT',
    \'alpha'   : '\alpha ',
    \'ga'      : '\alpha ',
    \'beta'    : '\beta ',
    \'gamma'   : '\gamma ',
    \'delta'   : '\delta ',
    \'eps'     : '\epsilon ',
    \'veps'    : '\varepsilon ',
    \'zeta'    : '\zeta ',
    \'eta'     : '\eta ',
    \'theta'   : '\theta ',
    \'iota'    : '\iota ',
    \'kappa'   : '\kappa ',
    \'lambda'  : '\lambda ',
    \'gl'      : '\lambda ',
    \'mu'      : '\mu ',
    \'nu'      : '\nu ',
    \'xi'      : '\xi ',
    \'omega'   : '\omega ',
    \'pi'      : '\pi ',
    \'rho'     : '\rho ',
    \'sigma'   : '\sigma ',
    \'tau'     : '\tau ',
    \'upsilon' : '\upsilon ',
    \'phi'     : '\varphi ',
    \'chi'     : '\chi ',
    \'psi'     : '\psi ',
    \
\'Section: Uppercase Greek Letters' : 'COMMENT',
    \'Alpha'   : '\Alpha ',
    \'Beta'    : '\Beta ',
    \'Gamma'   : '\Gamma ',
    \'Delta'   : '\Delta ',
    \'Epsilon' : '\Epsilon ',
    \'Zeta'    : '\Zeta ',
    \'Eta'     : '\Eta ',
    \'Theta'   : '\Theta ',
    \'Iota'    : '\Iota ',
    \'Kappa'   : '\Kappa ',
    \'Lambda'  : '\Lambda ',
    \'Mu'      : '\Mu ',
    \'Nu'      : '\Nu ',
    \'Xi'      : '\Xi ',
    \'Omega'   : '\Omega ',
    \'Pi'      : '\Pi ',
    \'Rho'     : '\Rho ',
    \'Sigma'   : '\Sigma ',
    \'Tau'     : '\Tau ',
    \'Upsilon' : '\Upsilon ',
    \'Phi'     : '\Phi ',
    \'Psi'     : '\Psi ',
    \
\'Section: Set Theory' : 'COMMENT',
    \'bn'    : '\mathbb{N} ',
    \'bz'    : '\mathbb{Z} ',
    \'bq'    : '\mathbb{Q} ',
    \'br'    : '\mathbb{R} ',
    \'br2'   : '\mathbb{R}^2 ',
    \'br3'   : '\mathbb{R}^3 ',
    \'brd'   : '\mathbb{R}^d ',
    \'bc'    : '\mathbb{C} ',
    \'ba'    : '\mathbb{A} ',
    \'bf'    : '\mathbb{F} ',
    \'bx'    : '\mathbb{X} ',
    \'bs'    : '\mathbb{S} ',
    \'bi'    : '\mathbb{I} ',
    \'subs'  : '\subseteq ',
    \'psubs' : '\subset ',
    \'sups'  : '\supseteq ',
    \'psups' : '\supset ',
    \'in'    : '\in ',
    \'nin'   : '\not\in ',
    \'cup'   : '\cup ',
    \'cap'   : '\cap ',
    \'union' : '\cup ',
    \'sect'  : '\cap ',
    \'smin'  : '\setminus ',
    \'set'   : '\{\, <+++>\,\} <++>',
    \'card'  : '| <+++> | <++>',
    \'st'    : '\colon\, ',
    \'co'    : "\<BS>, ",
    \'empty' : '\emptyset ',
    \'pair'  : '(<+++>, <++>) <++>',
    \'dots'  : '\dots ',
    \'ldots' : '\ldots ',
    \'cdots' : '\cdots ',
    \
\'Section: Logic' : 'COMMENT',
    \'exists'  : '\exists ',
    \'nexists' : '\not\exists ',
    \'forall'  : '\forall ',
    \'implies' : '\implies ',
    \'iff'     : '\iff ',
    \'or'      : '\lor ',
    \'and'     : '\land ',
    \
\'Section: Relations' : 'COMMENT',
    \'lt'      : '< ',
    \'gt'      : '> ',
    \'le'      : '\leq ',
    \'ge'      : '\geq ',
    \'eq'      : '= ',
    \'nl'      : '\nless ',
    \'ne'      : '\neq ',
    \'neg'     : '\neg ',
    \'sim'     : '\sim ',
    \
\'Section: Operations' : 'COMMENT',
    \'plus'  : '+ ',
    \'minus' : '- ',
    \'fra'   : '\frac ',
    \'frac'  : '\frac{<+++>}{<++>} <++>',
    \'recip' : '\frac{1}{<+++>} <++>',
    \'cdot'  : '\cdot ',
    \'mult'  : '* ',
    \'exp'   : "e^{<+++>} <++>",
    \'po'    : "\<BS>^<+++>",
    \'pow'   : "\<BS>^{<+++>} <++>",
    \'sq'    : "\<BS>^2 ",
    \'cube'  : "\<BS>^3 ",
    \'inv'   : "\<BS>^{-1} ",
    \'pr'    : "\<BS>' ",
    \'times' : '\times ',
    \'min'   : '\min ',
    \'max'   : '\max ',
    \
\'Section: Delimiters' : 'COMMENT',
    \'bprn' : '\left( <+++> \right) <++>',
    \'prn'  : '(<+++>) <++>',
    \'bsb'   : '\left[ <+++> \right] <++>',
    \'sb'    : '[<+++>] <++>',
    \'bbra'  : '\left\{ <+++> \right\} <++>',
    \'bra'   : '\{<+++>\} <++>',
    \'grp'   : '{<+++>} <++>',
    \
\'Section: Group Theory' : 'COMMENT',
    \'sdp'   : '\rtimes ',
    \'niso'  : '\niso ',
    \'subg'  : '\leq ',
    \'nsubg' : '\trianglelefteq ',
    \'mod'   : '/ ',
    \
\'Section: Functions' : 'COMMENT',
    \'cln'    : '\colon ',
    \'to'     : '\to ',
    \'mapsto' : '\mapsto ',
    \'comp'   : '\circ ',
    \'of'     : "\<BS>(<+++>) <++>",
    \'sin'    : '\sin{<+++>} <++>',
    \'cos'    : '\cos{<+++>} <++>',
    \'tan'    : '\tan{<+++>} <++>',
    \'gcd'    : '\gcd(<+++> ,<++>) <++>',
    \'ln'     : '\ln{<+++>} <++>',
    \'lo'     : '\log <+++>',
    \'log'    : '\log{<+++>} <++>',
    \'df'     : '<+++> : <++> \to <++>',
    \'sqrt'   : '\sqrt{<+++>} <++>',
    \'root'   : '\sqrt[<+++>]{<++>} <++>',
    \'case'   : '\begin{cases} <+++> \end{cases} <++>',
    \'ceil'   : '\lceil <+++> \rceil <++>',
    \'floor'  : '\lfloor <+++> \rfloor <++>',
    \
\'Section: LaTeX commands' : 'COMMENT',
    \'sub'    : "\<BS>_{<+++>} <++>",
    \'su'     : "\<BS>_<+++>",
    \'s0'     : "\<BS>_0",
    \'s1'     : "\<BS>_1",
    \'s2'     : "\<BS>_2",
    \'s3'     : "\<BS>_3",
    \'s4'     : "\<BS>_4",
    \'sn'     : "\<BS>_n",
    \'si'     : "\<BS>_i",
    \'sj'     : "\<BS>_j",
    \'text'   : '\text{<+++>} <++>',
    \'lbl'    : "\<ESC>s\\label{<+++>}<++>",
    \
\'Section: Fancy Variables' : 'COMMENT',
    \'fa' : '\mathcal{A} ',
    \'fb' : '\mathcal{B} ',
    \'fc' : '\mathcal{C} ',
    \'fd' : '\mathcal{D} ',
    \'fe' : '\mathcal{E} ',
    \'ff' : '\mathcal{F} ',
    \'fg' : '\mathcal{G} ',
    \'fh' : '\mathcal{H} ',
    \'fi' : '\mathcal{I} ',
    \'fj' : '\mathcal{J} ',
    \'fk' : '\mathcal{K} ',
    \'fl' : '\mathcal{L} ',
    \'fm' : '\mathcal{M} ',
    \'fn' : '\mathcal{N} ',
    \'fo' : '\mathcal{O} ',
    \'fp' : '\mathcal{P} ',
    \'fq' : '\mathcal{Q} ',
    \'fr' : '\mathcal{R} ',
    \'fs' : '\mathcal{S} ',
    \'ft' : '\mathcal{T} ',
    \'fu' : '\mathcal{U} ',
    \'fv' : '\mathcal{V} ',
    \'fw' : '\mathcal{W} ',
    \'fx' : '\mathcal{X} ',
    \'fy' : '\mathcal{Y} ',
    \'fz' : '\mathcal{Z} ',
    \
\'Section: Encapsulating keywords' : 'COMMENT',
    \'bar'  : "\<ESC>F a\\overline{\<ESC>f i} ",
    \'tild' : "\<ESC>F a\\tilde{\<ESC>f i} ",
    \'hat'  : "\<ESC>F a\\hat{\<ESC>f i} ",
    \'star' : "\<BS>^* ",
    \'vec'  : "\<ESC>F a\\vec{\<ESC>f i} ",
    \
\'Section: Linear Algebra' : 'COMMENT',
    \'GL'     : '\text{GL} ',
    \'SL'     : '\text{SL} ',
    \'com'    : "\<BS>^c ",
    \'matrix' : "\<CR>\\begin{bmatrix}\<CR><+++>\<CR>\\end{bmatrix}\<CR><++>",
    \'vdots'  : '\vdots & ',
    \'ddots'  : '\ddots & ',
    \
\'Section: Constants' : 'COMMENT',
    \'aleph' : '\aleph ',
    \'inf'   : '\infty ',
    \'zero'  : '0 ',
    \'one'   : '1 ',
    \'two'   : '2 ',
    \'three' : '3 ',
    \'four'  : '4 ',
    \'five'  : '5 ',
    \'six'   : '6 ',
    \'seven' : '7 ',
    \'eight' : '8 ',
    \'nine'  : '9 ',
    \
\'Section: Operators' : 'COMMENT',
    \'op'     : '\mathop{<+++>} <++>',
    \'ope'    : '\operatorname{<+++>}(<++>) <++>',
    \'int'    : '\int <+++> \mathop{d <++>} <++>',
    \'dev'    : '\frac{d}{d <+++>} <++>',
    \'lim'    : '\lim_{<+++>} <++>',
    \'sum'    : '\sum_',
    \'prod'   : '\prod_',
    \'Sum'    : '\sum_{<+++>}^{<++>} <++> ',
    \'Prod'   : '\prod_{<+++>}^{<++>} <++> ',
    \'limsup' : '\limsup ',
    \'liminf' : '\liminf ',
    \'sup'    : '\sup ',
    \'sinf'   : '\inf ',
    \
\'Section: More Variables' : 'COMMENT',
    \'ell'   : '\ell ',
    \'nabla' : '\nabla ',
\}

" }}}

" LaTeX Mode Keywords {{{

let g:quicktex_tex = {
    \' ' : "\<ESC>/<+.*+>\<CR>\"_c/+>/e\<CR>",
    \'m' : '\( <+++> \) <++>',
    \'x' : '\(<+++>\)<++>',
    \'xx' : "\<ESC>Bvedi\\(\<ESC>pa\\) <+++>",
\'Section: Environments' : 'COMMENT',
    \'cmd' : "\<ESC>Bvedi\\\<ESC>pa{<+++>}<++>",
    \'env' : "\<ESC>Bvedi\\begin{\<ESC>pa}\<CR><+++>\<CR>\\end{\<ESC>pa}",
    \'exe' : "\\begin{exercise}{<+++>}\<CR><++>\<CR>\\end{exercise}",
    \'prf' : "\\begin{proof}\<CR><+++>\<CR>\\end{proof}",
    \'thm' : "\\begin{theorem}\<CR><+++>\<CR>\\end{theorem}",
    \'cor' : "\\begin{corollary}\<CR><+++>\<CR>\\end{corollary}",
    \'lem' : "\\begin{lemma}\<CR><+++>\<CR>\\end{lemma}",
    \'cnj' : "\\begin{conjecture}\<CR><+++>\<CR>\\end{conjecture}",
    \'obs' : "\\begin{observation}\<CR><+++>\<CR>\\end{observation}",
    \'clm' : "\\begin{claim}\<CR><+++>\<CR>\\end{claim}",
    \'prop': "\\begin{proposition}\<CR><+++>\<CR>\\end{proposition}",
    \'def' : "\\begin{definition}\<CR><+++>\<CR>\\end{definition}",
    \'prb' : "\\begin{problem}\<CR><+++>\<CR>\\end{problem}",
    \'enum' : "\\begin{enumerate}\<CR>\\item <+++>\<CR>\\end{enumerate}",
    \'itms' : "\\begin{itemize}\<CR>\\item <+++>\<CR>\\end{itemize}",
    \'eq'  : "\\begin{displaymath}\<CR><+++>\<CR>\\end{displaymath}",
    \'eqn' : "\\begin{equation}\\label{<+++>}\<CR><++>\<CR>\\end{equation}",
    \
\'Section: Other Commands' : 'COMMENT',
    \'itm'  : '\item ',
    \'sect' : "\\section{<+++>}\<CR><++>",
    \'subsect' : "\\subsection{<+++>}\<CR><++>",
    \'prg'  : "\\paragraph{<+++>}\<CR><++>",
    \'sect*': "\\section*{<+++>}\<CR><++>",
    \'subsect*': "\\subsection*{<+++>}\<CR><++>",
    \'prg*' : "\\paragraph*{<+++>}\<CR><++>",
    \'prn'  : '(<+++>) <++>',
    \'qt'   : "``<+++>'' <++>",
    \'dts'  : '\dots ',
    \'fig'  : 'Figure~\ref{fig:<+++>}<++>',
    \'ref'  : "\<ESC>s~\\ref{<+++>}<++>",
    \'lbl'  : "\<ESC>s\\label{<+++>}<++>",
    \'cit'  : "\<ESC>s~\\cite{<+++>}<++>",
    \'e'    : '\emph{<+++>} <++>',
    \'b'    : '\textbf{<+++>} <++>',
    \'i'    : '\textit{<+++>} <++>',
    \'ftn'  : '\footnote{<+++>} <++>',
    \
\'Section: Common Sets' : 'COMMENT',
    \'bn' : '\(\mathbb{N}\) ',
    \'bz' : '\(\mathbb{Z}\) ',
    \'bq' : '\(\mathbb{Q}\) ',
    \'br' : '\(\mathbb{R}\) ',
    \'br2': '\(\mathbb{R}^2\) ',
    \'br3': '\(\mathbb{R}^3\) ',
    \'brd': '\(\mathbb{R}^d\) ',
    \'bc' : '\(\mathbb{C}\) ',
    \'ba' : '\(\mathbb{A}\) ',
    \'bf' : '\(\mathbb{F}\) ',
    \'bx' : '\(\mathbb{X}\) ',
    \'bs' : '\(\mathbb{S}\) ',
    \'bi' : '\(\mathbb{I}\) ',
\'Section: Fancy Variables' : 'COMMENT',
    \'fa' : '\(\mathcal{A}\) ',
    \'fb' : '\(\mathcal{B}\) ',
    \'fc' : '\(\mathcal{C}\) ',
    \'fi' : '\(\mathcal{I}\) ',
    \'fl' : '\(\mathcal{L}\) ',
    \'fm' : '\(\mathcal{M}\) ',
    \'fn' : '\(\mathcal{N}\) ',
    \'fo' : '\(\mathcal{O}\) ',
    \'fp' : '\(\mathcal{P}\) ',
    \'fq' : '\(\mathcal{Q}\) ',
    \'fr' : '\(\mathcal{R}\) ',
    \'fs' : '\(\mathcal{S}\) ',
    \'ft' : '\(\mathcal{T}\) ',
    \'fv' : '\(\mathcal{V}\) ',
    \'fz' : '\(\mathcal{Z}\) ',
    \
\'Section: Lowercase Greek Letters' : 'COMMENT',
    \'alpha'   : '\(\alpha\) ',
    \'ga'      : '\(\alpha\) ',
    \'beta'    : '\(\beta\) ',
    \'gamma'   : '\(\gamma\) ',
    \'delta'   : '\(\delta\) ',
    \'eps'     : '\(\epsilon\) ',
    \'veps'      : '\(\varepsilon\) ',
    \'zeta'    : '\(\zeta\) ',
    \'eta'     : '\(\eta\) ',
    \'theta'   : '\(\theta\) ',
    \'iota'    : '\(\iota\) ',
    \'kappa'   : '\(\kappa\) ',
    \'lambda'  : '\(\lambda\) ',
    \'gl'      : '\(\lambda\) ',
    \'mu'      : '\(\mu\) ',
    \'nu'      : '\(\nu\) ',
    \'xi'      : '\(\xi\) ',
    \'omega'   : '\(\omega\) ',
    \'pi'      : '\(\pi\) ',
    \'rho'     : '\(\rho\) ',
    \'sigma'   : '\(\sigma\) ',
    \'tau'     : '\(\tau\) ',
    \'upsilon' : '\(\upsilon\) ',
    \'phi'     : '\(\varphi\) ',
    \'chi'     : '\(\chi\) ',
    \'psi'     : '\(\psi\) ',
    \
\'Section: Uppercase Greek Letters' : 'COMMENT',
    \'Alpha'   : '\(\Alpha\) ',
    \'Beta'    : '\(\Beta\) ',
    \'Gamma'   : '\(\Gamma\) ',
    \'Delta'   : '\(\Delta\) ',
    \'Epsilon' : '\(\Epsilon\) ',
    \'Zeta'    : '\(\Zeta\) ',
    \'Eta'     : '\(\Eta\) ',
    \'Theta'   : '\(\Theta\) ',
    \'Iota'    : '\(\Iota\) ',
    \'Kappa'   : '\(\Kappa\) ',
    \'Lambda'  : '\(\Lambda\) ',
    \'Mu'      : '\(\Mu\) ',
    \'Nu'      : '\(\Nu\) ',
    \'Xi'      : '\(\Xi\) ',
    \'Omega'   : '\(\Omega\) ',
    \'Pi'      : '\(\Pi\) ',
    \'Rho'     : '\(\Rho\) ',
    \'Sigma'   : '\(\Sigma\) ',
    \'Tau'     : '\(\Tau\) ',
    \'Upsilon' : '\(\Upsilon\) ',
    \'Phi'     : '\(\Phi\) ',
    \'Psi'     : '\(\Psi\) ',
    \
\'Section: Oh notation' : 'COMMENT',
    \'o'   : '\(o(<+++>)\)<++> ',
    \'O'   : '\(O(<+++>)\)<++> ',
    \'w'   : '\(\omega(<+++>)\)<++> ',
    \'W'   : '\(\Omega(<+++>)\)<++> ',
    \'T'   : '\(\Theta(<+++>)\)<++> ',
    \
\'Section: More Variables' : 'COMMENT',
    \'ell' : '\(\ell\) ',
    \'nabla' : '\(\nabla\) ',
    \
\'Section: Text remplacement' : 'COMMENT',
    \'iff' : 'if and only if ',
\}

" }}}
