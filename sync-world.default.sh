#!/bin/bash

# ワールドの同期 (worldフォルダがこの階層に配置される必要がある)
rsync -azvv -e 'ssh -i ~/.ssh/秘密鍵のパス' ユーザーアカウント@IPアドレス:/取得するワールドのパス/world .