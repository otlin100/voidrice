"        _
" __   _(_)_ __ ___  _ __ ___
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
"   \_/ |_|_| |_| |_|_|  \___|

let mapleader =" "

call plug#begin('~/.config/nvim/plugged')
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-fugitive'
Plug 'Raimondi/delimitMate'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'tpope/vim-commentary'
Plug 'vim-airline/vim-airline'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'Julian/vim-textobj-brace'
Plug 'kana/vim-textobj-line'
Plug 'reedes/vim-textobj-sentence'
Plug 'saaguero/vim-textobj-pastedtext'
Plug 'dylanaraps/wal.vim'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'SirVer/ultisnips'
Plug 'vim-scripts/mru.vim'
Plug 'terryma/vim-expand-region'
Plug 'easymotion/vim-easymotion'
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/goyo.vim'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'jreybert/vimagit'
Plug 'LukeSmithxyz/vimling'
Plug 'vimwiki/vimwiki'
call plug#end()

let g:deoplete#enable_at_startup = 1

" dont't clear clipboard on exit
autocmd VimLeave * call system("xsel -ib", getreg('+'))

"no timeoutlen in insert mode
:autocmd InsertEnter * set timeoutlen=0
:autocmd InsertLeave * set timeoutlen=1000

" if you actually need tabs
inoremap <S-Tab> <C-V><Tab>

" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

set background=dark
set showcmd
set list
set smartcase
set showmatch
set mat=2
set incsearch
set hlsearch
set lazyredraw
set magic
set tabstop=4
set shiftwidth=4
set expandtab
set history=500
set autoread
set ai
set si
set wrap
set so=7

" :W sudo saves the file
command! W w !sudo tee % > /dev/null

set nobackup
set nowb
set noswapfile

colorscheme wal

" yank path/dir
nmap yp :let @"=@%<CR>
nmap yd :let @" = expand("%:p:h")<cr>

" clipboard to reg and vice versa
nnoremap <leader>y :let @+=@"<cr>
nnoremap <leader>Y :let @"=@+<cr>

map + <Plug>(expand_region_expand)
map - <Plug>(expand_region_shrink)

nmap <leader>j <Plug>yankstack_substitute_older_paste
nmap <leader>k <Plug>yankstack_substitute_newer_paste

" search whole words
nmap <leader>/ /\<\><left><left>

"wipe current buffer and quit if it is the last buffer
nnoremap <expr> <leader>q len(getbufinfo({'buflisted':1}))==1 ? ':q!<cr>' : ':bw!<cr>'

" add spaces after pasting in normal mode
nnoremap gl `[i<Space><Esc>``l

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsSnippetsDir = "~/.vim/mysnippets"
let g:UltiSnipsSnippetDirectories=["mysnippets"]
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsListSnippets="<c-tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
" vertically split ultisnips edit window
let g:UltiSnipsUsePythonVersion = 3

nmap <leader>ue :UltiSnipsEdit<cr>

nmap <leader>v :e $MYVIMRC<cr>

nnoremap Y y

set ignorecase
set path+=**
set path+=~/.config/**
set path+=~/.scripts/**

set wildmenu
" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

set ruler
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Some basics:
set nocompatible
filetype plugin on
syntax on
set encoding=utf-8

" Enable autocompletion:
set wildmode=longest,list,full

" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Goyo plugin makes text more readable when writing prose:
map <leader>f :Goyo \| set linebreak<CR>

" MRU Plugin
map <leader>m :MRU<cr>

" Spell-check set to <leader>o, 'o' for 'orthography':
map <leader>o :setlocal spell! spelllang=en_us<CR>

" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
set splitbelow splitright

" Shortcutting split navigation, saving a keypress:
nmap <c-h> <c-w>h
nmap <c-l> <c-w>l
nmap <c-j> <c-w>j
nmap <c-k> <c-w>k
set wmh=0

" Check file in shellcheck:
" map <leader>s :!clear && shellcheck %<CR>
nnoremap <leader>s :so %<cr>

" Open my bibliography file in split
map <leader>b :e<space>$BIB<CR>
map <leader>r :e<space>$REFER<CR>

" Replace all is aliased to S.
nnoremap <leader>S :%s//g<Left><Left>

" Compile document, be it groff/LaTeX/markdown/etc.
map <leader>c :w! \| !compiler <c-r>%<CR><CR>

" Open corresponding .pdf/.html or preview
map <leader>p :!opout <c-r>%<CR><CR>

" Runs a script that cleans out tex build files whenever I close out of a .tex file.
autocmd VimLeave *.tex !texclear %

" Ensure files are read as what I want:
let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
autocmd BufRead,BufNewFile *.tex set filetype=tex

" Readmes autowrap text:
autocmd BufRead,BufNewFile *.md set tw=79

" Use urlscan to choose and open a url:
" :noremap <leader>u :w<Home> !urlscan -r 'linkhandler {}'<CR>
:noremap ,, !urlscan -r 'linkhandler {}'<CR>

" Copy selected text to system clipboard (requires gvim/nvim/vim-x11 installed):
map <C-p> "+P

" Enable Goyo by default for mutt writting
" Goyo's width will be the line limit in mutt.
autocmd BufRead,BufNewFile /tmp/neomutt* let g:goyo_width=80
autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo

" Automatically deletes all trailing whitespace on save.
autocmd BufWritePre * %s/\s\+$//e

" When shortcut files are updated, renew bash and ranger configs with new material:
autocmd BufWritePost ~/.bm* !shortcuts

" Run xrdb and wal whenever Xdefaults or Xresources are updated.
autocmd BufWritePost ~/.Xresources,~/.Xdefaults !xrdb % ;wal -c ;wal -i ~/.config/wall.png
