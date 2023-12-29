#!/bin/bash

# 環境設定
export SCRIPT_DIR=$(cd $(dirname $0); pwd)
source $SCRIPT_DIR/lib/common.sh

# ワールドを取得する
bash $SCRIPT_DIR/lib/sync/sync-world.sh

# Chunky初期化
bash $SCRIPT_DIR/lib/chunky/chunky-init.sh

# $SCENE_DIR内のフォルダをループする
for SCENE in "$SCENE_DIR"/*; do
  # フォルダ名を取得する
  SCENE_NAME=$(basename "$SCENE")

  # シーンの処理
  bash $SCRIPT_DIR/scene-main.sh "$SCENE_NAME"
done
