set nocompatible              " be iMproved, be safe
" http://stackoverflow.com/questions/5845557/in-a-vimrc-is-set-nocompatible-completely-useless

" install vim-plug
" https://github.com/junegunn/vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" ## BINDINGS ##
" fugitive.vim: a Git wrapper so awesome, it should be illegal
Plug 'tpope/vim-fugitive'

" ## INTERFACE ##
" Pseudo-command-line (experimental)
"Plug 'junegunn/vim-pseudocl'
" Go to Terminal or File manager (maybe not be so useful)
"Plug 'justinmk/vim-gtfo'
" Ranger integration in vim and neovim
Plug 'francoiscabrol/ranger.vim'


" ## FIXES ##
" Find-N-Replace helper free of regular expressions
"Plug 'junegunn/vim-fnr'
" enable repeating supported plugin maps with "."
Plug 'tpope/vim-repeat'
" Heuristically set buffer options (auto indentation)
Plug 'tpope/vim-sleuth'

" ## VISUAL ##
" one colorscheme pack to rule them all!
Plug 'flazz/vim-colorschemes'
" Vim plugin that displays tags in a window, ordered by scope
" Lean & mean status/tabline for vim that's light as air.
" Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
" should be loaded before vim-airline but does not work :(
Plug 'vim-airline/vim-airline'
" A collection of themes for vim-airline
Plug 'vim-airline/vim-airline-themes'
" Vim plugin which shows a git diff in the gutter (sign column) and stages/undoes hunks.
Plug 'airblade/vim-gitgutter'
" Plug 'mhinz/vim-signify' " possible alternative
" A tree explorer plugin for vim.
"Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
" Preview colours in source code while editing
Plug 'ap/vim-css-color', { 'for': 'css' }
" causes all trailing whitespace characters (spaces and tabs) to be highlighted
Plug 'ntpeters/vim-better-whitespace'
" A Vim plugin for visually displaying indent levels in code: <leader>ig
Plug 'nathanaelkane/vim-indent-guides'
" A git commit browser
Plug 'junegunn/gv.vim'
" The ultimate undo history visualizer
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
" Peekaboo extends " and @ in normal mode and <CTRL-R> in insert mode so you can see the contents of the registers.
Plug 'junegunn/vim-peekaboo'
" Rainbow parentheses!
Plug 'junegunn/rainbow_parentheses.vim'
" Distraction-free writing in Vim
Plug 'junegunn/goyo.vim'
" Hyperfocus-writing in Vim
Plug 'junegunn/limelight.vim'

" ## COMPLETION ##
" allows you to use <Tab> for all your insert completion needs
Plug 'ervandew/supertab'
" Vim plugin, provides insert mode auto-completion for quotes, parens, brackets, etc.
Plug 'Raimondi/delimitMate'
" Emoji in Vim
Plug 'junegunn/vim-emoji'

" ## LANGUAGE SUPPORT ##
" Syntax checking hacks for vim
Plug 'vim-syntastic/syntastic'
" Provide easy code formatting in Vim by integrating existing code formatters.
Plug 'Chiel92/vim-autoformat'
" plug-in which provides support for expanding abbreviations similar to emmet
Plug 'mattn/emmet-vim'
" Generate JSDoc to your JavaScript code
Plug 'heavenshell/vim-jsdoc'
" Go development plugin for Vim
Plug 'fatih/vim-go'
" tern is a JavaScript code analyzer for deep, cross-editor language support
Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }
" Enhanced javascript syntax file for Vim
Plug 'jelera/vim-javascript-syntax'
" Vastly improved Javascript indentation and syntax support in Vim
Plug 'pangloss/vim-javascript'
" React JSX syntax highlighting and indenting for vim
Plug 'mxw/vim-jsx'
" :heart: JavaScript happiness style linter
Plug 'xojs/vim-xo'
" A code-completion engine for Vim
" Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' }
" Compiling requires too much memory, fails every time
" A modern vim plugin for editing LaTeX files
Plug 'lervag/vimtex'
" A vim plugin for writing Latex quickly
Plug 'brennier/quicktex'
" Official Vimperator syntax highlighting file.
"Plug 'vimperator/vimperator.vim'
" Vim syntax for TOML
Plug 'https://github.com/cespare/vim-toml'

" ## MOTIONS ##
" search and jump to a single character with <leader><leader>s<char>
Plug 'easymotion/vim-easymotion'

" ## SELECTION ##
" True Sublime Text style multiple selections for Vim
"Plug 'terryma/vim-multiple-cursors'

" ## SHORTCUTS ##
" pairs of handy bracket mappings
Plug 'tpope/vim-unimpaired'
" use CTRL-A/CTRL-X to increment dates, times, and more
Plug 'tpope/vim-speeddating'
" quoting/parenthesizing made simple
Plug 'tpope/vim-surround'
" intensely orgasmic commenting
Plug 'scrooloose/nerdcommenter'
" A Vim alignment plugin
Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
" A vim plugin that simplifies the transition between multiline and single-line code
Plug 'AndrewRadev/splitjoin.vim'

