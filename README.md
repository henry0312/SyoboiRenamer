# SyoboiRenamer

ファイル名をもとに[しょぼいカレンダー](http://cal.syoboi.jp/)から情報を取得し自動でリネームするプログラムです。[Chinachu](https://github.com/kanreisa/Chinachu)の録画後コマンドで使うことを前提に作りましたが、ファイル名を規則通りに付けることで、別ソフトウェアから使うこともできます。SCRenameにインスパイアされています。

このReadmeはChinachuと一緒に使うことを前提に書かれています。

## システム要件

* Ruby >= 2.2 (1.9, 2.0, 2.1でも動くかもしれませんが動作確認していません）
* しょぼいカレンダーのアカウント（チャンネル設定済み）

開発（動作確認）環境は

* Ubuntu Server 14.04 LTS
* OS X 10.9
* Ruby 2.2.1

## 設定

### config.rb

しょぼいカレンダーのユーザ名を設定してください。このユーザはしょぼいカレンダー上でチャンネル設定が済んでいる事が前提となります。

```ruby
USER = "henry"
```

リネーム後のファイル名テンプレートを設定してください。

```ruby
TEMPLATE = "$Title$/[$StTime$][$ChName$] $Title$ \#$Count$ $SubTitle$.m2ts"
```

使える書式は以下の通りです。

| 書式         | 説明                  | 
|--------------|-----------------------|
| `$Title$`    | タイトル              |
| `$SubTitle$` | サブタイトル          |
| `$Count$`    | 話数                  |
| `$ChName$`   | チャンネル名          |
| `$StTime$`   | 放送開始時間 (yymmdd) |

また、`/`が含まれる場合はディレクトリを作成します。

`config.rb`はRubyプログラムであることに注意してください。

### channel.json

チャンネルを定義します。

```json
{
    "<Chinachuのチャンネル>" : [ "<しょぼいカレンダーのチャンネル名>", "<変換後のチャンネル名>" ]
}
```

設定例は`channel.json`を参考にしてください。

### replace.json

リネーム前後の置換ルールを設定します。優先順位はそれぞれ定義した順番通りです。

```json
{
    "pre" : [
        ["<リネーム前の置換文字列>", "<置換文字列>"]
    ],
    "post" : {
        ["<リネーム後の置換文字列>", "<置換文字列>"]
    }
}
```

設定例は`replace.json`を参考にしてください。

### Chinachu

Chinachuの`recordedFormat`を以下のように変更してください。

```json
"recordedFormat": "<date:yymmddHHMM>_<title>_<type><channel>.m2ts"
```

もし、デフォルト（`[<date:yymmdd-HHMM>][<type><channel>][<tuner>]<title>.m2ts`）のまま使いたい場合は、`syobocal.rb`内の`time`, `title`, `channel`を取得する箇所を、例えば、

```ruby
time = ""
title = ""
channel = ""
if /^\[(\d{6})-(\d{4})\]\[(\w+)\]\[[\w-]+\](.+)\.m2ts$/ =~ ARGV[0]
  time = $1 + $2
  title = $4
  channel = $3
end
```

上記のように変更すれば利用可能です。

## 使い方

```sh
syobyoi.rb <対象ファイル>
```

と実行することで、対象ファイルをテンプレートに従ってリネームします。

また、標準出力と標準エラーにそれぞれリネーム後のファイルパスを出力します。リネームしなかった場合は、対象ファイルの絶対パスがそのまま出力されます。例えば、シェルスクリプト内で以下のような一連の処理に組み込むことができます。

```sh
#!/usr/bin/env bash

eval "$(rbenv init -)"

RENAMED=`/home/henry/SyoboiRenamer/syobocal.rb "$1" 2>/dev/null`
chmod 644 "${RENAMED}" 2>/dev/null
```

### 動作例

```sh
./syobocal.rb "1503300110_ＳＨＩＲＯＢＡＫＯ_BS181.m2ts"
/Users/henry/work/SyoboiRenamer/SHIROBAKO/[150330][BS-FUJI] SHIROBAKO #24 遠すぎた納品.m2ts
/Users/henry/work/SyoboiRenamer/SHIROBAKO/[150330][BS-FUJI] SHIROBAKO #24 遠すぎた納品.m2ts
```

### Chinachu

Chinachuで使う場合は`config.json`内で、例えば

```json
"recordedCommand": "/path/to/SyoboiRenamer/syoboi.rb"
```

とします。詳細は[Configuration recordedCommand · kanreisa/Chinachu Wiki](https://github.com/kanreisa/Chinachu/wiki/Configuration-recordedCommand)を参照してください。

## ライセンス

The MIT License (MIT)  
Copyright (c) 2015 Tsukasa OMOTO