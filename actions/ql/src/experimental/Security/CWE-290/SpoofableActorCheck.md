## Overview

Many workflows use `github.actor` or `github.triggering_actor` to check if a specific bot (such as Dependabot or Renovate) triggered the workflow, and then bypass security checks or perform privileged actions. However, `github.actor` refers to the last actor to perform an "action" on the triggering context, not necessarily the actor that actually caused the trigger.

An attacker can exploit this by creating a pull request where the HEAD commit has `github.actor == 'dependabot[bot]'` but the rest of the branch history contains attacker-controlled code, bypassing the actor check.

## Recommendation

Instead of checking `github.actor`, use a context that refers to the actor who created the triggering event. For `pull_request_target` workflows, use `github.event.pull_request.user.login`. For `issue_comment` workflows, use `github.event.comment.user.login`.

More generally, consider whether a bot-bypass check is the right approach. GitHub's documentation recommends not using `pull_request_target` for auto-merge workflows.

## Example

### Incorrect Usage

```yaml
on: pull_request_target

jobs:
  automerge:
    runs-on: ubuntu-latest
    if: github.actor == 'dependabot[bot]'
    steps:
      - run: gh pr merge --auto --merge "$PR_URL"
        env:
          PR_URL: ${{ github.event.pull_request.html_url }}
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### Correct Usage

```yaml
on: pull_request_target

jobs:
  automerge:
    runs-on: ubuntu-latest
    if: github.event.pull_request.user.login == 'dependabot[bot]'
    steps:
      - run: gh pr merge --auto --merge "$PR_URL"
        env:
          PR_URL: ${{ github.event.pull_request.html_url }}
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## References

- Synacktiv: [GitHub Actions exploitations: Dependabot](https://www.synacktiv.com/publications/github-actions-exploitation-dependabot).
- GitHub Docs: [Automating Dependabot with GitHub Actions](https://docs.github.com/en/code-security/dependabot/working-with-dependabot/automating-dependabot-with-github-actions).
- Zizmor: [bot-conditions](https://docs.zizmor.sh/audits/#bot-conditions).