" ## FUZZY FINDER ## ( Used a lot!!! )
" A command-line fuzzy finder written in Go
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all --no-update-rc' }
" bundle of fzf-based commands and mappings
Plug 'junegunn/fzf.vim'
Plug 'nhooyr/fasd.vim'

call plug#end()

" Use hidden buffers. Allows to change buffer without saving.
set hidden
" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamedplus
" Enhance command-line completion
set wildmenu
" Allow cursor keys in insert mode
set esckeys
" Allow backspace in insert mode
set backspace=indent,eol,start
" Optimize for fast terminal connections
set ttyfast
" Add the g flag to search/replace by default
" From vim.wikia.com:
" > Using :set gdefault creates confusion because then %s/// is global,
" > whereas %s///g is not (that is, g reverses its meaning)
" > CONCLUSION: DO NOT SET IT AS DEFAULT
"set gdefault
"
" Use UTF-8 without BOM
set encoding=utf-8 nobomb
" Change mapleader
let mapleader=","
" Centralize backups, swapfiles and undo history (// for full paths)
set backupdir=~/.vim/backups//
set directory=~/.vim/swaps//
if has("persistent_undo")
    set undodir=~/.vim/undo//
    set undofile
endif

" Don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*

" Respect modeline in files
set modeline
set modelines=4
" Do not enable per-directory .vimrc files
" set exrc
" and disable unsafe commands in them (just in case)
set secure
" Enable line numbers
set number
" Do not highlight current line and do not use relative line numbers (SLOW)
" see https://github.com/xolox/vim-easytags/issues/88
set nocursorline
if exists("&relativenumber")
  set norelativenumber
  "au BufReadPost * set relativenumber
endif
" Make tabs as wide as four spaces
set tabstop=4
set shiftwidth=4
" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
set list
" Highlight searches
set hlsearch
" Ignore case of searches
set ignorecase
" Highlight dynamically as pattern is typed
set incsearch
" Always show status line
set laststatus=2
" Enable mouse in all modes
set mouse=a
" Disable error bells
set noerrorbells
" Don’t reset cursor to start of line when moving around.
set nostartofline
" Show the cursor position
set ruler
" Automatically cut long lines
set tw=79
" Adds a guide for maximum length of lines
set colorcolumn=79
" Don’t show the intro message when starting Vim
set shortmess=atI
" Show the current mode
set showmode
" Show the filename in the window titlebar
set title
" Show the (partial) command as it’s being typed
set showcmd
" Start scrolling three lines before the horizontal window border
set scrolloff=3

" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Automatic commands
if has("autocmd")
  " Enable file type detection
  filetype on
  " Treat .json files as .js
  autocmd BufNewFile,BufRead *.json setlocal filetype=json syntax=javascript
  " Treat .md files as Markdown
  autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
  " Treat .sage files as .py
  autocmd BufNewFile,BufRead *.sage setlocal filetype=python syntax=python softtabstop=4 shiftwidth=4 expandtab
endif

" Set colors
set t_Co=256
syntax on
set background=dark
" Use Hybrid, to use ~/.Xresources uncomment next line
" let g:hybrid_use_Xresources = 1
silent! colorscheme hybrid
"silent! colorscheme seoul256


" Replace search with easymotion multi char search
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)

" open a new buffer
noremap <silent> <leader>e :enew<CR>

" toggle nerdtree
"noremap <silent> <leader>t :NERDTreeToggle<CR>

" Strip trailing whitespace (w)
noremap <silent> <leader>w :StripWhitespace<CR>
autocmd FileType javascript,python,c,cpp,java,html,css,ruby autocmd BufWritePre <buffer> StripWhitespace

" Recognize all .tex files as LaTeX
let g:tex_flavor = 'latex'

" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" <cr> expands {_} to {<cr><indent>_<cr>}
let g:delimitMate_expand_cr = 1

" Experimentally integrate YouCompleteMe with vim-multiple-cursors, otherwise
" the numerous Cursor events cause great slowness
" (https://github.com/kristijanhusak/vim-multiple-cursors/issues/4)

" function! Multiple_cursors_before()
" let s:old_ycm_whitelist = g:ycm_filetype_whitelist
" let g:ycm_filetype_whitelist = {}
" endfunction
" function! Multiple_cursors_after()
" let g:ycm_filetype_whitelist = s:old_ycm_whitelist
" endfunction

" syntastic
let g:syntastic_mode_map = { 'mode': 'passive' }
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint', 'xo']
let g:syntastic_javascript_eslint_exec = 'eslint_d'

"toggle syntastic on a per buffer basis
function! SyntasticToggle()
    if !exists('b:syntastic_disabled')
        let b:syntastic_disabled = 0
    endif
    if !b:syntastic_disabled
        let b:syntastic_mode = "passive"
        SyntasticReset
        let b:syntastic_disabled = 1
    else
        SyntasticCheck
        let b:syntastic_mode = "active"
        let b:syntastic_disabled = 0
    endif
    echo 'Syntastic ' . ['enabled', 'disabled'][b:syntastic_disabled]
