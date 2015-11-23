set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
Plugin 'mileszs/ack.vim'
Plugin 'kien/ctrlp.vim'
" Plugin 'Raimondi/delimitMate'
Plugin 'marijnh/tern_for_vim'
Plugin 'ope/vim-commentary'
"Plugin 'svermeulen/vim-easyclip'
Plugin 'maxbrunsfeld/vim-yankstack'
Plugin 'airblade/vim-gitgutter'
Plugin 'maksimr/vim-jsbeautify'
Plugin 'elzr/vim-json'
Plugin 'Shougo/vimproc.vim'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'Valloric/YouCompleteMe'
Plugin 'dyng/ctrlsf.vim'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-notes'
Plugin 'severin-lemaignan/vim-minimap'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
Plugin 'tpope/vim-surround'
" Plugin 'scrooloose/syntastic'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


" enable mouse in all modes
set mouse=a
set number
set scrolloff=3
set tabstop=4
set shiftwidth=4
set expandtab
set clipboard=unnamedplus
set hidden
set ignorecase
set smartcase
set incsearch
set ruler
set laststatus=2
set wildmenu
highlight LineNr ctermbg=white ctermfg=black
highlight StatusLine ctermbg=white ctermfg=blue
au InsertEnter * hi StatusLine ctermbg=white ctermfg=green
au InsertLeave * hi StatusLine ctermbg=white ctermfg=blue
"set rulerformat=%f\ %y\ %=%m\ %{strftime('%a\ %e/%b/%Y\ %I:%M')}\ col%c\ %P
set statusline=%<%f\ [%Y]\ %h%m%r%=%-25.(%{strftime('%a\ %e/%b/%Y\ %H:%M')}%)
set statusline+=[%{len(filter(range(1,bufnr('%')),'buflisted(v:val)'))}/%{len(filter(range(1,bufnr('$')),'buflisted(v:val)'))}\ Buffers]\ col%c\ %P

" execute pathogen#infect()
" syntax on
" filetype plugin indent on


" js-beautify
autocmd FileType javascript noremap <buffer>  <c-a-f> :call JsBeautify()<cr>
autocmd FileType html noremap <buffer> <c-a-f> :call HtmlBeautify()<cr>
autocmd FileType css noremap <buffer> <c-a-f> :call CssBeautify()<cr>
autocmd FileType json noremap <buffer> <c-a-f> :call JsonBeautify()<cr>
autocmd FileType javascript vnoremap <buffer>  <c-a-f> :call RangeJsBeautify()<cr>
autocmd FileType html vnoremap <buffer> <c-a-f> :call RangeHtmlBeautify()<cr>
autocmd FileType css vnoremap <buffer> <c-a-f> :call RangeCSSBeautify()<cr>
autocmd FileType json vnoremap <buffer> <c-a-f> :call RangeJsonBeautify()<cr>


" ctrl-p
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_cmd = 'CtrlPLastMode'
let g:ctrlp_extensions = ['line']
nnoremap <space>f :CtrlPMixed<CR>
nnoremap <space>b :CtrlPBuffer<CR>
nnoremap <space>/ :CtrlPLine<CR>

" ctrl-s-f
nmap <C-F> <Plug>CtrlSFPrompt
vmap <C-F> <Plug>CtrlSFVwordPath

nmap <C-Left> :bp<CR>
nmap <C-Right> :bn<CR>

" syntastic
let g:syntastic_python_checkers = ['pylint']
