let mapleader =" "

call plug#begin('~/.config/nvim/plugged')
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-abolish'
Plug 'Raimondi/delimitMate'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'tpope/vim-commentary'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-function'
Plug 'sgur/vim-textobj-parameter'
Plug 'beloglazov/vim-textobj-quotes'
Plug 'Julian/vim-textobj-brace'
Plug 'kana/vim-textobj-line'
Plug 'reedes/vim-textobj-sentence'
Plug 'saaguero/vim-textobj-pastedtext'
Plug 'dylanaraps/wal.vim'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'SirVer/ultisnips'
Plug 'vim-scripts/mru.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/goyo.vim'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'baskerville/vim-sxhkdrc'
Plug 'VebbNix/lf-vim'
Plug 'pbrisbin/vim-mkdir'
Plug 'elmcast/elm-vim'
call plug#end()

let g:vim_textobj_parameter_mapping = 'a'

source $XDG_CONFIG_HOME/nvim/vim_shortcuts.vim

let g:deoplete#enable_at_startup = 0

let g:python3_host_prog = '/usr/bin/python3'

let g:airline_powerline_fonts = 1
let g:airline_theme='solarized'

 " Enable the list of buffers
" let g:airline#extensions#tabline#enabled = 1
" Show just the filename
" let g:airline#extensions#tabline#fnamemod = ':t'

nnoremap <leader>d :call deoplete#toggle()<cr>

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

let g:rg_command = '
  \ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always"
  \ -g "*.{js,json,php,md,styl,jade,html,config,py,cpp,c,go,hs,rb,conf}"
  \ -g "!{.git,node_modules,vendor}/*" '

command! -bang -nargs=* F call fzf#vim#grep(g:rg_command .shellescape(<q-args>), 1, <bang>0)
let g:fzf_tags_command = 'ctags -R -f ./.git/tags .'

" using ag/rg
nnoremap <leader>a :Ag<cr>
nnoremap <leader><leader>a :Rg<cr>

" dont't clear clipboard on exit
autocmd VimLeave * call system("xsel -ib", getreg('+'))

" disable highlighting
nmap <silent> <leader><cr> :noh<cr>

"no timeoutlen in insert mode
autocmd InsertEnter * set timeoutlen=0
autocmd InsertLeave * set timeoutlen=1000

" if you actually need tabs
inoremap <S-Tab> <C-V><Tab>

" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Some basics:
set nocompatible
filetype plugin on
syntax on
set encoding=utf-8

set isfname+={,}
set go=a
set mouse=a
set foldenable
set nocursorline
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
set shiftwidth=4
set tabstop=4
set expandtab
set history=500
set autoread
set autoindent
set smartindent
set wrap
set so=7
set viminfo=!,'100,<50,s10,h,f1

set nobackup
set nowb
set noswapfile

colorscheme wal
" set bg=light

" yank path/dir
nmap yp :let @"=@%<CR>
nmap yd :let @" = expand("%:p:h")<cr>

" edit new file when path doesn't exist
map gf :e <cfile><cr>

" clipboard, reg, selection rotation
nnoremap <leader>y :let @t=@+ <bar> let @+=@" <bar> let @"=@* <bar> let @*=@t<cr>
nnoremap <leader>Y :let @t=@+ <bar> let @+=@* <bar> let @*=@" <bar> let @"=@t<cr>

nmap <leader>j <Plug>yankstack_substitute_older_paste
nmap <leader>k <Plug>yankstack_substitute_newer_paste

" fzf lines
nmap <leader>7 :Lines<cr>
nmap <leader>/ /\<\><left><left>
nmap <leader>e :Files<cr>

"delete! current buffer and quit if it is the last buffer

command! CloseOrQuit call CloseOrQuit()
function! CloseOrQuit()
    if len(getbufinfo({'buflisted':1}))==1
        execute("q!")
    else
        execute("bd!")
    endif
endfunction

nnoremap <leader>q :CloseOrQuit<cr>
au CmdwinEnter : nnoremap <leader>q :q!<cr>
au CmdwinLeave : nnoremap <leader>q :CloseOrQuit<cr>

" vertical diff
set diffopt=vertical

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" add spaces after pasting in normal mode
nnoremap gl `[i<Space><Esc>``l

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsSnippetsDir = $XDG_CONFIG_HOME."/nvim/mysnippets"
let g:UltiSnipsSnippetDirectories=["mysnippets"]
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsListSnippets="<c-tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsUsePythonVersion = 3
nmap <leader><tab> <plug>(fzf-maps-n)
nmap <leader>ue :UltiSnipsEdit<cr>
nmap <leader>w :cd %:p:h<cr>

nmap <leader>v :e $MYVIMRC<cr>
call yankstack#setup()
nmap Y y$

command! Smi :cd %:p:h | :!mymake

set ignorecase
set path+=$HOME/.local/bin/**
set path+=**
set path+=$XDG_CONFIG_HOME/**

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

set number relativenumber

augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Enable autocompletion:
set wildmode=longest,list,full

" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Goyo plugin makes text more readable when writing prose:
map <leader>f :Goyo \| set bg=light \| set linebreak<CR>

" MRU Plugin
let MRU_File = $XDG_DATA_HOME . '/nvim/mru/vim_mru_files'
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
map <leader>sc :!clear && shellcheck %<CR>
nnoremap <leader>so :w<cr>:so %<cr>

" Open my bibliography file in split
map <leader>b :e<space>$BIB<CR>
map <leader>R :e<space>$REFER<CR>

" Compile document, be it groff/LaTeX/markdown/etc.
map <leader>c :w! \| !compiler <c-r>%<CR>

" Open corresponding .pdf/.html or preview
map <leader>p :!opout <c-r>%<CR><CR>

" Runs a script that cleans out tex build files whenever I close out of a .tex file.
autocmd VimLeave *.tex !texclear %

" Ensure files are read as what I want:
autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
autocmd BufRead,BufNewFile *.tex set filetype=tex

" Enable Goyo by default for mutt writting
" Goyo's width will be the line limit in mutt.
autocmd BufRead,BufNewFile /tmp/neomutt* let g:goyo_width=80
autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo
autocmd QuitPre /tmp/neomutt* :wqa!

" Automatically highlights all trailing whitespace on save.
" autocmd BufWritePre * %s/\s\+$//e
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" When shortcut files are updated, renew bash and vifm configs with new material:
autocmd BufWritePost ~/.config/shortcuts/bmdirs,~/.config/shortcuts/bmfiles !shortcuts ;via -ro

" Run xrdb and wal whenever Xdefaults or Xresources are updated.
autocmd BufWritePost *Xresources,*Xdefaults :exe 'silent! !xrdb % ;wal -c ;wal -n -i ~/.config/wall.png ;$TERMINAL $EDITOR % &' | q!
autocmd BufWritePost */via/websites !via -ro

autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd
