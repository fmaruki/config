set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" plugin manager, like pathogen
Plugin 'gmarik/Vundle.vim'

" search script, like grep, used by other plugins
Plugin 'mileszs/ack.vim'

" easy way to find files, buffers, lines
Plugin 'kien/ctrlp.vim'

" auto-closes parentheses and quotes
Plugin 'Raimondi/delimitMate'

" autocomplete for javascript with context
Plugin 'marijnh/tern_for_vim'

" comments shortcut (gcc)
Plugin 'ope/vim-commentary'

" creates an yank ring (A-p/A-P), not obstrusive as easyClip
Plugin 'maxbrunsfeld/vim-yankstack'

" show git diff in side-ruler
Plugin 'airblade/vim-gitgutter'

" (C-A-f) to beautify javascript
Plugin 'maksimr/vim-jsbeautify'

" better visualization for json
Plugin 'elzr/vim-json'

" requirement for some plugins
Plugin 'Shougo/vimproc.vim'

" shows trailing whitespace, :FixWhitespace for cleaning
Plugin 'bronson/vim-trailing-whitespace'

" auto-complete, with docs for python (jedi)
Plugin 'Valloric/YouCompleteMe'

" find in files
Plugin 'dyng/ctrlsf.vim'

" organize notes (:Note), search with :RecentNotes
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-notes'

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

" Put your non-Plugin stuff after this line


" enable mouse in all modes
set mouse=a

" show line-numbers ruler
set number

" always show 3 lines above and below
set scrolloff=3

" tab config
set tabstop=4
set shiftwidth=4
set expandtab

" use system clipboard
set clipboard=unnamedplus

" don't need to save when chage buffer
set hidden

" incremental search, with optional case
set ignorecase
set smartcase
set incsearch

" change buffer shortcut
nmap <C-Left> :bp<CR>
nmap <C-Right> :bn<CR>


" js-beautify key-bindings
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
