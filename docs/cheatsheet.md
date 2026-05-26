# LPIC-1 チートシート

試験 101 / 102 で頻出のコマンド・設定ファイル・オプション。手元に置いて使い、見ずに書けるようになるまで反復してください。

---

## 1. パッケージ管理

### Debian系 (apt / dpkg)

| 操作 | コマンド |
|------|---------|
| パッケージリスト更新 | `apt update` |
| インストール | `apt install <pkg>` |
| アンインストール | `apt remove <pkg>` (設定残す) / `apt purge <pkg>` (設定も削除) |
| アップグレード | `apt upgrade` / `apt full-upgrade` |
| 検索 | `apt search <keyword>` / `apt-cache search` |
| パッケージ情報 | `apt show <pkg>` / `apt-cache show` |
| インストール済み一覧 | `apt list --installed` / `dpkg -l` |
| パッケージ内ファイル一覧 | `dpkg -L <pkg>` |
| ファイル→パッケージ逆引き | `dpkg -S /path/to/file` |
| .deb を直接インストール | `dpkg -i pkg.deb` |
| 依存解決 | `apt -f install` |
| 設定ファイル | `/etc/apt/sources.list`, `/etc/apt/sources.list.d/*.list` |

### RPM系 (dnf / yum / rpm)

| 操作 | コマンド |
|------|---------|
| インストール | `dnf install <pkg>` (= `yum install`) |
| アンインストール | `dnf remove <pkg>` |
| アップデート | `dnf update` / `dnf upgrade` |
| 検索 | `dnf search <keyword>` |
| 情報 | `dnf info <pkg>` / `rpm -qi <pkg>` |
| インストール済み一覧 | `rpm -qa` |
| パッケージ内ファイル一覧 | `rpm -ql <pkg>` |
| ファイル→パッケージ逆引き | `rpm -qf /path/to/file` |
| 改変検知 | `rpm -V <pkg>` |
| .rpm を直接インストール | `rpm -ivh pkg.rpm` |
| 設定ファイル | `/etc/yum.repos.d/*.repo` |

---

## 2. ファイル/ディレクトリ操作

```
ls -la              全ファイル, 詳細
ls -lh              人間可読サイズ
ls -lt              更新時刻ソート
ls -lS              サイズソート
cp -r SRC DST       ディレクトリごと
cp -a SRC DST       属性保持してコピー (-dpR と等価)
mv SRC DST          移動 or リネーム
rm -rf DIR          再帰削除
mkdir -p a/b/c      親ディレクトリも作成
touch FILE          空ファイル作成 or タイムスタンプ更新
ln SRC HARD         ハードリンク
ln -s SRC SOFT      シンボリックリンク
stat FILE           inode/タイムスタンプ表示
file FILE           ファイル種別判定
```

### find

```
find /path -name "*.txt"            名前で検索
find / -type f -size +10M           10MB超のファイル
find / -mtime -7                    7日以内に変更
find / -user alice -group dev
find / -perm 4755                   SUID 付き 0755
find / -name "*.log" -exec rm {} \;
find / -name "*.log" | xargs rm
```

---

## 3. テキスト処理

```
cat / tac / head -n 5 / tail -n 5 / tail -f
wc -l (行数) / -w (語数) / -c (バイト数)
sort           標準ソート
sort -n        数値ソート
sort -r        降順
sort -k 2      2列目でソート
sort -u        重複除去
uniq -c        重複カウント (要 sort)
cut -d: -f1    : 区切りの 1 列目
cut -c 1-10    1〜10 文字目
paste a b      行ごとに結合
tr a-z A-Z     文字変換
tr -d ' '      削除
nl FILE        行番号付与
od -c FILE     8進ダンプ
split -l 100 FILE prefix
```

### sed (基本)

```
sed 's/old/new/'           各行 1回目を置換
sed 's/old/new/g'          全置換
sed -n '5p'                5行目だけ表示
sed '2,5d'                 2〜5行目削除
sed -i 's/x/y/g' FILE      ファイル直接書換
```

### grep / 正規表現

```
grep -i      大文字小文字無視
grep -v      マッチしない行
grep -n      行番号
grep -r      再帰
grep -E      拡張正規表現 (= egrep)
grep -F      固定文字列 (= fgrep)
grep -c      件数
grep -A 3 / -B 3 / -C 3   前後の行も
```

