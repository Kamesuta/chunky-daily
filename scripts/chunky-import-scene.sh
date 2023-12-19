#!/bin/bash

# 環境設定
export SCRIPT_DIR=$(cd $(dirname $0); pwd)
source $SCRIPT_DIR/lib/common.sh

# パス設定
IMPORT_DIR=$WORK_DIR/import
EXPORT_DIR=$SCENE_DIR

# world.pathの値を$WORLD_DIRに置き換える
convert_json() {
  # 引数
  INPUT_JSON=$1
  OUTPUT_JSON=$2

  # 変換
  cat $INPUT_JSON \
      | jq --arg wd '$WORLD_DIR' '.world.path = $wd' \
      | jq --arg ch '$CHUNKY_HOME' 'walk(if type == "string" then gsub("C:\\\\Users\\\\[^\\\\]+\\\\.chunky"; $ch) else . end)' \
      | jq -r --arg ad '$ASSETS_DIR' 'walk(if type == "string" then gsub(".+\\\\assets"; $ad) else . end)' \
      | jq 'walk(if type == "string" then gsub("\\\\"; "/") else . end)' \
      > ${OUTPUT_JSON}
}

# importフォルダに入っているすべてのjsonファイルを変換する
for file in $(find $IMPORT_DIR -name "*.json"); do
  # フォルダ名を取得
  folder=$(basename $(dirname $file))
  # scenesフォルダに入れるファイル名を決める
  new_file="$EXPORT_DIR/$folder/scene.json"
  # scenesフォルダに入れるフォルダを作成する
  mkdir -p $(dirname $new_file)
  # 変換関数を呼び出す
  convert_json $file $new_file
  # importフォルダ内のjsonファイルを消す
  rm -rf $(dirname $file)
done
