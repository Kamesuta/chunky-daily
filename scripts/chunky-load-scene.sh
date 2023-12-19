#!/bin/bash

# 環境設定
export SCRIPT_DIR=$(cd $(dirname $0); pwd)
source $SCRIPT_DIR/lib/common.sh

# パス設定
IMPORT_DIR=$SCENE_DIR
EXPORT_DIR=$CHUNKY_HOME/scenes

# 変数を置き換える
convert_json() {
    # 引数
    INPUT_JSON=$1
    OUTPUT_JSON=$2

    # 変換
    cat $INPUT_JSON \
        | jq --arg v "$CHUNKY_HOME" 'walk(if type == "string" then gsub("\\$CHUNKY_HOME"; $v) else . end)' \
        | jq --arg v "$WORLD_DIR" 'walk(if type == "string" then gsub("\\$WORLD_DIR"; $v) else . end)' \
        | jq --arg v "$ASSET_DIR" 'walk(if type == "string" then gsub("\\$ASSET_DIR"; $v) else . end)' \
        > ${OUTPUT_JSON}
}

# scenesフォルダに入っているすべてのjsonファイルを変換する
for file in $(find $IMPORT_DIR -name "scene.json"); do
  # フォルダ名を取得
  folder=$(basename $(dirname $file))
  # scenesフォルダに入れるファイル名を決める
  new_file="$EXPORT_DIR/$folder/$folder.json"
  # scenesフォルダに入れるフォルダを作成する
  mkdir -p $(dirname $new_file)
  # 変換関数を呼び出す
  convert_json $file $new_file
done