| BRE (基本) | ERE (拡張, `grep -E`) |
|-----------|----------------------|
| `*` 直前0回以上 | 同じ |
| `\+` 1回以上 | `+` |
| `\?` 0 or 1 回 | `?` |
| `\(grp\)` グループ | `(grp)` |
| `\|` または | `|` |

---

## 4. プロセス・ジョブ管理

```
ps           現在シェルのプロセス
ps -ef       全プロセス (BSD系: ps aux)
ps -ejH      ツリー
top / htop   リアルタイム
pgrep nginx  プロセスID検索
pkill nginx  名前で kill
kill -l      シグナル一覧
kill -9 PID  強制終了 (SIGKILL)
kill -15 PID デフォルト (SIGTERM)
killall -HUP rsyslog
nohup CMD &  ログアウトしても実行継続
disown %1    現在のジョブをシェルから切り離す
jobs / fg %1 / bg %1
nice -n 10 CMD       優先度を下げる
renice 10 -p PID     実行中プロセスの優先度変更
```

### シグナル番号 (覚える)

| 番号 | 名前 | 用途 |
|------|------|------|
| 1 | SIGHUP | 設定リロード |
| 2 | SIGINT | Ctrl-C |
| 9 | SIGKILL | 強制終了 (キャッチ不可) |
| 15 | SIGTERM | デフォルト終了 |
| 18 | SIGCONT | 再開 |
| 19 | SIGSTOP | 停止 (キャッチ不可) |
| 20 | SIGTSTP | Ctrl-Z |

---

## 5. パーミッション

```
chmod 755 FILE           rwxr-xr-x
chmod u+x,g-w FILE       シンボリック表記
chmod -R 755 DIR         再帰
chown user:group FILE
chown -R user:group DIR
umask 022                新規ファイル 644 / 新規ディレクトリ 755
umask 077                自分専用 600 / 700
```

| 数値 | 意味 |
|------|------|
| 4xxx | SUID (実行時にファイル所有者の権限で動く) |
| 2xxx | SGID (実行時にグループ所有者の権限で動く / ディレクトリの場合は新規ファイルが同じグループを引き継ぐ) |
| 1xxx | sticky bit (ディレクトリ内のファイルは所有者だけ削除可。/tmp で利用) |

```
chmod 4755 FILE   SUID
chmod 2755 FILE   SGID
chmod 1777 DIR    sticky (/tmp)
```

---

## 6. ファイルシステム / ディスク

```
fdisk -l                   パーティション一覧 (MBR)
gdisk /dev/sda             GPT 用
parted /dev/sda print
mkfs.ext4 /dev/sda1
mkfs.xfs /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2 / swapoff
fsck /dev/sda1             整合性チェック
tune2fs -l /dev/sda1       ext系のパラメータ表示
e2label /dev/sda1 MYLABEL  ext系ラベル
xfs_admin -L MYLABEL /dev/sda1
blkid                      UUID/ラベル一覧
df -h                      使用量
df -i                      inode 使用量
du -sh DIR                 ディレクトリサイズ
mount /dev/sda1 /mnt
mount -o remount,rw /
umount /mnt
```

### /etc/fstab (6 フィールド順)

```
<device>  <mount-point>  <type>  <options>  <dump>  <pass>
UUID=xxx  /              ext4    defaults   0       1
LABEL=sw  none           swap    sw         0       0
```

- options: `defaults`, `ro/rw`, `noexec`, `nosuid`, `nodev`, `noauto`, `user`, `users`, `async/sync`, `relatime`
- dump: 0=対象外, 1=対象
- pass: 0=fsck対象外, 1=ルート, 2=その他

---

## 7. ユーザ・グループ管理

```
useradd -m -s /bin/bash alice    # -m: ホーム作成, -s: シェル
usermod -aG sudo alice           # -aG で追加 (-a 必須!)
userdel -r alice                 # -r: ホームごと削除
groupadd dev
groupdel dev
passwd alice                     # パスワード変更
passwd -l alice                  # ロック
passwd -u alice                  # ロック解除
passwd -e alice                  # 次回ログインで変更要求
chage -l alice                   # パスワード期限表示
chage -M 90 alice                # 最大有効期限 90 日
chage -E 2026-12-31 alice        # アカウント失効日
id alice
who / w / last / lastlog
su - alice                       # ログインシェル
sudo -i / sudo -l                # 権限確認
```

