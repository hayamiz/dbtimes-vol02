 The Database Times vol.2 の記事執筆ことはじめ
===============================================

1. gitレポジトリをチェックアウトする
------------------------------------

    $ git clone git@github.com:hayamiz/dbtimes-vol02.git

以降の説明では，チェックアウトしたレポジトリのパスを `/path/to/dbtimes-vol02` として説明します。

2. 自分の記事ファイルを作る
---------------------------

The Database Times vol.2 の執筆では，1記事ごとに1ファイルを作成することになっています。
ファイル名の命名規則は，`<githubアカウント名>-<通し番号>.tex` です。

たとえば，hayamiz が1つめの記事ファイルを作るときには：

    $ cd /path/to/dbtimes-vol02
    $ cp article-template.tex hayamiz-01.tex

次に，作成した記事ファイルが本の中に取り込まれるように，`book.tex` に input 命令を追加します。

`book.tex` をエディタで開いて，大体230行目あたりを見ると，次のような部分があります。

    % 本文ここから
    \input{bob-01}
    \input{alice-01}
    % 本文ここまで

ここに，さっき作成したファイル名を読み込む input 命令を追加しましょう。

    % 本文ここから
    \input{bob-01}
    \input{alice-01}
    \input{hayamiz-01}  % new!
    % 本文ここまで

3. コンパイルする
-----------------

記事ファイルの作成がおわったら，コンパイルしてみましょう。
コンパイルには，LaTeX の処理系とビルドシステム OMake が必要です。
Linuxであれば，どちらも割と簡単にインストールできると思います。
Windowsの人は，VirtualBoxで仮想環境にLinuxを入れるなり，気合で頑張るなりしてください。

  * LaTeX は apt 等でインストールするよりも TeX Live 2011 がおすすめです
    * 参考: http://blog.livedoor.jp/vine_user/archives/51909130.html
  * OMake は `apt-get install omake` すると入ります

環境が整ったら，次のコマンドを叩きましょう：

    $ cd /path/to/dbtimes-vol02
    $ omake

うまくいけば，`book.dvi` と `book.pdf` というファイルが生成されるはずです。

4. 記事を書きまくる
-------------------

コンパイルできることを確認したら，記事を書きまくりましょう。

5. 書いた記事をコミットする
---------------------------

記事を書いたら，定期的にgitレポジトリにコミットして，githubにpushしましょう。

6. Jenkins氏の機嫌を伺う
------------------------

githubにpushされるたびに，Jenkinsが原稿をコンパイルして，エラーがないかチェックします。
 自分のコミットの結果にJenkins氏が腹を立てていないか， http://jenkins.hayamiz.com/job/dbtimes-vol02/ で確認しましょう。
