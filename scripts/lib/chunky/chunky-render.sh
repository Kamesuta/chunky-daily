#!/bin/bash

# シーンの名前
SCENE_NAME=$1

# ダンプファイルの削除 (ワールドを差し替えるため、前回のワールドのレンダリング結果を削除する)
rm -f $CHUNKY_HOME/scenes/**/*.dump
rm -f $CHUNKY_HOME/scenes/**/*.octree2

# ワールドのレンダリング
chunky -render $SCENE_NAME -f
# 画像の出力
chunky -snapshot $1 $SCENE_DIR/$SCENE_NAME/output.png