# LPIC-1 学習ロードマップ (12週間プラン)

> 対象: LPIC-1 (Exam 101 + 102) / Version 5.0
> 想定学習時間: 平日 1 時間 × 5 日 + 週末 2〜3 時間 = 週 7〜8 時間
> 合計: 約 90〜100 時間

LPIC-1 は「101 試験」と「102 試験」の 2 本立てで、両方合格すると認定されます。どちらから受けても良いですが、本ロードマップでは 101 → 102 の順を推奨しています。

---

## 全体スケジュール

| Week | 試験 | テーマ | 章 |
|------|------|-------|-----|
| 1 | 101 | システムアーキテクチャ | 101.1 / 101.2 / 101.3 |
| 2 | 101 | Linux のインストールとパッケージ管理 (Debian系) | 102.4 / 102.5 |
| 3 | 101 | Linux のインストールとパッケージ管理 (RPM系) | 102.4 / 102.5 / 102.6 |
| 4 | 101 | GNU と Unix コマンド (基本) | 103.1 / 103.2 / 103.3 |
| 5 | 101 | GNU と Unix コマンド (応用) | 103.4 / 103.5 / 103.6 / 103.7 / 103.8 |
| 6 | 101 | デバイス・ファイルシステム・FHS + **101 模擬試験** | 104.1〜104.7 |
| 7 | 102 | シェル・スクリプト・データ管理 | 105.1 / 105.2 / 105.3 |
| 8 | 102 | ユーザーインターフェイスとデスクトップ | 106.1 / 106.2 / 106.3 |
| 9 | 102 | 管理タスク (ユーザ、cron、ロケール) | 107.1 / 107.2 / 107.3 |
| 10 | 102 | 重要なシステムサービス (時刻、ログ、メール、印刷) | 108.1 / 108.2 / 108.3 / 108.4 |
| 11 | 102 | ネットワークの基礎 | 109.1 / 109.2 / 109.3 / 109.4 |
| 12 | 102 | セキュリティ + **102 模擬試験** + 復習 | 110.1 / 110.2 / 110.3 |

---

## Week 1 — システムアーキテクチャ (101.1〜101.3)

**学ぶこと**
- ハードウェア設定の決定と構成 (`lspci`, `lsusb`, `lsmod`, `dmesg`, `/proc`, `/sys`, `/dev`)
- システムのブート (BIOS/UEFI, ブートローダ, カーネル, init/systemd の流れ)
- ランレベルとブートターゲット (`runlevel`, `init N`, `systemctl isolate`, `systemctl get-default`)

**Lab (やってみる)**
```bash
./lpic-lab.sh ubuntu
lsmod                    # 読み込み済みカーネルモジュール
cat /proc/cpuinfo        # CPU 情報
cat /proc/meminfo        # メモリ情報
ls /sys/class/net/       # NIC 情報
systemctl get-default    # デフォルトのブートターゲット
systemctl list-units --type=target
```

**チェックポイント**
- [ ] `/proc` と `/sys` の違いを説明できる
- [ ] systemd と SysVinit のランレベル対応 (0=halt, 1=single, 3=multi-user, 5=GUI, 6=reboot) を覚えた
- [ ] ブート時のメッセージを `dmesg` と `journalctl -b` の両方で確認できる

---

## Week 2 — パッケージ管理 (Debian系)

**学ぶこと**
- `dpkg` (ローカルパッケージの操作), `dpkg-reconfigure`
- APT (`apt`, `apt-get`, `apt-cache`, `/etc/apt/sources.list`, `/etc/apt/sources.list.d/`)
- 依存解決と GPG キー

**Lab**
```bash
./lpic-lab.sh ubuntu
sudo apt update
apt list --installed | head
apt-cache search tree
sudo apt install -y tree
dpkg -L tree              # 配置ファイル一覧
dpkg -S /usr/bin/tree     # ファイルからパッケージ逆引き
dpkg -s tree              # ステータス
sudo apt remove tree
```

**チェックポイント**
- [ ] `apt` と `apt-get` の使い分けを説明できる
- [ ] `dpkg -i` 失敗時に `apt -f install` で依存を解決できる
- [ ] `/etc/apt/sources.list` のフォーマット (deb URL distribution component) を読める

