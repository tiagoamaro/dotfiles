" ------------------------------------------------------------------------------
"          FILE: .vimrc
"   DESCRIPTION: Vim configuration file. Strongly based on vasconcelloslf .vimrc :)
"        AUTHOR: Tiago Amaro (github.com/tiagoamaro)
" ------------------------------------------------------------------------------

" Vundle
set rtp+=~/.vim/bundle/Vundle.vim

set nocompatible
filetype off

" let Vundle manage Vundle
call vundle#rc()
" required!
Plugin 'gmarik/vundle'

" General Settings
set undolevels=1000                          " Large undo levels.
set undofile                                 " Save undo tree.
set undodir=/tmp                             " Undo tree directory.
set history=700                              " Size of command history.
set encoding=utf8                            " Always use unicode.
set autoread                                 " set to autoread when a file is changed from the outside
set backspace=indent,eol,start               " Fix backspace.
set nobackup                                 " Disable backups.
set nowritebackup
set noswapfile
set notimeout                                " Fix lag in iTerm.
set ttimeout
set timeoutlen=50
set nomodeline
set selection=inclusive                      " Select to the end of line.
set spelllang=en_au                          " Set spell check language.
" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Whitespaces
set tabstop=2                     " Set tab to equal 4 spaces.
set softtabstop=2                 " Set soft tabs equal to 4 spaces.
set shiftwidth=2                  " Set auto indent spacing.
set expandtab

" Indentation
set si "Smart indent
set wrap "Wrap lines

" Search and Replace
set incsearch                     " Show partial matches as search is entered.
set hlsearch                      " Highlight search patterns.
set ignorecase                    " Enable case insensitive search.
set smartcase                     " Disable case insensitivity if mixed case.
set wrapscan                      " Wrap to top of buffer when searching.
set gdefault                      " Make search and replace global by default.

" Presentation
set showmatch                     " Show matching parenthesis.
set ttyfast                       " Fast scrolling when on a decent connection.
set lazyredraw                    " Don't redraw while executing macros (good performance config)
set showcmd                       " Show last command.
set ruler                         " Show the cursor position.
set matchpairs+=<:>               " Pairs to match.
set cf                            " Enable error jumping.
set cursorline                    " Highlight current line
set number
set t_Co=256                      " Set number of colors to 256 (Terminal)
set clipboard=unnamed             " Using system clipboard
filetype on                       " Detect file type.
syntax enable
filetype indent on                " Enable file indenting.
filetype plugin indent on         " Load syntax files for better indenting.

" Foldings
set foldmethod=syntax
set foldlevelstart=99

" Options
let mapleader = ","
let g:mapleader = ","

" Mappings
map <F7> mzgg=G`z<CR>            " fix indentation
map <leader>h :noh<CR> " Disable highlighting when <leader>h is pressed
" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" tabs
vmap <Tab> >gv
vmap <S-Tab> <gv

" move lines or blocks
nnoremap <S-k> :m .-2<CR>==
nnoremap <S-j> :m .+1<CR>==
vnoremap <S-k> :m '<-2<CR>gv=gv
vnoremap <S-j> :m '>+1<CR>gv=gv
inoremap <S-k> <Esc>:m .-2<CR>==gi
inoremap <S-j> <Esc>:m .+1<CR>==gi

imap <Tab> <Space><Space>

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%
