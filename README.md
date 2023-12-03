# asyncomplete-spell

## 概要

[asyncomplete.vim](https://github.com/prabirshrestha/asyncomplete.vim) の補完で正しいスペル候補をだす

## 要件

* Vim 8.0 以上
* [asyncomplete.vim](https://github.com/prabirshrestha/asyncomplete.vim)

## インストール

使用しているパッケージ・マネージャに従えば良い

### [Vundle](https://github.com/gmarik/vundle)

``` vim
Plug 'iranoan/asyncomplete-spell'
```

### [Vim-Plug](https://github.com/junegunn/vim-plug)

``` vim
Plug 'iranoan/asyncomplete-spell'
```

### [NeoBundle](https://github.com/Shougo/neobundle.vim)

``` vim
NeoBundle 'iranoan/asyncomplete-spell'
```

### [dein.nvim](https://github.com/Shougo/dein.vim)

``` vim
call dein#add('iranoan/asyncomplete-spell')
```

### Vim packadd

``` sh
$ git clone https://github.com/iranoan/asyncomplete-spell ~/.vim/pack/iranoan/start/asyncomplete-spell
```

遅延読み込みをさせるなら

``` sh
$ git clone https://github.com/iranoan/asyncomplete-spell ~/.vim/pack/iranoan/opt/asyncomplete-spell
```

## 設定方法
\~/.vim/vimrc などの設定ファイルに次のような記載を加える

``` vim
call asyncomplete#register_source(asyncomplete#sources#spell#get_source_options({
  \ 'priority': 5,
  \ }))
\ }))
```

英語を想定しているので、それ以外の言語で使う場合は綴りに使う文字設定必要で、デフォルト相当は
``` vim
call asyncomplete#register_source(asyncomplete#sources#spell#get_source_options({
  \ 'refresh_pattern': '\m\c\([A-Z]\{2,}\|[A-Z]\+''[A-Z]\+\)$',
  \ 'allowlist': ['*'],
  \ }))
```

## 使用方法

![使用例](asyncomplete-spell.gif)

設定が終われば、[asyncomplete.vim](https://github.com/prabirshrestha/asyncomplete.vim) の候補に正しいスペルとメニュー項目として

* タイプされている単語が正しければ [spell:good] 
* そうでなければ [spell:--] と -- 部に [spellbadword()](https://vim-jp.org/vimdoc-ja/builtin.html#spellbadword%28%29) によるスペルミスの種類を表示する

CamelCase の綴りは全体でスペル・チェックしてミスが有る場合は、末尾部分で大文字で区切った最長一致でチェックしている 
例えば LuaLaTeX では、次の順でチェックしていく

* LuaLaTeX
* LaTeX
* TeX