---

## Week 3 — パッケージ管理 (RPM系) + 共有ライブラリ (102.6)

**学ぶこと**
- `rpm` コマンド (`-q`, `-i`, `-e`, `-V`)
- `yum` / `dnf` / `dnf-config-manager`, `/etc/yum.repos.d/`
- 共有ライブラリ: `ldd`, `ldconfig`, `/etc/ld.so.conf`, `LD_LIBRARY_PATH`

**Lab**
```bash
./lpic-lab.sh rocky
sudo dnf install -y tree
rpm -qa | head
rpm -qi tree              # パッケージ情報
rpm -ql tree              # 配置ファイル
rpm -qf /usr/bin/tree     # ファイルからパッケージ逆引き
rpm -V tree               # 改変検知
ldd /usr/bin/tree         # 依存ライブラリ
```

**チェックポイント**
- [ ] `rpm -qa` `-qi` `-ql` `-qf` `-V` の違いを覚えた
- [ ] Debian系↔RPM系のパッケージコマンド対応表が頭に入っている
- [ ] `ldconfig` がどんなファイルを更新するか説明できる

---

## Week 4 — GNU/Unix コマンド 基本 (103.1〜103.3)

**学ぶこと**
- シェルの仕組み (環境変数, エイリアス, 関数, ヒストリ, `bash`/`sh` の違い)
- テキスト処理: `cat`, `tac`, `head`, `tail`, `wc`, `sort`, `uniq`, `cut`, `paste`, `tr`, `sed`, `od`, `split`, `nl`
- ファイル操作: `cp`, `mv`, `rm`, `ln`, `find`, `xargs`

**Lab**
```bash
seq 1 20 | tail -5 | sort -r
echo "hello world" | tr 'a-z' 'A-Z'
find / -name "*.conf" 2>/dev/null | head
find /etc -type f -mtime -7    # 過去7日に変更されたファイル
ls -i /etc/hostname             # inode
ln -s /etc/hostname ~/hostname-link
```

**チェックポイント**
- [ ] パイプ (`|`) とリダイレクト (`>`, `>>`, `2>`, `&>`, `tee`) を使い分けられる
- [ ] ハードリンクとシンボリックリンクの違いを説明できる
- [ ] `find ... -exec` と `xargs` の違いを言える

---

## Week 5 — GNU/Unix コマンド 応用 (103.4〜103.8)

**学ぶこと**
- ストリーム/リダイレクト (FD 0/1/2, `tee`, `xargs`)
- プロセス管理: `ps`, `top`, `htop`, `kill`, `killall`, `pgrep`, `pkill`, `nohup`, `&`, `jobs`, `fg`, `bg`
- 実行優先度: `nice`, `renice`
- 正規表現: `grep`, `egrep`, `sed`, BRE と ERE の違い
- vi の基本 (モード, 検索置換, バッファ)

**Lab**
```bash
sleep 1000 &
jobs
ps -ef | grep sleep
kill %1
nice -n 10 sleep 60 &
ps -o pid,ni,cmd
grep -E '^[a-z]+:' /etc/passwd | head
sed -n '/^root/p' /etc/passwd
```

**チェックポイント**
- [ ] シグナル番号 (1=HUP, 2=INT, 9=KILL, 15=TERM, 18=CONT, 19=STOP) を暗記
- [ ] vi で `:%s/old/new/g`, `dd`, `yy`, `p`, `/`, `?`, `:wq` が打てる
- [ ] `grep -E` と基本正規表現の差 (`+`, `?`, `|`, `()`) を理解

---

## Week 6 — デバイス・ファイルシステム + 101 模擬試験 (104.1〜104.7)

**学ぶこと**
- パーティション (`fdisk`, `gdisk`, `parted`), MBR vs GPT
- ファイルシステム作成 (`mkfs.ext4`, `mkfs.xfs`, `mkswap`)
- マウント (`mount`, `umount`, `/etc/fstab`, UUID, ラベル)
- FHS (`/bin`, `/sbin`, `/etc`, `/var`, `/usr` の役割)
- ファイル検索: `find`, `locate`, `updatedb`, `which`, `type`, `whereis`
- パーミッション (rwx, SUID, SGID, sticky, umask, ACL)

