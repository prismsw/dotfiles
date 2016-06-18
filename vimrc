colorscheme default

filetype plugin indent on
syntax on
syn on


highlight Pmenu ctermfg=black ctermbg=blue

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
map <C-n> :NERDTreeToggle<CR>

autocmd! BufNewFile,BufRead *.pde setlocal ft=arduino
autocmd! BufNewFile,BufRead *.dl set filetype=prolog
