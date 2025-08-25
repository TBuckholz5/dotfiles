" Plugins Required
" --------------------------------------------
" Fuzzzy-Vim
" ALE
" vim-lsp
" vim-lsp-settings
" delimitMate
" lightline
" surround.vim
" NERDTree
" undotree
" vim-gitgutter
" vim-fugitive
" vim-highlightedyank
" polyglot
" devicons
" gruvbox
" Place in ~/.vim/pack/plugins/start

" General Settings
" --------------------------------------------
set nu
set relativenumber

set showtabline=2
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set smartindent

set wrap

set nobackup

set nohlsearch
set incsearch

set scrolloff=8
set signcolumn="yes"
set isfname+=@-@

set updatetime=50

set termguicolors
set colorcolumn=120
let g:gruvbox_contrast_dark = "hard"
set background=dark
colorscheme gruvbox


syntax on

set conceallevel=2

let mapleader=" "
let maplocalleader=" "

set noshowmode

set breakindent

set ignorecase
set smartcase

set signcolumn=yes

set updatetime=250

set timeoutlen=1000

set splitright
set splitbelow
" set list
" set listchars=tab:» ,trail:·,nbsp:␣

set cursorline

set scrolloff=10

set confirm

" Remaps
" --------------------------------------------

"  Terminal
nnoremap <leader>tt <C-w>w
tnoremap <leader>tt <C-w>w
nnoremap <leader>tn :term<CR>
tnoremap <leader>td <C-d>

" Tabs
nnoremap <leader>cc :tabnew<CR>:tcd 

nnoremap <Esc> :nohlsearch<CR>

tnoremap <Esc><Esc> <C-\\><C-n>

nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

nnoremap J mzJ`z
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

xnoremap <leader>p "_dP

vnoremap <leader>y "+y
nnoremap <leader>Y "+Y

nnoremap <leader>d "_d
vnoremap <leader>d "_d

nnoremap Q <nop>

nnoremap <leader>q :q<CR>

" Harpoon
" --------------------------------------------
nnoremap ' :<C-u>marks<CR>:normal! `

" File search
" --------------------------------------------
nnoremap <leader>sf :FuzzyFiles<CR>
nnoremap <leader>s/ :FuzzyGrep<CR>
nnoremap <leader>sg :FuzzyGitFiles<CR>
nnoremap <leader>sb :FuzzyBuffers<CR>
nnoremap <leader>sh :FuzzyHelp<CR>
nnoremap <leader>/ :FuzzyInBuffer<CR>
let g:fuzzyy_enable_mappings=0
let g:fuzzyy_respect_gitignore = 1
let g:fuzzyy_keymaps = {
            \ 'menu_up': ["\<c-k>", "\<Up>"],
            \ 'menu_down': ["\<c-j>", "\<Down>"],
            \ 'menu_select': ["\<CR>"],
            \ 'preview_up': ["\<c-i>"],
            \ 'preview_down': ["\<c-f>"],
            \ 'preview_up_half_page': ["\<c-u>"],
            \ 'preview_down_half_page': ["\<c-d>"],
            \ 'cursor_begining': ["\<c-i>"],
            \ 'cursor_end': ["\<c-a>"],
            \ 'backspace': ["\<bs>"],
            \ 'delete_all': ["\<c-k>"],
            \ 'delete_prefix': [],
            \ 'exit': ["\<Esc>", "\<c-c>", "\<c-[>"],
            \}

" Grep
set wildignore+=*/node_modules/*,*/target/*,*/tmp/*,*/vscode/*,*/vs-cache/*,*/fingerprints.txt,*/gen/*,*/jsconfig.json
nnoremap <leader>cn :copen<CR>
nnoremap <leader>cd :cclose<CR>

" Git
" --------------------------------------------
" if executable('lazygit')
"     nnoremap <leader>gg :!lazygit<CR>
" else
"     nnoremap <leader>>gg :G<CR>
" endif
nnoremap <leader>gg :G<CR>
nnoremap <leader>gl :Git log --graph<CR>

" LSP
" --------------------------------------------
" ALE
set signcolumn=yes
let b:ale_fixers = {'javascript': ['prettier', 'eslint'], 'python': ['black']}
let g:ale_python_black_options='--line-length=120'
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1
set completeopt=menuone,noselect
autocmd ColorScheme * highlight link ALEVirtualTextError Error
autocmd ColorScheme * highlight link ALEError SpellBad


" vim-lsp
nnoremap <leader>gi :LspInstallServer<CR>

let g:lsp_semantic_enabled=1

if executable('pyright')
    " pip install python-lsp-server
    au User lsp_setup call lsp#register_server({
            \ 'name': 'pyright',
            \ 'cmd': {server_info->['pyright']},
            \ 'allowlist': ['python'],
            \ })
endif
if executable('typescript-language-server')
    " pip install python-lsp-server
    au User lsp_setup call lsp#register_server({
            \ 'name': 'typescript-language-server',
            \ 'cmd': {server_info->['typescript-language-server']},
            \ 'allowlist': ['javascript', 'typescript'],
            \ })
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> grd <plug>(lsp-definition)
    nmap <buffer> grs <plug>(lsp-document-symbol-search)
    nmap <buffer> grS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> grr <plug>(lsp-references)
    nmap <buffer> gri <plug>(lsp-implementation)
    nmap <buffer> grt <plug>(lsp-type-definition)
    nmap <buffer> <leader>grn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)

    " let g:lsp_format_sync_timeout = 1000
    " autocmd! BufWritePre *.rs,*.go,*.js,*.ts,*.py call execute('LspDocumentFormatSync')

    " refer to doc to add more commands
endfunction

augroup lsp_install
au!
" call s:on_lsp_buffer_enabled only for languages that has the server registered.
autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" Status Bar
" --------------------------------------------
set laststatus=2
" Replace filename component of Lightline statusline
let g:lightline = {
    \ 'component_function': {
        \   'filename': 'FilenameForLightline'
            \ }
    \ }

    " Show full path of filename
function! FilenameForLightline()
    return expand('%:p')
    endfunction

" Tree
" --------------------------------------------
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
nnoremap <silent> <expr> <leader>e g:NERDTree.IsOpen() ? "\:NERDTreeClose<CR>" : bufexists(expand('%')) ? "\:NERDTreeFind<CR>" : "\:NERDTree<CR>"

" UndoTree
" --------------------------------------------
nnoremap <leader>u :UndotreeToggle<CR>
if has("persistent_undo")
    let target_path = expand('~/.undodir')

    if !isdirectory(target_path)
        call mkdir(target_path, "p", 0700)
    endif

    let &undodir=target_path
    set undofile
endif