**Lab**
```bash
# Docker環境ではループバックデバイスで疑似的に演習
sudo dd if=/dev/zero of=/tmp/disk.img bs=1M count=100
sudo mkfs.ext4 /tmp/disk.img
mkdir -p ~/mnt
sudo mount -o loop /tmp/disk.img ~/mnt
df -h ~/mnt
sudo umount ~/mnt

# パーミッション
chmod 4755 /tmp/test     # SUID
chmod g+s /tmp/test      # SGID
chmod +t /tmp/test       # sticky
umask 022
```

**模擬試験**
- 公式の出題例: <https://www.lpi.org/our-certifications/exam-101-objectives>
- Ping-t (無料登録) や 小豆本 (徹底攻略) の模擬問題で 60% 以上を目指す

**チェックポイント**
- [ ] FHS の主要ディレクトリの用途を全部言える
- [ ] パーミッション数値 (例 `4755`) を読み書きできる
- [ ] `/etc/fstab` の 6 フィールドを順番に書ける

---

## Week 7 — シェル・スクリプト・データ管理 (105.1〜105.3)

**学ぶこと**
- 環境変数の設定 (`export`, `set`, `env`, `unset`, `/etc/profile`, `~/.bashrc`)
- 関数, alias
- 簡単なシェルスクリプト (`if`, `for`, `while`, `case`, `[[ ]]`, `$1..$9`, `$#`, `$?`)
- SQL の基礎 (SELECT, INSERT, UPDATE, DELETE, JOIN, GROUP BY)

**Lab**
```bash
cat > ~/hello.sh <<'EOF'
#!/bin/bash
for f in "$@"; do
  if [[ -f "$f" ]]; then
    echo "$f は $(wc -l < "$f") 行"
  fi
done
EOF
chmod +x ~/hello.sh
~/hello.sh /etc/hostname /etc/passwd
```

**チェックポイント**
- [ ] `.bash_profile`, `.bashrc`, `.profile` の読み込み順を説明できる
- [ ] `$@` と `$*` の違いを言える
- [ ] 基本的な SELECT 文 (`WHERE`, `ORDER BY`, `GROUP BY`, `JOIN`) が書ける

---

## Week 8 — デスクトップ環境 (106.1〜106.3)

**学ぶこと**
- X Window System の仕組み (X サーバ vs クライアント, `DISPLAY`, `xhost`, `xauth`)
- ディスプレイマネージャ (gdm, lightdm, sddm)
- アクセシビリティ (スクリーンリーダ, スティッキーキー)
- Wayland と X.org の違い

> Docker では GUI を動かさないので、概念中心で OK。仕組み図を書けるレベルで暗記。

**チェックポイント**
- [ ] `DISPLAY=:0.0` の意味を説明できる
- [ ] `xhost +` のセキュリティリスクを言える

---

## Week 9 — 管理タスク (107.1〜107.3)

**学ぶこと**
- ユーザ/グループ管理: `useradd`, `usermod`, `userdel`, `groupadd`, `passwd`, `chage`, `/etc/passwd`, `/etc/shadow`, `/etc/group`, `/etc/gshadow`
- ジョブスケジューリング: `cron` (`/etc/crontab`, `/etc/cron.d/`, `crontab -e`), `anacron`, `at`, `systemd-timer`
- ローカライズ: `locale`, `LC_*`, `LANG`, `TZ`, `iconv`, `tzselect`, `hwclock`, `timedatectl`

**Lab**
```bash
sudo useradd -m -s /bin/bash alice
sudo passwd -S alice
sudo chage -l alice
sudo passwd -e alice               # 次回ログインでパスワード変更要求
crontab -e
# 例: */5 * * * * date >> /tmp/cron.log
timedatectl                        # systemd
date '+%Y-%m-%d %H:%M:%S %Z'
```

**チェックポイント**
- [ ] `/etc/passwd` の 7 フィールドを順番に書ける
- [ ] cron 表記 (分 時 日 月 曜日) の各フィールドの範囲を覚えた
- [ ] `at`, `cron`, `anacron`, `systemd-timer` を使い分けられる

---

## Week 10 — 重要なシステムサービス (108.1〜108.4)

