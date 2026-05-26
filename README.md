# LPIC-1 Lab — Linux 学習環境 (Docker版)

LPIC-1 (試験 101 + 102) の取得に向けて、3 つのディストリビューションを切り替えながら手を動かして学べる Docker ベースの学習環境です。

## なぜ Docker を選んだか

| 候補 | 起動の速さ | リソース | systemd の挙動 | LPIC-1 学習適性 |
|------|----------|---------|---------------|----------------|
| **Docker (本構成)** | ◎ 数秒 | 軽い | privileged + cgroup=host で動かせる | ◎ 大半の試験範囲をカバー |
| VirtualBox / UTM | △ 1〜2分 | 重い (1台あたり 2GB) | 本物 | ◯ ブートローダや LVM/RAID は VM 向き |
| Multipass / Vagrant | ◯ 30秒 | 中 | 本物 | ◯ LPIC-2 のサーバ構築なら最適 |

LPIC-1 はコマンドライン中心で、ほぼ Docker で十分です。**ブートローダ (GRUB) やディスクパーティション切りなど一部の演習だけは VM が必要**になるので、その章にきたら VirtualBox での追加環境を案内します (Week 6 のロードマップ参照)。

## 構成

```
lpic-lab/
├── docker-compose.yml          # 3 ディストロを定義
├── lpic-lab.sh                 # 起動・操作用ランチャー
├── dockerfiles/
│   ├── Dockerfile.ubuntu       # Ubuntu 22.04 (apt系)
│   ├── Dockerfile.rocky        # Rocky Linux 9 (RHEL系, dnf/rpm)
│   └── Dockerfile.debian       # Debian 12 (apt系)
├── shared/                     # ホスト ↔ コンテナ共有 (/shared にマウント)
└── docs/
    ├── roadmap.md              # 12週間の学習計画
    └── cheatsheet.md           # 試験頻出コマンド集
```

## 必要なもの

- macOS (Intel) + **Docker Desktop** がインストールされていること
  - 未インストールなら: <https://www.docker.com/products/docker-desktop/>
  - 起動して鯨のアイコンが安定するまで待つ

## 使い方

```bash
# 1. ターミナルでこのフォルダに移動
cd /path/to/lpic-lab

# 2. 初回ビルド & 起動 (10〜15 分くらいかかります)
./lpic-lab.sh up

# 3. 好きなディストロに入る
./lpic-lab.sh ubuntu     # Ubuntu (apt)
./lpic-lab.sh rocky      # Rocky Linux (dnf/rpm)
./lpic-lab.sh debian     # Debian (apt)

# 4. 終了
exit                     # コンテナから抜けるだけ (停止はしない)
./lpic-lab.sh down       # 全部停止
./lpic-lab.sh reset      # ボリュームごと全リセット (やり直したい時)
```

## ログイン情報

| ユーザ | パスワード | 権限 |
|--------|-----------|------|
| `student` | `student` | sudo NOPASSWD (推奨) |
| `root` | `root` | 直接ログイン可 |

プロンプトの色でディストロが分かるようにしています:
- 🟢 緑 = Ubuntu
- 🔴 赤 = Rocky
- 🟣 紫 = Debian

## 学習の進め方

1. `docs/roadmap.md` を開いて、今週のテーマを確認
2. ロードマップに書かれた Lab コマンドをコンテナ内で実行
3. 詰まったら `docs/cheatsheet.md` を参照
4. その週のチェックポイントを全部✓できたら次の週へ
5. Week 6 と Week 12 で模擬試験 (Ping-t などの外部リソース) を実施

## トラブルシューティング

**ビルドが途中で止まる / dnf が失敗する**
- ネットワーク回線を確認してから `./lpic-lab.sh reset && ./lpic-lab.sh up`

**Docker Desktop が「Resources が足りない」と言う**
- Docker Desktop → Settings → Resources で CPU を 2 以上, メモリを 4GB 以上に

**systemd 関連のコマンドが「Failed to connect to bus」になる**
- `docker-compose.yml` の `privileged: true` と `cgroup: host` が効いているか確認 (古い Docker Desktop だと cgroup v2 まわりでうまくいかないことがある — Docker Desktop を最新版に更新)

**Apple Silicon Mac の人へ**
- 本構成は Intel Mac 向けの `platform: linux/amd64` 固定。M1/M2 でも動きますが、エミュレーションで重くなります。M シリーズなら `platform` 行を削除して ARM ネイティブにすると軽快に動きます。

## VM が必要になったら

ロードマップの Week 6 (パーティション/ブートローダ) と LPIC-2 へ進む時に、VM 環境を追加するのがおすすめです。Intel Mac なら:

- **VirtualBox** + Rocky Linux 9 ISO (無料, 王道)
- **UTM** (macOS ネイティブで軽い)
- **Multipass** (Ubuntu に特化、コマンド一発で VM が立つ)

声をかけてくれれば追加セットアップ用の Vagrantfile も用意します。

## ライセンス・参考

- このラボ環境自体は MIT 相当 (自由に改変・配布 OK)
- LPIC 公式試験範囲: <https://www.lpi.org/our-certifications/lpic-1-overview>
