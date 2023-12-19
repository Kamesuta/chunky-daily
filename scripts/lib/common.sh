#!/bin/bash

# 環境設定
export WORK_DIR=$(dirname $SCRIPT_DIR../)

# 処理に必要なフォルダパス
export CHUNKY_HOME=$WORK_DIR/chunky
export WORLD_DIR=$WORK_DIR/world
export ASSET_DIR=$WORK_DIR/assets
export SCENE_DIR=$WORK_DIR/scenes

# 設定読み込み
source $WORK_DIR/config.sh

# エイリアスを設定
chunky() {
    java -Dchunky.home="$CHUNKY_HOME" -jar ChunkyLauncher.jar $@
}
export -f chunky