### /etc/passwd の 7 フィールド

```
alice:x:1001:1001:Alice:/home/alice:/bin/bash
名前:パスワード(x=shadow):UID:GID:GECOS:ホーム:シェル
```

### /etc/shadow の 9 フィールド

```
名前:暗号化PW:最終変更日:最小変更日数:最大有効日数:警告日数:猶予日数:失効日:予約
```

---

## 8. ジョブスケジューリング

### cron 形式

```
# m  h  dom  mon  dow  command
  0  3  *    *    *    /usr/local/bin/backup.sh
  */5 *  *    *    *    date >> /tmp/cron.log
```

| フィールド | 範囲 |
|-----------|------|
| 分 | 0-59 |
| 時 | 0-23 |
| 日 | 1-31 |
| 月 | 1-12 (jan-dec) |
| 曜日 | 0-7 (0,7=日, sun-sat) |

```
crontab -e         自分用 cron 編集
crontab -l         一覧
crontab -r         削除
crontab -u alice   他ユーザの (rootのみ)
```

主要ファイル: `/etc/crontab`, `/etc/cron.d/`, `/etc/cron.{hourly,daily,weekly,monthly}/`, `/var/spool/cron/`

### at (1回限り)

```
echo "ls" | at 23:30 tomorrow
at -l       一覧
atrm 1      削除
```

### systemd timer (新)

```
systemctl list-timers
systemctl enable --now mytask.timer
```

---

## 9. ネットワーク

```
ip addr show        IP/インターフェース
ip link             リンク状態
ip route            ルーティング
ip route add default via 192.168.1.1
ss -tlnp            LISTEN中の TCP
ss -tnp             ESTABLISHED の TCP
ss -unlp            UDP LISTEN
ping -c 3 host
traceroute / tracepath / mtr
dig host / dig @8.8.8.8 host MX
host example.com
nslookup example.com
getent hosts example.com   /etc/nsswitch.conf 経由
nmcli device / nmcli con show / nmcli con up <name>
```

### 主要設定ファイル

```
/etc/hostname              ホスト名
/etc/hosts                 静的名前解決
/etc/resolv.conf           DNS リゾルバ
/etc/nsswitch.conf         名前解決の優先度
/etc/network/interfaces    Debian系の旧設定
/etc/sysconfig/network-scripts/   RHEL系の旧設定
/etc/NetworkManager/       NetworkManager
```

### プライベートアドレス & well-known ports

| クラス | 範囲 |
|--------|------|
| A | 10.0.0.0/8 |
| B | 172.16.0.0/12 |
| C | 192.168.0.0/16 |

| ポート | サービス |
|--------|---------|
| 20/21 | FTP |
| 22 | SSH |
| 23 | Telnet |
| 25 | SMTP |
| 53 | DNS |
| 67/68 | DHCP |
| 80 | HTTP |
| 110 | POP3 |
| 123 | NTP |
| 143 | IMAP |
| 161/162 | SNMP |
| 389 | LDAP |
| 443 | HTTPS |
| 465 | SMTPS |
| 514 | syslog |
| 587 | SMTP Submission |
| 636 | LDAPS |
| 993 | IMAPS |
| 995 | POP3S |

---

## 10. systemd / サービス管理

```
systemctl status SERVICE
systemctl start  / stop / restart / reload SERVICE
systemctl enable / disable SERVICE    自動起動
systemctl enable --now SERVICE
systemctl is-active / is-enabled
systemctl list-units --type=service
systemctl list-unit-files
systemctl list-dependencies
systemctl mask / unmask SERVICE
systemctl daemon-reload                ユニット定義の再読込
systemctl get-default / set-default multi-user.target
systemctl isolate rescue.target
systemctl reboot / poweroff / suspend / hibernate
```

ユニットファイル配置: `/etc/systemd/system/` (管理者用) > `/run/systemd/system/` > `/usr/lib/systemd/system/` (パッケージ提供)

### ランレベル ↔ systemd target

