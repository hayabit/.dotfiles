"エンコーディング
"GUI版使ってるなら無効にした方がいいらしいです
set encoding=utf-8
scriptencoding utf-8

"vi互換をオフ
"これ記述しなくても互換はオフらしいです
set nocompatible

"カーソル位置表示
set ruler
"行番号表示
set number
"文字列置換をインタラクティブに表示するオプション
set inccommand=split

set sh=zsh

""""""""""""""""""""""""""""""

"カーソル移動
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
nnoremap <down> gj
nnoremap <up> gk
noremap <S-h> ^
noremap <S-j> }
noremap <S-k> {
noremap <S-l> $

"jjでノーマルモード
inoremap jj <esc>

"ノーマルモードのまま改行
nnoremap <CR> A<CR><ESC>
"ノーマルモードのままスペース
nnoremap <space> i<space><esc>

"rだけでリドゥ
nnoremap r <C-r>

"Yで行末までヤンク
nnoremap Y y$

"ESCキー2度押しでハイライトの切り替え
nnoremap <silent><Esc><Esc> :<C-u>set nohlsearch!<CR>

"NERDTreeToggle コマンドのショートカット
nnoremap <silent><C-t> :NERDTreeToggle<CR>

"余分な行末の半角スペースを削除
nnoremap <silent><C-d> :FixWhitespace<CR>

" vimを立ち上げたときに、自動的にvim-indent-guidesをオンにする
let g:indent_guides_enable_on_vim_startup = 1

" vimを立ち上げたときに、自動的にdeopleteをオンにする
let g:deoplete#enable_at_startup = 1

let g:rustfmt_autosave = 1
let g:rustfmt_command = '$HOME/.cargo/bin/rustfmt'

" swiftの自動補完on
let g:deoplete#sources#swift#daemon_autostart = 1

set hidden
let g:racer_cmd = '$HOME/.cargo/bin/racer'
let $RUST_SRC_PATH="/usr/local/src/rustc-1.5.0/src"

let g:nvim_nim_highlighter_semantics=1

let g:vim_markdown_conceal = 0
let g:tex_conceal=''
let g:vim_markdown_toc_autofit = 1

let g:previm_open_cmd = 'open -a Safari'
let g:previm_disable_default_css = 1
let g:previm_custom_css_path = '~/.config/nvim/markdown.css'

" texfile かつ v モード の時 gq で markdown を tex に変換できる
augroup texfile
  autocmd BufRead,BufNewFile *.tex set filetype=tex
  let md_to_latex  = "pandoc --from=markdown --to=latex"
  autocmd Filetype tex let &formatprg=md_to_latex
augroup END

augroup PrevimSettings
  autocmd!
  autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
augroup END

" neoterm 用の設定
let g:neoterm_autoscroll=1 " REPLを自動的に改行
let g:neoterm_default_mod='belowright'
tnoremap <silent> <ESC> <C-\><C-n><C-w>
tnoremap <silent> jj <C-\><C-n><C-w>
nnoremap <silent> <C-e> V:TREPLSendLine<CR>j0
" ノーマルモードで現在のカーソル行を実行
vnoremap <silent> <C-e> V:TREPLSendSelection<CR>'>j0
" ヴィジュアルモードで選択範囲を実行

" ale の設定
" 保存時のみ実行する
let g:ale_lint_on_text_changed = 0
" 表示に関する設定
let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚠'
let g:airline#extensions#ale#open_lnum_symbol = '('
let g:airline#extensions#ale#close_lnum_symbol = ')'
let g:ale_echo_msg_format = '[%linter%]%code: %%s'
highlight link ALEErrorSign Tag
highlight link ALEWarningSign StorageClass
" Ctrl + kで次の指摘へ、Ctrl + jで前の指摘へ移動
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

"ペースト時に自動インデントで崩れるのを防ぐ
if &term =~ "xterm"
  let &t_SI .= "\e[?2004h"
  let &t_EI .= "\e[?2004l"
  let &pastetoggle = "\e[201~"

  function XTermPasteBegin(ret)
    set paste
    return a:ret
  endfunction

  inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif


filetype plugin indent on

" quickrun
" normalモードで \r で実行
let g:quickrun_config = {}
let g:quickrun_config['swift'] = {
\ 'command': 'xcrun',
\ 'cmdopt': 'swift',
\ 'exec': '%c %o %s',
\}

""""""""""""""""""""""""""""""""""""""""

" プラグインが実際にインストールされるディレクトリ
let s:dein_dir = expand('~/.cache/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" 設定開始
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイルを用意しておく
  let g:rc_dir    = expand('~/.config/nvim')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " 設定終了
  call dein#end()
  call dein#save_state()
endif

" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif

""""""""""""""""""""""""""

"色
set background=dark
"カラーテーマは入れたら有効にしてください
let g:hybrid_use_iTerm_colors = 1
colorscheme hybrid

"行番号の色や現在行の設定
autocmd ColorScheme * highlight LineNr ctermfg=12
highlight CursorLineNr ctermbg=4 ctermfg=0
set cursorline
highlight clear CursorLine

"シンタックスハイライト
syntax enable

"オートインデント
set autoindent

"インデント幅
set shiftwidth=2
set softtabstop=2
set tabstop=2

"タブをスペースに変換
set expandtab
set smarttab

"言語ごとにインデント幅を変える
augroup fileTypeIndent
  autocmd!
  autocmd BufNewFile,BufRead *.py set filetype=python softtabstop=4 tabstop=4 shiftwidth=4
augroup END

"ビープ音すべてを無効にする
set visualbell t_vb=

"長い行の折り返し表示
set wrap

"検索設定
"インクリメンタルサーチしない
set noincsearch
"ハイライト
set hlsearch
"大文字と小文字を区別しない
set ignorecase
"大文字と小文字が混在した検索のみ大文字と小文字を区別する
set smartcase
"最後尾になったら先頭に戻る
set wrapscan
"置換の時gオプションをデフォルトで有効にする
set gdefault


"不可視文字の設定
set list
set listchars=tab:>-,eol:↲,extends:»,precedes:«,nbsp:%

"コマンドラインモードのファイル補完設定
set wildmode=list:longest,full

"入力中のコマンドを表示
set showcmd

"クリップボードの共有
set clipboard+=unnamedplus

"カーソル移動で行をまたげるようにする
set whichwrap=b,s,h,l,<,>,~,[,]

"カーソルラインをハイライト
set cursorline

"バックスペースを使いやすく
set backspace=indent,eol,start
set nrformats-=octal

set pumheight=10

"対応する括弧に一瞬移動
set showmatch
set matchtime=1
source $VIMRUNTIME/macros/matchit.vim " Vimの「%」を拡張する

"ウィンドウの最後の行もできるだけ表示
set display=lastline

"変更中のファイルでも保存しないで他のファイルを表示する
set hidden

"バックアップファイルを作成しない
set nobackup
"バックアップファイルのディレクトリ指定
set backupdir=$HOME/.dotfiles/.config/nvim/backup
"アンドゥファイルを作成しない
set noundofile
"アンドゥファイルのディレクトリ指定
set undodir=$HOME/.dotfiles/.config/nvim/backup
"スワップファイルを作成しない
set noswapfile

function! ZenkakuSpace()
  highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
endfunction

" 全角スペースの表示
if has('syntax')
  augroup ZenkakuSpace
    autocmd!
    autocmd ColorScheme * call ZenkakuSpace()
    autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('ZenkakuSpace', '　')
  augroup END
  call ZenkakuSpace()
endif

" nim.vim
fun! JumpToDef()
  if exists("*GotoDefinition_" . &filetype)
    call GotoDefinition_{&filetype}()
  else
    exe "norm! \<C-]>"
  endif
endf

" Jump to tag
nn <M-g> :call JumpToDef()<cr>
ino <M-g> <esc>:call JumpToDef()<cr>i

" Turn off paste mode when leaving insert
autocmd InsertLeave * set nopaste
