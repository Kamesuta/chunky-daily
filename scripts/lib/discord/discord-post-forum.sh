#!/bin/bash

# 引数のチェック
if [ $# -lt 3 ]; then
  echo "使用方法: $0 photo_path forum_data_path summary_path"
  exit 1
fi

# 引数の代入
PHOTO_PATH=$1
FORUM_DATA_PATH=$2
SUMMARY_PATH=$3

# クエリーパラメーターの作成
WEBHOOK_QUERY="?wait=true"

# サマリーのデータの有無をチェック
if [ -f "$SUMMARY_PATH" ]; then
  # サマリーのデータが存在する場合
  # サマリーのデータを読み込む
  readarray -t SUMMARY_DATA < "$SUMMARY_PATH"

  # タイトルと説明を取得
  TITLE=${SUMMARY_DATA[0]}
  DESCRIPTION=$(for el in "${SUMMARY_DATA[@]:2}"; do echo -n "$el\\n"; done)
  
  # 2行目が空行であることを確認
  if [ -n "${SUMMARY_DATA[1]}" ]; then
    # 2行目が空行でない場合
    echo "エラー: サマリーファイルの2行目は空行である必要があります"
    exit 2
  fi
else
  # サマリーのデータが存在しない場合
  echo "エラー: サマリーファイルが存在しません: $SUMMARY_PATH"
  exit 3
fi

# ここで「☆◯月◯日の街の様子」というメッセージを生成する
# 昨日の日付を取得
DATE=$(date -d "yesterday" "+%m月%d日")
# 昨日の曜日を取得
WEEKDAY=$(date -d "yesterday" "+(%a)" | sed -e 's/(Sun)/(日)/' -e 's/(Mon)/(月)/' -e 's/(Tue)/(火)/' -e 's/(Wed)/(水)/' -e 's/(Thu)/(木)/' -e 's/(Fri)/(金)/' -e 's/(Sat)/(土)/')
# メッセージを組み立て
MESSAGE="☆$DATE $WEEKDAYの街の様子"

# フォーラムのデータの有無をチェック
if [ -f "$FORUM_DATA_PATH" ]; then
  # フォーラムのデータが存在する場合
  # フォーラムのデータを読み込む
  readarray -t FORUM_DATA < "$FORUM_DATA_PATH"
  # スレッドIDとメッセージIDを取得
  THREAD_ID=${FORUM_DATA[0]}
  MESSAGE_ID=${FORUM_DATA[1]}

  # クエリーパラメーターにthread_idを追加
  WEBHOOK_QUERY="$WEBHOOK_QUERY&thread_id=$THREAD_ID"

  # 置き換え用のpayload_jsonの作成
  PAYLOAD_JSON="{\"attachments\": []}"
  # 写真を置き換え
  curl -X PATCH -F "payload_json=$PAYLOAD_JSON" -F "file=@$PHOTO_PATH" "$DISCORD_WEBHOOK_URL/messages/$MESSAGE_ID$WEBHOOK_QUERY"

  # payload_jsonの作成
  POST_PAYLOAD_JSON="{\"content\": \"$MESSAGE\"}"
  # メッセージを投稿
  curl -F "payload_json=$POST_PAYLOAD_JSON" -F "file=@$PHOTO_PATH" "$DISCORD_WEBHOOK_URL$WEBHOOK_QUERY"
else
  # フォーラムのデータが存在しない場合
  # 新しくスレッドを作る
  PAYLOAD_JSON="{\"content\": \"$DESCRIPTION\", \"thread_name\": \"$TITLE\"}"
  # curlコマンドの実行
  RESPONSE=$(curl -F "payload_json=$PAYLOAD_JSON" -F "file=@$PHOTO_PATH" "$DISCORD_WEBHOOK_URL$WEBHOOK_QUERY")

  # jqでchannel_idとidを抽出
  CHANNEL_ID=$(echo "$RESPONSE" | jq -r '.channel_id')
  ID=$(echo "$RESPONSE" | jq -r '.id')
  # フォーラムのデータを保存
  echo "$CHANNEL_ID" > "$FORUM_DATA_PATH"
  echo "$ID" >> "$FORUM_DATA_PATH"

  # クエリーパラメーターにthread_idを追加
  WEBHOOK_QUERY="$WEBHOOK_QUERY&thread_id=$CHANNEL_ID"

  # メッセージを投稿するためのpayload_jsonの作成
  POST_PAYLOAD_JSON="{\"content\": \"$MESSAGE\"}"
  # curlコマンドの実行
  curl -F "payload_json=$POST_PAYLOAD_JSON" -F "file=@$PHOTO_PATH" "$DISCORD_WEBHOOK_URL$WEBHOOK_QUERY"
fi
