## Overview

GitHub Actions cache poisoning is a technique that allows an attacker to inject malicious content into the Action's cache from unprivileged workflow, potentially leading to code execution in privileged workflows.

An attacker with the ability to run code in the context of the default branch (e.g. through Code Injection or Execution of Untrusted Code) can exploit this to:

1. Steal the cache access token and URL.
2. Overflow the cache to trigger eviction of legitimate entries.
3. Poison cache entries with malicious payloads.
4. Achieve code execution in privileged workflows that restore the poisoned cache.

This allows lateral movement from low-privileged to high-privileged workflows within a repository.

### Cache Structure

In GitHub Actions, cache scopes are primarily determined by the branch structure. Branches are considered the main security boundary for GitHub Actions caching. This means that cache entries are generally scoped to specific branches.

- **Access to Parent Branch Caches**: Feature branches (or child branches) created off of a parent branch (like `main` or `dev`) can access caches from the parent branch. For instance, a feature branch off of `main` will be able to access the cache from `main`.

- **Sibling Branches**: Sibling branches, meaning branches that are created from the same parent but not from each other, do not share caches. For example, two branches created off of `main` will not be able to access each other’s caches directly.

Due to the above design, if something is cached in the context of the default branch (e.g., `main`), it becomes accessible to any feature branch derived from `main`.

## Recommendation

1. Avoid using caching in workflows that handle sensitive operations like releases.
2. If caching must be used:
   - Validate restored cache contents before use.
   - Use short-lived, workflow-specific cache keys.
   - Clear caches regularly.
3. Implement strict isolation between untrusted and privileged workflow execution.
4. Never run untrusted code in the context of the default branch.
5. Sign the cache value cryptographically and verify the signature before usage.

## Example

GitHub gives workflows triggered by low-trust events, such as `issue_comment`,
`pull_request_target`, and `workflow_run`, read-only access to the default branch cache scope.
This query therefore reports only workflows whose trigger can write to that scope.

### Incorrect Usage

The following workflow interpolates a commit message directly into a script on a push to the
default branch. A commit message originating from a merged contribution may contain shell syntax,
which can expose the cache write token and allow the default branch cache to be poisoned.

```yaml
name: Vulnerable Workflow
on:
  push:
    branches: [main]

jobs:
  build:
    permissions: {}
    runs-on: ubuntu-latest
    steps:
      - run: |
          echo ${{ github.event.head_commit.message }}
```

### Correct Usage

The following workflow passes the commit message through an environment variable, so the shell
does not interpret its contents as code.

```yaml
name: Secure Workflow
on:
  push:
    branches: [main]

jobs:
  build:
    permissions: {}
    runs-on: ubuntu-latest
    steps:
      - env:
          MESSAGE: ${{ github.event.head_commit.message }}
        run: |
          echo "$MESSAGE"
```

## References

- Adnan Khan's Blog: [The Monsters in Your Build Cache – GitHub Actions Cache Poisoning](https://adnanthekhan.com/2024/05/06/the-monsters-in-your-build-cache-github-actions-cache-poisoning/).
- GitHub Docs: [Cache access for low-trust workflow triggers](https://docs.github.com/actions/reference/workflows-and-actions/dependency-caching#cache-access-for-low-trust-workflow-triggers).
- Scribe Security Blog: [Cache Poisoning in GitHub Actions](https://scribesecurity.com/blog/github-cache-poisoning/).
