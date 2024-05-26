# LaTeX environment with Docker

Dockerを用いて，LaTeX環境を構築するレポジトリ

## Dockerによる環境構築の手法

1. Dockerfileをかく
2. 以下のコマンドを実行．`-t`によってタグをつけている．最後のドットはDockerfileの位置を指す．

```bash
docker build -t latex-ubuntu:<tagname> .
```

## 環境のpush

GitHub Container registryにアップロードする．アップロード手順は以下の通り．

1. GitHub Container registryにログイン．

```bash
docker login ghcr.io -u <user_id>
```

パスワードを求められるので，入力する．パスワードは予めアクセストークンを発行して使うと良い．write:packagesの権限をつけておく．
あるいは，ファイルに書き込んでおいて(以下では`ghcr_token.txt`)，標準入力で渡す．

```bash
cat ghcr_token.txt | docker login ghcr.io -u <user_id> --password-stdin
```
2. `ghcr.io`用にタグを発行する．

```bash
docker tag <src_image_tag> ghcr.io/<user_id or organization_name>/<package_name>:<tag>
```
たとえば，
```bash
docker tag latex-ubuntu:<tagname> ghcr.io/mo-mo-666/latex-ubuntu:<tagname>
```

3. イメージを`push`する．

```bash
docker push ghcr.io/<user_id or organization_name>/<package_name>:<tag>
```
たとえば，
```bash
docker push ghcr.io/mo-mo-666/latex-ubuntu:<tagname>
```

詳しくは以下を参照．  
https://zenn.dev/rhene/scraps/182dff75bf7b64


## 環境について
TeX Live 2022

`.latexmkrc` と `.latexindentrc.yaml` はホームディレクトリにおいてあるが，上書き可能．


## 環境の使用方法
GitHub Container registryから環境をpull

```bash
docker pull ghcr.io/mo-mo-666/latex-ubuntu:<tagname>
```
実行は以下のコマンドを用いる．

bashの場合
```bash
docker run --rm -it -v $(pwd):/workdir
```
fishの場合
```fish
docker run --rm -it -v (pwd):/workdir
```
