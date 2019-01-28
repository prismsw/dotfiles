set rtp^=/usr/share/vim/vimfiles/

" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif
call plug#begin('~/.config/nvim/plugged/')
    Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'jamessan/vim-gnupg'
    " Plug 'neomake/neomake'
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'
    Plug 'racer-rust/vim-racer'
    Plug 'haya14busa/incsearch.vim'
    Plug 'leafgarland/typescript-vim'
call plug#end()

colorscheme delek

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

set hlsearch
hi Search cterm=NONE ctermfg=black ctermbg=blue
set ignorecase
set smartcase

set clipboard=unnamedplus

" Center on cursor
nmap <space> zz
map <C-n> :NERDTreeToggle<CR>
" Fzf search
map <C-p> :Files<CR>
" Move to next buffer
map <C-l> :bn<CR>
" Unhighlight search on esc
nnoremap <esc> :noh<return><esc>

" Fixes for accidental shift
nnoremap ; :
command Q q
command W w
command WQ wq
command Wq wq

autocmd! BufNewFile,BufRead *.pde setlocal ft=arduino
autocmd! BufNewFile,BufRead *.dl set filetype=prolog

" " Neomake
" autocmd! BufWritePost * Neomake
" hi ErrorMsg ctermbg=0 ctermfg=1
" let g:neomake_error_sign = {
"             \ 'text': '✖',
"             \ 'texthl': 'ErrorMsg',
"             \ }
" hi WarningMsg ctermbg=0 ctermfg=3
" let g:neomake_warning_sign = {
"             \ 'text': '➤',
"             \ 'texthl': 'WarningMsg',
"             \ }
"
" " Does nothing, why?
" hi InfoMsg ctermbg=4 ctermfg=0
" let g:neomake_info_sign = {
"             \ 'text': 'ℹ',
"             \ 'texthl': 'InfoMsg',
"             \ }
" highlight clear SignColumn


" Airline
let g:airline_powerline_fonts = 0
let g:airline_theme='bubblegum'
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#show_buffers = 1
let g:airline_skip_empty_sections = 1
"let g:neomake_airline = 1

" Racer
set hidden
let g:racer_cmd = "/usr/bin/racer"
let $RUST_SRC_PATH="/usr/src/rust/rust"

" Incsearch
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
