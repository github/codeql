## Overview

If a GitHub Actions job or workflow has no explicit permissions set, then the repository permissions are used. Repositories created under organizations inherit the organization permissions. The organizations or repositories created before February 2023 have the default permissions set to read-write. Often these permissions do not adhere to the principle of least privilege and can be reduced to read-only, leaving the `write` permission only to a specific types as `issues: write` or `pull-requests: write`.

Note that this query cannot check whether the organization or repository token settings are set to read-only. However, even if they are, it is recommended to define explicit permissions (`contents: read` and `packages: read` are equivalent to the read-only default) so that (a) the actual needs of the workflow are documented, and (b) the permissions will remain restricted if the default is subsequently changed, or the workflow is copied to a different repository or organization.

## Recommendation

Add the `permissions` key to the job or the root of workflow (in this case it is applied to all jobs in the workflow that do not have their own `permissions` key) and assign the least privileges required to complete the task.

## Example

### Incorrect Usage

```yaml
name: "My workflow"
# No permissions block
```

### Correct Usage

```yaml
name: "My workflow"
permissions:
  contents: read
  pull-requests: write
```

or

```yaml
jobs:
  my-job:
    permissions:
      contents: read
      pull-requests: write
```

## References

- GitHub Docs: [Assigning permissions to jobs](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/assigning-permissions-to-jobs).
