# Untrusted Checkout TOCTOU

## Description

Untrusted Checkout is protected by a security check but the checked-out branch can be changed after the check.

## Recommendations

Verify that the code has not been modified after the security check. This may be achieved differently depending on the type of check:

- Issue Ops: Verify that Commit containing the code to be executed was commited **before** then date the of the comment.
- Deployment Environment Approval: Make sure to use a non-mutable reference to the code to be executed. For example use a `sha` instead of a `ref`.
- Label Gates: Make sure to use a non-mutable reference to the code to be executed. For example use a `sha` instead of a `ref`.

## Examples

### Incorrect Usage (Issue Ops)

The following workflow runs untrusted code after either a member or admin of the repository comments on a Pull Request with the text `/run-tests`. Although it may seem secure, the workflow is checking out a mutable reference (`${{ steps.comment-branch.outputs.head_ref }}`) and therefore the code can be mutated between the time of check (TOC) and the time of use (TOU).

```yaml
name: Comment Triggered Test
on:
  issue_comment:
    types: [created]
jobs:
  benchmark:
    name: Integration Tests
    if: ${{ github.event.issue.pull_request && contains(fromJson('["MEMBER", "OWNER"]'), github.event.comment.author_association) && startsWith(github.event.comment.body, '/run-tests ') }}
    permissions: "write-all"
    runs-on: [ubuntu-latest]
    steps:
      - name: Get PR branch
        uses: xt0rted/pull-request-comment-branch@v2
        id: comment-branch
      - name: Checkout PR branch
        uses: actions/checkout@v3
        with:
          ref: ${{ steps.comment-branch.outputs.head_ref }}
      - run: ./cmd
```

### Correct Usage (Issue Ops)

In the following example, the workflow checks if the latest commit of the Pull Request head was commited **before** the comment on the Pull Request, therefore ensuring that it was not mutated after the check.

```yaml
name: Comment Triggered Test
on:
  issue_comment:
    types: [created]
jobs:
  benchmark:
    name: Integration Tests
    if: ${{ github.event.issue.pull_request && contains(fromJson('["MEMBER", "OWNER"]'), github.event.comment.author_association) && startsWith(github.event.comment.body, '/run-tests ') }}
    permissions: "write-all"
    runs-on: [ubuntu-latest]
    steps:
      - name: Get PR Info
        id: pr
        env:
          PR_NUMBER: ${{ github.event.issue.number }}
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          GH_REPO: ${{ github.repository }}
          COMMENT_AT: ${{ github.event.comment.created_at }}
        run: |
          pr="$(gh api /repos/${GH_REPO}/pulls/${PR_NUMBER})"
          head_sha="$(echo "$pr" | jq -r .head.sha)"
          pushed_at="$(echo "$pr" | jq -r .pushed_at)"
          if [[ $(date -d "$pushed_at" +%s) -gt $(date -d "$COMMENT_AT" +%s) ]]; then
              echo "Updating is not allowed because the PR was pushed to (at $pushed_at) after the triggering comment was issued (at $COMMENT_AT)"
              exit 1
          fi
          echo "head_sha=$head_sha" >> $GITHUB_OUTPUT
      - name: Checkout PR branch
        uses: actions/checkout@v3
        with:
          ref: ${{ steps.pr.outputs.head_sha }}
      - run: ./cmd
```

### Incorrect Usage (Deployment Environment Approval)

The following workflow uses a Deployment Environment which may be configured to require an approval. However, it check outs the code pointed to by the Pull Request branch reference. At attacker could submit legitimate code for review and then change it once it gets approved.

```yml
on:
  pull_request_target:
    types: [Created]
jobs:
  test:
    environment: NeedsApproval
    runs-on: ubuntu-latest
    steps:
      - name: Checkout from PR branch
        uses: actions/checkout@v4
        with:
          repository: ${{ github.event.pull_request.head.repo.full_name }}
          ref: ${{ github.event.pull_request.head.ref }}
      - run: ./cmd
```

### Correct Usage (Deployment Environment Approval)

Use inmutable references (Commit SHA) to make sure that the reviewd code does not change between the check and the use.

```yml
on:
  pull_request_target:
    types: [Created]
jobs:
  test:
    environment: NeedsApproval
    runs-on: ubuntu-latest
    steps:
      - name: Checkout from PR branch
        uses: actions/checkout@v4
        with:
          repository: ${{ github.event.pull_request.head.repo.full_name }}
          ref: ${{ github.event.pull_request.head.sha }}
      - run: ./cmd
```

### Incorrect Usage (Label Gates)

The following workflow uses a Deployment Environment which may be configured to require an approval. However, it check outs the code pointed to by the Pull Request branch reference. At attacker could submit legitimate code for review and then change it once it gets approved.

```yaml
on:
  pull_request_target:
    types: [labeled]

jobs:
  test:
    runs-on: ubuntu-latest
    if: contains(github.event.pull_request.labels.*.name, 'safe-to-test')
    steps:
      - uses: actions/checkout@v4
        with:
          ref: ${{ github.event.pull_request.head.ref }}
          repository: ${{ github.event.pull_request.head.repo.full_name }}
      - run: ./cmd
```

### Correct Usage (Label Gates)

Use inmutable references (Commit SHA) to make sure that the reviewd code does not change between the check and the use.

```yaml
on:
  pull_request_target:
    types: [labeled]

jobs:
  test:
    runs-on: ubuntu-latest
    if: contains(github.event.pull_request.labels.*.name, 'safe-to-test')
    steps:
      - uses: actions/checkout@v4
        with:
          ref: ${{ github.event.pull_request.head.sha }}
          repository: ${{ github.event.pull_request.head.repo.full_name }}
      - run: ./cmd
```

## References

- [ActionsTOCTOU](https://github.com/AdnaneKhan/ActionsTOCTOU)
