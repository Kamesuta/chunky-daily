#!/bin/bash

# 環境設定
export SCRIPT_DIR=$(cd $(dirname $0); pwd)
source $SCRIPT_DIR/lib/common.sh

# $SCENE_DIR内のフォルダをループする
for SCENE in "$SCENE_DIR"/*; do
  # フォルダ名を取得する
  SCENE_NAME=$(basename "$SCENE")
  # scene.jsonがあるかチェックする
  if [ ! -f "$SCENE/scene.json" ]; then
    # ない場合警告をechoする
    echo "警告: $SCENE_NAMEフォルダにscene.jsonがありません"
  fi
  # summary.txtがあるかチェックする
  if [ ! -f "$SCENE/summary.txt" ]; then
    # ない場合警告をechoする
    echo "警告: $SCENE_NAMEフォルダにsummary.txtがありません"
  fi
done
