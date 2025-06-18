# アプリケーション名

reservation-app

---

## アプリケーション概要

このアプリケーションでは、ユーザーがWeb上でGoogleMeetの予約を行うことができます。

- カレンダーから空き状況を確認
- ユーザー登録／ログイン／ユーザー情報編集/ログアウト
- 予約の作成／確認／キャンセル
- 管理者による予約管理機能

---

## URL

https://reservation-app-4t4o.onrender.com

---

## テスト用アカウント

- Basic認証ID：`admin`  
- Basic認証パスワード：`2222`

### テストユーザー

- メールアドレス：`tech@furima.com`  
- パスワード：`123abc`

### 管理者ユーザー

- メールアドレス：`admin@kannri.com`  
- パスワード：`123abc`

---

## 💡 利用方法

1. ユーザー登録 or ログイン
2. カレンダー画面で予約可能日時を確認
3. 予約を選択して確定
4. マイページから予約の確認・キャンセルが可能

---

## アプリケーションを作成した背景

予約制のサービスを手軽に管理・利用でき、GoogleMeetでやり取りできることを目標に開発しました。  
管理者側も利用者側も、Web上で簡単に予約の作成・確認ができることを目指しています。

---

## 実装機能とその画像・GIF

- 新規登録       https://gyazo.com/72cc8b9b117aa3d054674a47317f8e02
- ログイン       https://gyazo.com/862bd2ca2d912ba5c1de1a206272a7b6
- アカウント編集  https://gyazo.com/fffbc71a87c733cd84e3536a1b04cc54
- 予約作成       https://gyazo.com/e6959b0e86eb61856977644408eebb3f
- ヘッダーの遷移  https://gyazo.com/c79feace80b8dda095d8298dbad97a19
- GoogleMeet    https://gyazo.com/5807c274c305ade2c2e1fe4defebe7c9
- 管理者画面     https://gyazo.com/f071b0f00c7543dfd3d75dc06830f9f9
- 予約削除       https://gyazo.com/9cf82ac08129a110e8773eff9db5f056
- ログアウト     https://gyazo.com/df30b768e1191030e7e0d75735c6065e
- アカウント削除  https://gyazo.com/de39d0cc417e874defcd2dbf97f42770

---

## 今後の実装予定

- 予約一覧削除、GoogleMeetのリンク、ログアウトを本番環境でも使えるように
- 予約リマインド通知
- チャットシステム
- 管理者側のユーザーの管理機能

---

## データベース設計

![ER図]https://gyazo.com/e0941b3f2ba8bd3ebd33d89a0ed01a6b

---

## 画面遷移図

![画面遷移図]https://gyazo.com/125d9df2e9df22300d922c9d6d9afa31

---

## 開発環境

- フロントエンド：HTML / CSS / JavaScript
- バックエンド：Ruby on Rails 7.1.5.1
- データベース：MySQL（開発・テスト） / PostgreSQL（本番）
- 認証：Devise

---

## ローカルでの動作方法

```bash
# リポジトリをクローン
git clone https://github.com/41728/reservation_app.git

# ディレクトリに移動
cd reservation-app

# パッケージをインストール
bundle install

# データベース作成・マイグレーション
rails db:create
rails db:migrate

# サーバー起動
rails s