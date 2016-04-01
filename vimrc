colorscheme default

filetype plugin indent on
syntax on
syn on

set wildchar=<Tab> wildmenu wildmode=full

set number
set encoding=utf8

set tabstop=8
set expandtab
set softtabstop=4
set shiftwidth=4
set smarttab
set shiftround
set nojoinspaces
set autoindent

set clipboard=unnamedplus

nmap <space> zz

autocmd! BufNewFile,BufRead *.pde setlocal ft=arduino
autocmd FileType haskell setlocal shiftwidth=2 tabstop=2
