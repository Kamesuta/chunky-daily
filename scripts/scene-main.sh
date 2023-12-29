#!/bin/bash

# 環境設定
export SCRIPT_DIR=$(cd $(dirname $0); pwd)
source $SCRIPT_DIR/lib/common.sh

# フォルダ名を取得する
SCENE_NAME=$1

# シーンパス
SCENE="$SCENE_DIR/$SCENE_NAME"

# Chunkyのレンダリング
bash $SCRIPT_DIR/lib/chunky/chunky-render.sh "$SCENE_NAME"

# summary.txt, forum_data.txt, output.pngのパスを取得する
SUMMARY_PATH="$SCENE/summary.txt"
FORUM_DATA_PATH="$SCENE/forum_data.txt"
PHOTO_PATH="$SCENE/output.png"

# ./discord-post-forum.shを呼び出す
bash $SCRIPT_DIR/lib/discord/discord-post-forum.sh "$PHOTO_PATH" "$FORUM_DATA_PATH" "$SUMMARY_PATH"
