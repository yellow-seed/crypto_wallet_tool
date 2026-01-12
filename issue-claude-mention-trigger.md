# [TODO] Claude Code Reviewを@claudeメンションでトリガーするように変更

## 概要

現在、`.github/workflows/claude-code-review.yml`はPR作成時(`opened`)とコミット追加時(`synchronize`)に自動的にレビューを開始していますが、これをPR中に`@claude`メンションされたときのみレビューするように変更する必要があります。

## 目的

- 不要なレビュー実行を減らし、必要なときだけClaudeのレビューを受けられるようにする
- CI/CDリソース(APIコール、実行時間等)を効率的に使用する
- レビュー依頼のタイミングをPR作成者がコントロールできるようにする

## 実装内容・タスク

- [ ] ワークフローのトリガーを`pull_request`から`issue_comment`イベントに変更
- [ ] コメントがPRに対するものであることを確認する条件を追加(`github.event.issue.pull_request`の存在確認)
- [ ] コメント本文に`@claude`が含まれることを確認する条件を追加(`contains(github.event.comment.body, '@claude')`)
- [ ] PRの正しいブランチ・コミットをチェックアウトできるように修正
- [ ] 動作確認(実際にPRで`@claude`メンションしてテスト)
- [ ] 必要に応じてREADMEやドキュメントを更新

## 参考情報

- 現在の実装: `.github/workflows/claude-code-review.yml`
- GitHub Actionsの`issue_comment`イベント: https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#issue_comment
- `issue_comment`イベントはIssueとPRの両方のコメントでトリガーされる
- PRのHEADをチェックアウトするには、PRの情報をAPIから取得する必要がある

## 追加情報

### 主な変更箇所

#### 1. トリガーの変更

```yaml
# 変更前
on:
  pull_request:
    types: [opened, synchronize]

# 変更後
on:
  issue_comment:
    types: [created]
```

#### 2. ジョブ実行条件の追加

```yaml
jobs:
  claude-review:
    runs-on: ubuntu-latest
    # PRへのコメントで、@claudeメンションが含まれる場合のみ実行
    if: |
      github.event.issue.pull_request &&
      contains(github.event.comment.body, '@claude')
```

#### 3. チェックアウトの変更

`issue_comment`イベントではPRのブランチ情報が直接取得できないため、以下のような対応が必要:

- GitHub APIを使用してPRの情報を取得
- `actions/checkout`でPRのHEADブランチをチェックアウト
- または、`gh pr checkout`コマンドを使用

```yaml
- name: Get PR information
  id: pr
  run: |
    PR_NUMBER=${{ github.event.issue.number }}
    PR_DATA=$(gh pr view $PR_NUMBER --json headRefName,headRepository)
    echo "head_ref=$(echo $PR_DATA | jq -r .headRefName)" >> $GITHUB_OUTPUT

- name: Checkout PR branch
  uses: actions/checkout@v6
  with:
    ref: ${{ steps.pr.outputs.head_ref }}
    fetch-depth: 0
```

### セキュリティ上の考慮事項

- `issue_comment`イベントは外部ユーザーのコメントでもトリガーされるため、必要に応じてコメント作成者の権限確認を追加することを検討
- 例: `github.event.comment.author_association`をチェックして、`OWNER`、`MEMBER`、`COLLABORATOR`のみ許可

```yaml
if: |
  github.event.issue.pull_request &&
  contains(github.event.comment.body, '@claude') &&
  (github.event.comment.author_association == 'OWNER' ||
   github.event.comment.author_association == 'MEMBER' ||
   github.event.comment.author_association == 'COLLABORATOR')
```

### 使用方法(変更後)

PRのコメント欄で以下のようにメンションすることでレビューがトリガーされます:

```
@claude このPRをレビューしてください
```

または

```
レビュー依頼
@claude
```
