#!/usr/bin/env bash
# LPIC-1 学習環境のお手軽ランチャー
# 使い方:
#   ./lpic-lab.sh up         全コンテナをビルド&起動
#   ./lpic-lab.sh ubuntu     Ubuntu に入る
#   ./lpic-lab.sh rocky      Rocky に入る
#   ./lpic-lab.sh debian     Debian に入る
#   ./lpic-lab.sh status     稼働状況
#   ./lpic-lab.sh reset      全リセット(ボリュームごと削除)
#   ./lpic-lab.sh down       停止&削除

set -euo pipefail
cd "$(dirname "$0")"

cmd="${1:-help}"

case "$cmd" in
  up)
    docker compose up -d --build
    echo ""
    echo "起動完了!  次のコマンドで好きなディストロに入れます:"
    echo "  ./lpic-lab.sh ubuntu | rocky | debian"
    ;;
  ubuntu|rocky|debian)
    docker compose exec "$cmd" bash
    ;;
  status)
    docker compose ps
    ;;
  down)
    docker compose down
    ;;
  reset)
    docker compose down -v
    echo "ボリュームを含めて削除しました。再構築は ./lpic-lab.sh up"
    ;;
  *)
    cat <<EOF
LPIC-1 Lab Launcher

サブコマンド:
  up        コンテナをビルド&起動
  ubuntu    Ubuntu コンテナに入る
  rocky     Rocky Linux (RHEL系) コンテナに入る
  debian    Debian コンテナに入る
  status    稼働中のコンテナを表示
  down      コンテナ停止&削除 (ボリュームは保持)
  reset     ボリュームごと全削除

ログイン情報:
  ユーザ: student / パスワード: student (sudo NOPASSWD)
  ルート: root    / パスワード: root
EOF
    ;;
esac
