## Overview

GitHub workflows can be triggered through various repository events, including incoming pull requests (PRs) or comments on Issues/PRs. Under certain conditions described below, attackers can take over a repository by opening malicious PRs from forks. The attacks can result in malicious code execution causing unauthorized changes to the repository or exfiltration of repository secrets and a compromise of connected systems.

## Workflow Security Model

In GitHub Actions, there is a distinction between unprivileged and privileged workflows. For example, a workflow with a `pull_request` trigger is unprivileged while a workflow with `pull_request_target` is privileged.

This is relevant especially for PRs from forks. Normal PRs can only be submitted by people who have write access to a repository, while PRs from forks can be submitted by anyone.

On a PR from a fork, an unprivileged `pull_request` workflow has only limited capabilities but a privileged `pull_request_target` workflow is much more dangerous. A privileged workflow:

  * Runs in the context of the base repository
  * Has access to organization and repository secrets (e.g., API keys, deployment tokens)
  * Has a read/write `GITHUB_TOKEN` by default
  * Can access private resources

Certain triggers automatically grant a workflow elevated privileges:

  * `pull_request_target` as described above
  * `workflow_run`: Triggered when another workflow completes.
  * `issue_comment`: Triggered when a comment is made on an issue or PR.

## Attack Details

  * A repository has a privileged workflow
  * An attacker forks the repository and adds malicious code (e.g., in the build script)
  * The attacker opens a PR from the fork, and, if needed, comments on the PR
  * The workflow in the base repository checks out the forked code
  * The workflow runs, (e.g. the build script etc.), which contains the malicious code

Please note that not only build scripts can be malicious code vectors. There is a large number of other possibilities. Some of them are listed in the [LOTP](https://boostsecurityio.github.io/lotp/) catalog.

## Recommendation

- Avoid using `pull_request_target` unless necessary.
- Employ unprivileged `pull_request` workflows followed by `workflow_run` for privileged operations.
- Use labels like `safe to test` to vet PRs and manage the execution context appropriately.

The best practice is to handle the potentially untrusted pull request via the **pull_request** trigger so that it is isolated in an unprivileged environment. The workflow processing the pull request should then store any results like code coverage or failed/passed tests in artifacts and exit. A second privileged workflow with the access to repository secrets, triggered by the completion of the first workflow using `workflow_run` trigger event, downloads the artifacts and make any necessary modifications to the repository or interact with third party services that require repository secrets (e.g. API tokens).

The artifacts downloaded from the first workflow should be considered untrusted and must be verified.

## Example

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
          npm install # scripts in package.json from PR would be executed here
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

- GitHub Security Lab Research: [Keeping your GitHub Actions and workflows secure Part 1: Preventing pwn requests](https://securitylab.github.com/research/github-actions-preventing-pwn-requests/).
- Mitigating risks of untrusted checkout: [GitHub Docs](https://docs.github.com/en/enterprise-cloud@latest/actions/reference/security/secure-use#mitigating-the-risks-of-untrusted-code-checkout).
- Living Off the Pipeline: [LOTP](https://boostsecurityio.github.io/lotp/).