endfunction

" Shortcut for toggling syntastic
command! SyntasticToggle call SyntasticToggle()
nn <silent> <leader>s :SyntasticToggle<cr>
nn <silent> <leader>S :SyntasticToggleMode<cr>

" Shortcut for formatting code
nn <silent> <leader>x :Autoformat<cr>

" clean up gvim interface
if has('gui_running')
  set guioptions-=m  "remove menu bar
  set guioptions-=T  "remove toolbar
  set guioptions-=r  "remove right-hand scroll bar
  set guioptions-=L  "remove left-hand scroll bar
  set lines=60 columns=108 linespace=0
  set guifont=LiterationMono\ Nerd\ Font\ Mono\ 12
endif

" goyo + limelight config
let g:goyo_width=90
let g:limelight_paragraph_span = 1
let g:limelight_priority = -1

function! s:goyo_enter()
  if has('gui_running')
    set fullscreen
    set background=light
    set linespace=7
  elseif exists('$TMUX')
    silent !tmux set status off
  endif
  " hi NonText ctermfg=101
  set nowrap
  Limelight
  set scrolloff=999
endfunction

function! s:goyo_leave()
  set scrolloff=3
  Limelight!
  if has('gui_running')
    set nofullscreen
    set background=dark
    set linespace=0
  elseif exists('$TMUX')
    silent !tmux set status on
  endif
  set wrap
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

nnoremap <Leader>g :Goyo<CR>

" fzf mappings
nn <silent> <leader>f :Files<cr>
nn <silent> <leader>b :Buffers<cr>
nn <silent> <leader>o :History<cr>
nn <silent> <leader>q :Ag<cr>
let $FZF_DEFAULT_COMMAND= 'ag --hidden --ignore .git --ignore node_modules -g ""'
let g:fzf_files_options = '--preview "begin; coderay {}; or cat {}; end 2>/dev/null | head -'.&lines.'"'

" fasd mappings
command! -nargs=* Z :call Z(<f-args>)
function! Z(...) "Z - cd to recent / frequent directories
  let cmd = 'fasd -d -e printf'
  for arg in a:000
    let cmd = cmd . ' ' . arg
  endfor
  let path = system(cmd)
  if isdirectory(path)
    echo path
    exec 'cd' fnameescape(path)
  endif
endfunction

" undotree config
let g:undotree_WindowLayout = 2
nnoremap <silent> U :UndotreeToggle<cr>

" search for last function def and call jsdoc
nmap <silent> <leader>j ?function<cr>:noh<cr><Plug>(jsdoc)

" noh shortcut
nn <silent> <leader>d :noh<cr>

" shorter window moves
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

" buffer cycling shortcuts
nn <silent> <leader>n :bn<cr>
nn <silent> <leader>p :bp<cr>
nn <silent> <leader>l :bd<cr>

" Capitalize words and regions easily
" from http://vim.wikia.com/wiki/Capitalize_words_and_regions_easily
if (&tildeop)
  nmap gcw guw~l
  nmap gcW guW~l
  nmap gciw guiw~l
  nmap gciW guiW~l
  nmap gcis guis~l
  nmap gc$ gu$~l
  nmap gcgc guu~l
  nmap gcc guu~l
  vmap gc gu~l
else
  nmap gcw guw~h
  nmap gcW guW~h
  nmap gciw guiw~h
  nmap gciW guiW~h
  nmap gcis guis~h
  nmap gc$ gu$~h
  nmap gcgc guu~h
  nmap gcc guu~h
  vmap gc gu~h
endif

" Email completion using abook and fzf
function! s:iea_handler(lines)
  exec ':normal a' . join(a:lines,', ')
endfunction
command! InsertEmailAddresses call fzf#run({'source': 'notmuch-abook export -f email -s name', 'sink*': function('<sid>iea_handler'), 'options': '-m'})
nn <silent> <leader>v :InsertEmailAddress<cr>

" vimtex + surround = magic
augroup latexSurround
  autocmd!
  autocmd FileType tex,plaintex call s:latexSurround()
augroup END

function! s:latexSurround()
  let b:surround_{char2nr("e")}
    \ = "\\begin{\1environment: \1}\n\t\r\n\\end{\1\1}"
  let b:surround_{char2nr("c")} = "\\\1command: \1{\r}"
  " vim-surround: q for `foo' and Q for ``foo''
  let b:surround_{char2nr('q')} = "`\r'"
  let b:surround_{char2nr('Q')} = "``\r''"
endfunction

let g:ranger_map_keys = 0
map <leader>r :RangerWorkingDirectory<CR>
map <leader>R :RangerCurrentFile<CR>

" jsx
let g:jsx_ext_required = 0

" replace selection shortcut
vnoremap <C-r> "hy:%s/<C-r>h//g<left><left>
