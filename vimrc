colorscheme default

filetype plugin indent on
syntax on
syn on

au BufEnter *.hs compiler ghc

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

let g:haddock_browser = "/usr/bin/firefox"
let g:ghc = "/usr/bin/ghc"

nmap <space> zz
