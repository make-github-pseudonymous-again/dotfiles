set nocompatible              " be iMproved, be safe
" http://stackoverflow.com/questions/5845557/in-a-vimrc-is-set-nocompatible-completely-useless

" install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'ctrlpvim/ctrlp.vim'
Plug 'Raimondi/delimitMate'
Plug 'mattn/emmet-vim'
Plug 'ervandew/supertab'
Plug 'scrooloose/syntastic'
Plug 'marijnh/tern_for_vim'
Plug 'bling/vim-airline'
Plug 'ntpeters/vim-better-whitespace'
Plug 'flazz/vim-colorschemes'
Plug 'Lokaltog/vim-easymotion'
Plug 'airblade/vim-gitgutter'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'terryma/vim-multiple-cursors'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-surround'
Plug 'evidens/vim-twig'
Plug 'jelera/vim-javascript-syntax'
Plug 'pangloss/vim-javascript'
Plug 'heavenshell/vim-jsdoc'
Plug 'fatih/vim-go'
Plug 'scrooloose/nerdcommenter'
Plug 'lervag/vimtex'
Plug 'junegunn/goyo.vim'
Plug 'tpope/vim-sleuth'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
"Plug 'Valloric/YouCompleteMe' " too many bugs

call plug#end()

" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed
" Enhance command-line completion
set wildmenu
" Allow cursor keys in insert mode
set esckeys
" Allow backspace in insert mode
set backspace=indent,eol,start
" Optimize for fast terminal connections
set ttyfast
" Add the g flag to search/replace by default
set gdefault
" Use UTF-8 without BOM
set encoding=utf-8 nobomb
" Change mapleader
let mapleader=","
" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
	set undodir=~/.vim/undo
endif

" Don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*

" Respect modeline in files
set modeline
set modelines=4
" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure
" Enable line numbers
set number
" Highlight current line
set cursorline
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
" Use relative line numbers
if exists("&relativenumber")
	set relativenumber
	au BufReadPost * set relativenumber
endif
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

set showcmd

" Set colors
set t_Co=256
syntax on
set background=dark
" Use Hybrid, to use ~/.Xresources uncomment next line
" let g:hybrid_use_Xresources = 1
colorscheme hybrid


" Replace search with easymotion multi char search
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)

noremap <leader>t <Esc>:tabnew<CR>

" Calendar
let g:calendar_google_calendar = 1
let g:calendar_google_task = 1

" Strip trailing whitespace (,ss)
noremap <leader>ss :StripWhitespace<CR>

autocmd FileType javascript,python,c,cpp,java,html,css,ruby autocmd BufWritePre <buffer> StripWhitespace

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" Show hidden files in ctrlp.vim
let g:ctrlp_show_hidden = 1

" ctrl-c expands {_} to an indented block
" imap <C-c> <CR><Esc>O
" Thankyou! this is great, poking around in the docs I found the delimitmate has an option for the enter thingy
let g:delimitMate_expand_cr = 1

" Experimentally integrate YouCompleteMe with vim-multiple-cursors, otherwise
" the numerous Cursor events cause great slowness
" (https://github.com/kristijanhusak/vim-multiple-cursors/issues/4)

"function! Multiple_cursors_before()
"let s:old_ycm_whitelist = g:ycm_filetype_whitelist
"let g:ycm_filetype_whitelist = {}
"endfunction
"function! Multiple_cursors_after()
"let g:ycm_filetype_whitelist = s:old_ycm_whitelist
"endfunction

" This does what it says on the tin. It will check your file on open too, not just on save.
" You might not want this, so just leave it out if you don't.
" (http://oli.me.uk/2013/06/29/equipping-vim-for-javascript/)
let g:syntastic_check_on_open=1

if has('gui_running')
  set guioptions-=m  "remove menu bar
  set guioptions-=T  "remove toolbar
  set guioptions-=r  "remove right-hand scroll bar
  set guioptions-=L  "remove left-hand scroll bar
  set lines=60 columns=108 linespace=0
  set guifont=Liberation\ Mono\ for\ Powerline\ 12
endif

" Goyo config
let g:goyo_width=90
