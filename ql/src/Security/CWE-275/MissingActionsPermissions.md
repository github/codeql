# Actions Job and Workflow Permissions are not set

A GitHub Actions job or workflow hasn't set permissions to restrict privileges to the workflow job.
A workflow job by default without the `permissions` key or a root workflow `permissions` will run with all the permissions which can be given to a workflow.

## Recommendation

Add the `permissions` key to the job or workflow (applied to all jobs) and set the permissions to the least privilege required to complete the task:

```yaml
name: "My workflow"
permissions:
  contents: read
  pull-requests: write

# or
jobs:
  my-job:
    permissions:
      contents: read
      pull-requests: write
```