| Runlevel | Target |
|----------|--------|
| 0 | poweroff.target |
| 1 / S | rescue.target |
| 2 | multi-user.target |
| 3 | multi-user.target |
| 4 | multi-user.target |
| 5 | graphical.target |
| 6 | reboot.target |

---

## 11. ログ

### rsyslog

`/etc/rsyslog.conf` フォーマット:

```
facility.priority   action
auth,authpriv.*     /var/log/auth.log
*.info;mail.none    /var/log/messages
*.emerg             :omusrmsg:*
```

facility: `auth`, `authpriv`, `cron`, `daemon`, `kern`, `lpr`, `mail`, `news`, `syslog`, `user`, `uucp`, `local0`〜`local7`

priority (低→高): `debug`, `info`, `notice`, `warning`/`warn`, `err`/`error`, `crit`, `alert`, `emerg`/`panic`

### journalctl

```
journalctl                 全部
journalctl -u SERVICE      ユニット指定
journalctl -p err          優先度
journalctl -b              現ブート以降
journalctl -b -1           前のブート
journalctl --since "1 hour ago" --until "10 min ago"
journalctl -f              リアルタイム (tail -f相当)
journalctl --disk-usage
journalctl --vacuum-time=7d   7日より古いログ削除
```

### logrotate

`/etc/logrotate.conf`, `/etc/logrotate.d/`

```
/var/log/syslog {
    daily
    rotate 7
    compress
    missingok
    notifempty
    postrotate
        systemctl reload rsyslog
    endscript
}
```

---

## 12. SSH / セキュリティ

```
ssh user@host
ssh -i ~/.ssh/key user@host
ssh -p 2222 user@host
ssh -L 8080:localhost:80 user@host     ローカルポート転送
ssh -R 8080:localhost:80 user@host     リモートポート転送
scp file user@host:/path/
rsync -avz src/ user@host:/path/
ssh-keygen -t ed25519                  鍵生成
ssh-keygen -t rsa -b 4096
ssh-copy-id user@host                  公開鍵を相手に登録
ssh-add ~/.ssh/id_ed25519
ssh-add -l
```

### 主要ファイル

```
~/.ssh/config                 クライアント設定
~/.ssh/authorized_keys        受け入れる公開鍵
~/.ssh/known_hosts            既知ホストのフィンガープリント
/etc/ssh/sshd_config          サーバ設定
/etc/ssh/ssh_config           クライアント (システム全体)
```

### GPG

```
gpg --gen-key
gpg --list-keys / --list-secret-keys
gpg --export -a NAME > pub.asc
gpg --import pub.asc
gpg -c FILE                 対称暗号
gpg -e -r NAME FILE         公開鍵で暗号化
gpg -d FILE.gpg             復号
gpg --sign / --verify
```

---

## 13. シェル変数・スクリプト

```
export VAR=value          子プロセスに継承
unset VAR
set                       全変数表示
env                       環境変数のみ
echo $PATH
PATH=$PATH:/new/path
```

### bash の起動ファイル読み込み順 (ログインシェル)

1. `/etc/profile`
2. `~/.bash_profile` → なければ `~/.bash_login` → なければ `~/.profile`
3. `~/.bashrc` (通常 `~/.bash_profile` から source される)
4. ログアウト時: `~/.bash_logout`

### 非ログインシェル (新しいターミナルなど)

1. `/etc/bash.bashrc`
2. `~/.bashrc`

### スクリプト基本

```bash
#!/bin/bash
set -euo pipefail            # エラーで停止, 未定義変数禁止, パイプ失敗検知

NAME="${1:-default}"         # 引数1, 未指定なら default
COUNT=${#@}                  # 引数の数
ALL_ARGS="$@"

if [[ -f "$FILE" ]]; then    # ファイル存在
if [[ -d "$DIR"  ]]; then    # ディレクトリ
if [[ -z "$VAR"  ]]; then    # 空文字列
if [[ "$A" == "$B" ]]; then  # 文字列等価
if [[ "$N" -gt 0 ]]; then    # 数値比較

for f in *.txt; do echo "$f"; done
while read line; do echo "$line"; done < FILE
case "$x" in
  start) echo s ;;
  *)     echo other ;;
esac
```

