# Improper Access Control

## Description

Sometimes labels are used to approve GitHub Actions. An authorization check may not be properly implemented, allowing an attacker to mutate the code after it has been reviewed and approved by label.

## Recommendations

When using labels, make sure that the code cannot be modified after it has been reviewed and the label has been set.

## Examples

### Incorrect Usage

The following example shows a job that requires the label `safe to test` to be set before running untrusted code. There are two problems with the code:

1. The workflow gets triggered on `synchronize` activity type and, therefore, it will get triggered every time there is a change in the Pull Request. An attacker can modify the code of the Pull Request after the code has been reviewed and the label has been set. The workflow will be triggered every time a new change is added to the Pull Request.
2. The workflow uses `ref: ${{ github.event.pull_request.head.ref }}` for checkout, which is a branch name of the Pull Request. There is a window of opportunity for the attacker to modify their branch after the Pull Request is labeled, but before the workflow starts and runs the checkout.

```yaml
on:
  pull_request_target:
    types: [opened, synchronize]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repo for OWNER TEST
        uses: actions/checkout@v3
        if: contains(github.event.pull_request.labels.*.name, 'safe to test')
        with:
          ref: ${{ github.event.pull_request.head.ref }}
      - run: ./cmd
```

### Correct Usage

Make sure that the workflow only gets triggered when the label is set and use an immutable commit (`github.event.pull_request.head.sha`) instead of a mutable reference.

```yaml
on:
  pull_request_target:
    types: [labeled]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repo for OWNER TEST
        uses: actions/checkout@v3
        if: contains(github.event.pull_request.labels.*.name, 'safe to test')
        with:
          ref: ${{ github.event.pull_request.head.sha}}
      - run: ./cmd
```

## References

- [Events that trigger workflows](https://docs.github.com/en/actions/writing-workflows/choosing-when-your-workflow-runs/events-that-trigger-workflows#pull_request_target)