**学ぶこと**
- 時刻: NTP, `chrony`, `ntpd`, `timedatectl`
- システムログ: `rsyslog` (`/etc/rsyslog.conf`, facility/priority), `systemd-journald` (`journalctl`), `logrotate`
- メール: MTA の役割, `/etc/aliases`, `newaliases`, `mailq`
- 印刷: CUPS (`lpr`, `lpq`, `lprm`)

**Lab**
```bash
sudo systemctl status rsyslog
logger -t MYAPP "test message"
sudo journalctl -u rsyslog --since "10 min ago"
journalctl -p err -b           # ブート以降のエラーのみ
cat /etc/logrotate.conf
```

**チェックポイント**
- [ ] syslog の facility (auth, cron, daemon, kern, mail, user, local0-7) を覚えた
- [ ] `journalctl` の主要オプション (`-u`, `-p`, `-f`, `--since`, `-b`) を言える
- [ ] `logrotate` の主要ディレクティブ (daily, rotate, compress, missingok, postrotate)

---

## Week 11 — ネットワーク基礎 (109.1〜109.4)

**学ぶこと**
- IP の基礎 (IPv4/IPv6, サブネットマスク, プライベートアドレス範囲, well-known ports)
- 設定: `ip`, `ifconfig` (旧), `nmcli`, `nmtui`, `/etc/network/interfaces`, NetworkManager
- 名前解決: `/etc/hosts`, `/etc/resolv.conf`, `/etc/nsswitch.conf`, `dig`, `host`, `nslookup`, `getent`
- トラブルシュート: `ping`, `traceroute`, `tracepath`, `mtr`, `ss`, `netstat`, `tcpdump`, `nmap`

**Lab**
```bash
ip addr show
ip route
ss -tlnp                  # LISTEN中のTCPポート
cat /etc/resolv.conf
dig +short example.com
getent hosts example.com
ping -c 3 8.8.8.8
traceroute google.com
```

**チェックポイント**
- [ ] プライベートアドレス (10/8, 172.16/12, 192.168/16) と well-known ports (22, 25, 53, 80, 443, 110, 143, 993, 995) を暗記
- [ ] `ss` と `netstat` の代表オプション (`-t`, `-u`, `-l`, `-n`, `-p`) を言える

---

## Week 12 — セキュリティ + 102 模擬試験 (110.1〜110.3)

**学ぶこと**
- ホストセキュリティ: `passwd`, `/etc/shadow`, sudo, `who`, `w`, `last`, `lastlog`, スーパーデーモン (`xinetd`/`systemd socket`), `nmap`
- ユーザセキュリティ: ulimit, `chage`, `nologin`, `lsof`, `fuser`
- 暗号化: SSH (鍵生成, `~/.ssh/config`, `ssh-agent`, `ssh-add`), GnuPG (`gpg`), SSL/TLS の概要

**Lab**
```bash
ssh-keygen -t ed25519 -C "lpic-lab"
cat ~/.ssh/id_ed25519.pub
sudo -l
last | head
who; w
sudo lsof -i :22
```

**最終チェック**
- [ ] 101 / 102 とも模擬試験で 70%+ をコンスタントに取れる
- [ ] チートシートを見ずに主要コマンドを書ける
- [ ] 受験予約 (オンライン or テストセンター)

---

## 学習リソース

**公式**
- LPI 公式試験範囲: <https://www.lpi.org/our-certifications/lpic-1-overview>
- 試験 101 オブジェクティブ: <https://www.lpi.org/our-certifications/exam-101-objectives>
- 試験 102 オブジェクティブ: <https://www.lpi.org/our-certifications/exam-102-objectives>

**書籍 (日本語)**
- Linux 教科書 LPICレベル1 スピードマスター問題集 (通称: 小豆本) — 試験対策の決定版
- Linux 教科書 LPIC レベル1 (通称: あずき本) — 体系的な知識習得向け

**Web**
- Ping-t (<https://ping-t.com>): 101 範囲は無料で問題が解ける
- LPI-Japan のサンプル問題

**受験のコツ**
- 試験は **5年間有効**。1年以内に 101 と 102 両方合格しないと失効
- ピアソンVUE のオンライン受験 (OnVUE) も可能
- 各試験 1.5 時間 / 60問 / 800点満点中 500点で合格 (約 65%)
