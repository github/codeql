# Cache Poisoning in GitHub Actions

## Description

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

## Recommendations

1. Avoid using caching in workflows that handle sensitive operations like releases.
2. If caching must be used:
   - Validate restored cache contents before use.
   - Use short-lived, workflow-specific cache keys.
   - Clear caches regularly.
3. Implement strict isolation between untrusted and privileged workflow execution.
4. Never run untrusted code in the context of the default branch.
5. Sign the cache value cryptographically and verify the signature before usage.

## Examples

### Incorrect Usage

The following workflow is caching an attacker-controlled file (`large_file`) in the context of the default branch.

```yaml
name: Vulnerable Workflow
on:
  issue_comment:
    types: [created]

jobs:
  pr-comment:
    permissions: read-all
    runs-on: ubuntu-latest
    steps:
      - uses: xt0rted/pull-request-comment-branch@v2
        id: comment-branch
      - uses: actions/checkout@v3
        with:
          ref: ${{ steps.comment-branch.outputs.head_sha }}
      - name: Set up Python 3.10
        uses: actions/setup-python@v5
      - name: Cache pip dependencies
        uses: actions/cache@v4
        id: cache-pip
        with:
          path: ~/.cache/pip
          key: ${{ runner.os }}-pip-${{ hashFiles('**/pyproject.toml') }}
          restore-keys: ${{ runner.os }}-pip-
```

### Correct Usage

The following workflow checking out untrusted files, but the cache is scoped to the Pull Request.

```yaml
name: Secure Workflow
on:
  pull_request:

jobs:
  pr-comment:
    permissions: read-all
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Set up Python 3.10
        uses: actions/setup-python@v5
      - name: Cache pip dependencies
        uses: actions/cache@v4
        id: cache-pip
        with:
          path: ~/.cache/pip
          key: ${{ runner.os }}-pip-${{ hashFiles('**/pyproject.toml') }}
          restore-keys: ${{ runner.os }}-pip-
```

Note, that the example above doesn't allow using secrets if the Pull Request originates from a fork. In case secrets are needed, `pull_request_target` with labels as `safe to test` can be used, but the code in Pull Request must be manually reviewed before applying the label.

```yaml
name: Secure Workflow
on:
  pull_request_target:
    types: [labeled]

jobs:
  pr-comment:
    if: contains(github.event.pull_request.labels.*.name, 'safe to test')
    permissions: read-all
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          ref: ${{ github.event.pull_request.head.sha}}
      - name: Set up Python 3.10
        uses: actions/setup-python@v5
      - name: Cache pip dependencies
        uses: actions/cache@v4
        id: cache-pip
        with:
          path: ~/.cache/pip
          key: ${{ runner.os }}-pip-${{ hashFiles('**/pyproject.toml') }}
          restore-keys: ${{ runner.os }}-pip-
```

## References

- [The Monsters in Your Build Cache – GitHub Actions Cache Poisoning](https://adnanthekhan.com/2024/05/06/the-monsters-in-your-build-cache-github-actions-cache-poisoning/)
- [GitHub Actions Caching Documentation](https://docs.github.com/en/actions/using-workflows/caching-dependencies-to-speed-up-workflows)
- [Cache Poisoning in GitHub Actions](https://scribesecurity.com/blog/github-cache-poisoning/)
