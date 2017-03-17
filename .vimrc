"Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'tpope/vim-dispatch'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'tomasr/molokai'
Plugin 'godlygeek/tabular'
Plugin 'fishman/ctags'
Plugin 'derekwyatt/vim-fswitch'
Plugin 'bling/vim-airline'
Plugin 'derekwyatt/vim-protodef'
Plugin 'vim-scripts/DoxygenToolkit.vim'
Plugin 'kana/vim-operator-user'
Plugin 'rhysd/vim-clang-format'
Plugin 'majutsushi/tagbar'
Plugin 'zyedidia/vim-snake'

call vundle#end()

"C++ synthax
let g:syntastic_cpp_checkers = ['gcc']
let g:syntastic_cpp_check_header = 1
let g:syntastic_c_auto_refresh_includes = 1
let g:syntastic_cpp_compiler = "gcc"
let g:syntastic_cpp_compiler_options = "-std=c++14 -Wall -Wextra -pedantic"
set cinoptions=(0,u0,U0,t0,g0,N-s
let g:cpp_class_scope_highlight = 1
let g:cpp_experimental_template_highlight = 1

"Lines
set number

set relativenumber
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" Mouse handling
set mouse=a
set mousehide

" Change <leader>
let mapleader=","

"Coding style
filetype plugin indent on "detect the file type
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set list
set listchars=tab:__,trail:*,extends:#,eol:$,space:.
set backspace=indent,eol,start


" Automatically read a file that has changed on disk
set autoread

"Search
set incsearch
set hlsearch

"Binding
set pastetoggle=<F12> " F12 Set paste / no-paste
nmap <silent> <C-N> :NERDTreeToggle<CR>
nmap <leader>ev :e $MYVIMRC<CR>

"Swap files
set noswapfile

"Miscellanous
if version >= 703
  set undofile
  set undodir=~/.vimtmp/undo
  silent !mkdir -p ~/.vimtmp/undo
endif

set t_ut=
set t_Co=256
let g:rehash256 = 1
colorscheme molokai
set completeopt-=preview

"Custom colors
syntax on
hi Comment ctermfg=DarkGrey
hi Normal ctermfg=Grey

hi String ctermfg=Red
hi Character ctermfg=Red
hi Number ctermfg=Cyan
hi Boolean ctermfg=Cyan
hi Float ctermfg=Cyan

hi Cursor ctermfg=White

hi Function ctermfg=DarkGreen

hi Conditional ctermfg=Green
hi Repeat ctermfg=Green
hi Label ctermfg=Green
hi Operator ctermfg=LightGreen
hi Keyword ctermfg=DarkGreen
hi SpecialKey ctermfg=LightGreen
hi Exception ctermfg=LightGreen

hi Include ctermfg=DarkRed
hi Define ctermfg=DarkRed
hi Macro ctermfg=DarkRed
hi PreCondit ctermfg=DarkRed

hi StorageClass ctermfg=DarkGreen
hi Structure ctermfg=Green
hi Statement ctermfg=DarkRed
hi Typedef ctermfg=DarkBlue
hi ErrorMsg ctermbg=Red
hi ErrorMsg ctermfg=Black

hi Tag ctermfg=Green
hi Delimiter ctermfg=Yellow
hi SpecialChar ctermfg=Yellow

hi ColorColumn ctermbg=DarkRed

hi LeadingSpace ctermfg=237
hi TrailingSpace ctermfg=Red
hi CenterSpace ctermfg=234

call matchadd('CenterSpace', '\S\zs\s\+')
call matchadd('TrailingSpace', ' \+$')
call matchadd('LeadingSpace', '^ \+')

"airline
scriptencoding utf-8
set encoding=utf-8
set laststatus=2

"clang-format
map to <Leader>cf in C++ code
autocmd FileType c,cpp,cc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,cc vnoremap <buffer><Leader>cf :ClangFormat<CR>
autocmd FileType c,cpp,cc map <buffer><Leader>x <Plug>(operator-clang-format)
nmap <Leader>C :ClangFormatAutoToggle<CR>

"tagbar
nmap <F5> :TagbarToggle<CR>

"nerdcomment
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1

"Snake :D
let g:snake_row = 50
let g:snake_cols = 50
let g:snake_update = 50

"Custom functions

"Toggle column warning and invisible chars
function! ColumnToggle()
  let w:toggle = exists('w:toggle') ? !w:toggle : 0
  if w:toggle
    call matchdelete(w:matchId)
  else
    let w:matchId = matchadd('ColorColumn', '\%81v.', 100)
  endif
endfunction
call ColumnToggle()
nmap <leader>inv :set list! <bar> :call ColumnToggle() <CR>

" Insert gates or pragma once on headers
function! s:insert_gates()
  let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
  execute "normal! i#ifndef " . gatename . "_"
  execute "normal! o# define " . gatename . "_\n"
  execute "normal! Go#endif /* " . gatename . "_ */"
  normal! kk
endfunction
function! s:insert_pragma()
  execute "normal! i#pragma once"
  normal! kk
endfunction
autocmd BufNewFile *.{h,hpp,hh,hxx} call <SID>insert_pragma()

" Function to switch bewteen header and implementation file
set path=.,,..,../..,./*,..*/*,./*/*,../*,~/,~/**,/usr/include/*
function! Mosh_Flip_Ext()
  if match(expand("%"),'\.cc') > 0
    let s:flipname = substitute(expand("%"),'\.cc\(.*\)','.hh\1',"")
    exe ":find " s:flipname
    exe ":cd %:p:h"
  elseif match(expand("%"),"\\.hh") > 0
    let s:flipname = substitute(expand("%"),'\.hh\(.*\)','.cc\1',"")
    exe ":find " s:flipname
    exe ":cd %:p:h"
  elseif match(expand("%"),"\\.hxx") > 0
    let s:flipname = substitute(expand("%"),'\.hxx\(.*\)','.hh\1',"")
    exe ":find " s:flipname
    exe ":cd %:p:h"
  elseif match(expand("%"),"\.c") > 0
    let s:flipname = substitute(expand("%"),'\.c\(.*\)','.h\1',"")
    exe ":find " s:flipname
    exe ":cd %:p:h"
  elseif match(expand("%"),"\\.h") > 0
    let s:flipname = substitute(expand("%"),'\.h\(.*\)','.c\1',"")
    exe ":find " s:flipname
    exe ":cd %:p:h"
  endif
endfun
nmap <F2> :call Mosh_Flip_Ext()<CR>
