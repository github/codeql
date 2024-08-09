# Actions Job and Workflow Permissions are not set

## Description

A GitHub Actions job or workflow hasn't set explicit permissions to restrict privileges to the workflow job.
A workflow job by default without the `permissions` key or a root workflow `permissions` will run with the default permissions defined at the repository level. For organizations created before February 2023, including many significant OSS projects and corporations, the default permissions grant read-write access to repositories, and new repositories inherit these old, insecure permissions.

## Recommendations

Add the `permissions` key to the job or workflow (applied to all jobs) and set the permissions to the least privilege required to complete the task:

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

- [Assigning permissions to jobs](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/assigning-permissions-to-jobs)
