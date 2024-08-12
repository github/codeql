# Execution of Untrusted Checked-out Code

## Description

GitHub workflows can be triggered through various repository events, including incoming pull requests (PRs) or comments on Issues/PRs. A potentially dangerous misuse of the triggers such as `pull_request_target` or `issue_comment` followed by an explicit checkout of untrusted code (Pull Request HEAD) may lead to repository compromise if untrusted code gets executed in a privileged job.

## Recommendations

- Avoid using `pull_request_target` unless necessary.
- Employ unprivileged `pull_request` workflows followed by `workflow_run` for privileged operations.
- Use labels like `safe to test` to vet PRs and manage the execution context appropriately.

The best practice is to handle the potentially untrusted pull request via the **pull_request** trigger so that it is isolated in an unprivileged environment. The workflow processing the pull request should then store any results like code coverage or failed/passed tests in artifacts and exit. A second privileged workflow with the access to repository secrets, triggered by the completion of the first workflow using `workflow_run` trigger event, downloads the artifacts and make any necessary modifications to the repository or interact with third party services that require repository secrets (e.g. API tokens).

The artifacts downloaded from the first workflow should be considered untrusted and must be verified.

## Examples

### Incorrect Usage

The following workflow checks-out untrusted code in a privileged context and runs user-controlled code (in this case package.json scripts) which will grant privileged access to the attacker:

```yaml
on: pull_request_target

jobs:
  build:
    name: Build and test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
        with:
          ref: ${{ github.event.pull_request.head.sha }}

      - uses: actions/setup-node@v1
      - run: |
          npm install
          npm build

      - uses: completely/fakeaction@v2
        with:
          arg1: ${{ secrets.supersecret }}

      - uses: fakerepo/comment-on-pr@v1
        with:
          message: |
            Thank you!
```

### Correct Usage

An example shows how to use two workflows: one for processing the untrusted PR and the other for using the results in a safe context.

**ReceivePR.yml** (untrusted PR handling with artifact creation):

```yaml
name: Receive PR
on:
  pull_request:
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Build
        run: /bin/bash ./build.sh
      - name: Save PR number
        run: |
          mkdir -p ./pr
          echo ${{ github.event.number }} > ./pr/NR
      - uses: actions/upload-artifact@v2
        with:
          name: pr
          path: pr/
```

**CommentPR.yml** (processing artifacts with privileged access):

```yaml
name: Comment on the pull request
on:
  workflow_run:
    workflows: ["Receive PR"]
    types:
      - completed
jobs:
  upload:
    runs-on: ubuntu-latest
    if: >
      github.event.workflow_run.event == 'pull_request' &&
      github.event.workflow_run.conclusion == 'success'
    steps:
      - name: "Download artifact"
        uses: actions/github-script@v3.1.0
        with:
          script: |
            var artifacts = await github.actions.listWorkflowRunArtifacts({
                owner: context.repo.owner,
                repo: context.repo.repo,
                run_id: ${{github.event.workflow_run.id }},
            });
            var matchArtifact = artifacts.data.artifacts.filter((artifact) => {
              return artifact.name == "pr";
            })[0];
            var download = await github.actions.downloadArtifact({
                owner: context.repo.owner,
                repo: context.repo.repo,
                artifact_id: matchArtifact.id,
                archive_format: 'zip',
            });
            var fs = require('fs');
            fs.writeFileSync('${{github.workspace}}/pr.zip', Buffer.from(download.data));
      - run: |
          mkdir -p tmp
          unzip -d tmp/ pr.zip
      - name: "Comment on PR"
        uses: actions/github-script@v3
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          script: |
            var fs = require('fs');
            var issue_number = Number(fs.readFileSync('./tmp/NR'));
            // Verify that the file contains a numeric value
            const contains_numeric = /\d/.test(issue_number);
            if (contains_numeric) {
                await github.issues.createComment({
                  owner: context.repo.owner,
                  repo: context.repo.repo,
                  issue_number: issue_number,
                  body: 'Everything is OK. Thank you for the PR!'
                });
            }
```

## References

- [Keeping your GitHub Actions and workflows secure Part 1: Preventing pwn requests](https://securitylab.github.com/research/github-actions-preventing-pwn-requests/)
