#!/bin/bash

# ChunkyLauncher.jarがない場合
if [ ! -f "$WORK_DIR/ChunkyLauncher.jar" ]; then
  # ChunkyLauncher.jarをダウンロードする
  wget -P $WORK_DIR https://chunkyupdate.lemaik.de/ChunkyLauncher.jar
fi

# アップデート
chunky --update
# マインクラフトのバージョンを指定してダウンロード
chunky -download-mc 1.20.1