特殊変数: `$0` (スクリプト名), `$1..$9` (引数), `$#` (引数数), `$@` `$*` (全引数), `$?` (直前終了コード), `$$` (PID), `$!` (バックグラウンドジョブの PID)

---

## 14. リダイレクト

| 記法 | 意味 |
|------|------|
| `>` | 標準出力をファイルに (上書き) |
| `>>` | 標準出力をファイルに (追記) |
| `2>` | 標準エラーをファイルに |
| `2>>` | 標準エラーを追記 |
| `&>` `>&` | 標準出力とエラーをまとめて |
| `2>&1` | 標準エラーを標準出力に統合 |
| `<` | 標準入力をファイルから |
| `<<EOF ... EOF` | ヒアドキュメント |
| `<<<` | ヒアストリング |
| `|` | パイプ |
| `\|&` | パイプ + stderr 統合 |
| `tee` | 標準出力を分岐 (画面 + ファイル) |
| `tee -a` | 追記モード |

ファイルディスクリプタ: 0=stdin, 1=stdout, 2=stderr

---

## 15. vi/vim 基本

| キー | 動作 |
|------|------|
| `i` `a` `o` | 挿入 (カーソル位置/後ろ/下の行) |
| `Esc` | ノーマルモード |
| `:w` | 保存 |
| `:q` | 終了 |
| `:wq` `ZZ` | 保存して終了 |
| `:q!` | 保存せず終了 |
| `dd` | 1行削除 |
| `yy` | 1行ヤンク (コピー) |
| `p` `P` | ペースト (下/上) |
| `u` | 元に戻す |
| `Ctrl-r` | やり直し |
| `/word` | 前方検索 |
| `?word` | 後方検索 |
| `n` `N` | 次/前のマッチ |
| `:%s/old/new/g` | 全置換 |
| `:set number` | 行番号表示 |
| `gg` `G` | 先頭/末尾 |

---

## 16. アーカイブ・圧縮

```
tar cvf out.tar  DIR/          作成
tar xvf  in.tar                展開
tar tvf  in.tar                内容確認
tar czvf out.tar.gz  DIR/      gzip
tar cjvf out.tar.bz2 DIR/      bzip2
tar cJvf out.tar.xz  DIR/      xz
tar -C /target -xf in.tar      展開先指定

gzip / gunzip / zcat FILE
bzip2 / bunzip2 / bzcat
xz / unxz / xzcat
zip / unzip
cpio -ivd < archive.cpio
```

| 拡張子 | 圧縮率 | 速度 |
|--------|--------|------|
| .gz | 中 | 速い |
| .bz2 | 高 | 遅い |
| .xz | 最高 | 最遅 |

---

## 17. ロケール・時刻

```
locale                     現在のロケール
locale -a                  利用可能なロケール
LC_ALL=C ls -la            一時的にロケール変更
timedatectl                時刻設定の状態表示
timedatectl set-timezone Asia/Tokyo
timedatectl set-ntp true
date '+%Y-%m-%d %H:%M:%S'
hwclock --show / --systohc / --hctosys
tzselect                   対話的に TZ 選択
iconv -f SJIS -t UTF-8 in > out
```

主要変数: `LANG`, `LC_ALL`, `LC_CTYPE`, `LC_TIME`, `LC_NUMERIC`, `LC_COLLATE`, `LC_MESSAGES`, `TZ`

優先順位: `LC_ALL` > `LC_*` > `LANG`

---

## 18. デバイス・カーネル情報

```
lspci                  PCI デバイス
lsusb                  USB
lsmod                  ロード済みカーネルモジュール
modprobe MODULE        モジュール読込
modprobe -r MODULE     アンロード
modinfo MODULE         情報
dmesg                  カーネルメッセージ
dmesg -T               人間可読タイムスタンプ
uname -a               カーネル情報
uname -r               カーネルバージョン
free -h                メモリ
vmstat 1 5             メモリ/CPU 統計
iostat / sar           I/O 統計 (要 sysstat)
uptime                 ロードアベレージ
```

主要 `/proc` / `/sys` エントリ:

```
/proc/cpuinfo           CPU
/proc/meminfo           メモリ
/proc/version           カーネル
/proc/mounts            マウント一覧
/proc/<PID>/            プロセス毎の情報
/sys/class/net/         ネットワークデバイス
/sys/block/             ブロックデバイス
```
