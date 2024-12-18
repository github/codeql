# Untrusted Checkout TOCTOU (Time-of-check to time-of-use)

## Description

Untrusted Checkout is protected by a security check but the checked-out branch can be changed after the check.

## Recommendations

Verify that the code has not been modified after the security check. This may be achieved differently depending on the type of check:

- Deployment Environment Approval: Make sure to use a non-mutable reference to the code to be executed. For example use a `sha` instead of a `ref`.
- Label Gates: Make sure to use a non-mutable reference to the code to be executed. For example use a `sha` instead of a `ref`.

## Examples

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

Use immutable references (Commit SHA) to make sure that the reviewed code does not change between the check and the use.

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

Use immutable references (Commit SHA) to make sure that the reviewed code does not change between the check and the use.

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
