set nocompatible              " be iMproved, required

" Load plugins
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

syntax on
filetype plugin indent on    " required

" Custom vimrc

" Set font
set guifont=Menlo\ for\ Powerline:h13
" set guifont=Source\ Code\ Pro\ for\ Powerline:h14


" Set Theme
colorscheme jellybeans
let g:airline_powerline_fonts = 1
set t_Co=256
" set term=xterm-256color
set termencoding=utf-8
set fillchars+=stl:\ ,stlnc:\

set showcmd       " display incomplete commands
set noshowmode    " powerline shows the mode
set autowrite     " Automatically :write before running commands
set backspace=2   " Backspace deletes like most programs in insert mode
set ruler
set noswapfile
set laststatus=2  " Always display the status line
set number

" Make it obvious where 120 characters is
set textwidth=120
set colorcolumn=+1

"" Whitespace
" set wrap                      " don't wrap lines
set tabstop=2 shiftwidth=2      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)
set shiftround

"" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

" display trailing whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" no beeps!
set visualbell
set t_vb=

" Open new splits to the right and below
set splitbelow
set splitright

let mapleader = " "

" Default values, keep for consitency
set nobackup
set nowritebackup
set history=200

" auto read changes from the filesystem
set autoread

" END Defaults

" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1

" Use one space, not two, after punctuation.
set nojoinspaces

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Always use vertical diffs
set diffopt+=vertical

" Key Mapping

" j and k move into wrapped lines
nmap k gk
nmap j gj

" Remap the arrow keys to do nothing
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" Exit insert mode by pressing jj
inoremap jj <ESC>

" Switch between files by hitting ,, twice
noremap <leader><leader> <c-^>

" Navigate through splits more easily
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" double percentage sign in command mode is expanded
" to directory of current file - http://vimcasts.org/e/14
cnoremap %% <C-R>=expand('%:h').'/'<cr>

map <leader>so :source ~/.vimrc<cr>:PlugInstall<cr>
map <leader>sn :source ~/.vimrc<cr>
map <leader>h :nohlsearch<cr>
map <Leader>p :set paste<CR><esc>"*]p:set nopaste<cr>

" vim-test mappings
nnoremap <silent> <Leader>t :TestFile<CR>
nnoremap <silent> <Leader>s :TestNearest<CR>
nnoremap <silent> <Leader>l :TestLast<CR>
nnoremap <silent> <Leader>a :TestSuite<CR>
nnoremap <silent> <leader>gt :TestVisit<CR>

nnoremap <leader>rr :VtrResizeRunner<cr>
nnoremap <leader>ror :VtrReorientRunner<cr>
nnoremap <leader>sc :VtrSendCommandToRunner<cr>
vnoremap <leader>sl :VtrSendLinesToRunner<cr>
nnoremap <leader>or :VtrOpenRunner<cr>
nnoremap <leader>kr :VtrKillRunner<cr>
nnoremap <leader>fr :VtrFocusRunner<cr>
nnoremap <leader>dr :VtrDetachRunner<cr>
nnoremap <leader>ar :VtrReattachRunner<cr>
nnoremap <leader>cr :VtrClearRunner<cr>
nnoremap <leader>fc :VtrFlushCommand<cr>

" Swap 0 and ^. I tend to want to jump to the first non-whitesapce character
" so make that the easier one to do.
nnoremap 0 ^
nnoremap ^ 0

" Run commands that require an interactive shell
nnoremap <Leader>r :RunInInteractiveShell<space>

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  "autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
  autocmd Filetype gitcommit setlocal spell textwidth=72
	autocmd BufRead,BufNewFile *.md setlocal spell
augroup END

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" zoom a vim pane, <C-w>= to re-balance
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif
runtime macros/matchit.vim

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" GitGutter
set updatetime=250
set signcolumn=yes


if executable('rg')
  " Ctrlp
	set grepprg=rg\ --color=never
	let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
	let g:ctrlp_use_caching = 0
  " grep and Ack
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
  let g:ackprg = 'rg --vimgrep --no-heading'
endif
vnoremap <Leader>gg y:Ack! --fixed-strings <C-r>=shellescape(fnameescape(@"))<CR><CR>

" configure syntastic syntax checking to check on open as well as save
let g:syntastic_check_on_open=1
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]
let g:syntastic_eruby_ruby_quiet_messages =
    \ {"regex": "possibly useless use of a variable in void context"}

let g:fugitive_gitlab_domains = ['https://git.dsander.de', 'http://gitlab.flavoursys.lan']

" let test#strategy = "asyncrun"
let test#strategy = "dispatch"

" Fix a bug with tmux-2.3 and vim-dispatch (note the trailing space)
" "
" " https://github.com/tpope/vim-dispatch/issues/192
set shellpipe=2>&1\|\ tee\ 

" Project Notes
" -------------

" Quick access to a local notes file for keeping track of things in a given
" project. Add `.project-notes` to global ~/.gitignore

let s:PROJECT_NOTES_FILE = '.project-notes'

command! EditProjectNotes call <sid>SmartSplit(s:PROJECT_NOTES_FILE)
nnoremap <leader>ep :EditProjectNotes<cr>

autocmd BufEnter .project-notes call <sid>LoadNotes()

function! s:SmartSplit(file)
	let split_cmd = (winwidth(0) >= 100) ? 'vsplit' : 'split'
	execute split_cmd . " " . a:file
endfunction

function! s:LoadNotes()
	setlocal filetype=markdown
	nnoremap <buffer> q :wq<cr>
endfunction

" Prose - Configurations related to those times I write things that aren't code

function! s:PreviewInMarked()
	silent! call system("open -a 'Marked 2' " . expand("%:p"))
endfunction
command! PreviewInMarked call <sid>PreviewInMarked()
nnoremap <leader>md :PreviewInMarked<cr>


let g:rspec_runner = "dispatch"
" let g:rspec_command = "!clear && bin/rspec {spec}"
" let g:rspec_command = "compiler rspec | set makeprg=bundle\\ exec\\ rspec | make {spec}"

" Required for operations modifying multiple buffers like rename.
set hidden

let g:LanguageClient_serverCommands = {
		\ 'rust': ['rustup', 'run', 'nightly', 'rls'],
		\ }
let g:rustfmt_autosave = 1
