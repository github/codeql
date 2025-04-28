# Execution of Untrusted Checked-out Code Triggered by Issue Comment

## Description

GitHub workflows can be triggered through various repository events, including incoming pull requests (PRs) or comments on Issues/PRs. A potentially dangerous misuse of the the trigger `issue_comment` followed by an explicit checkout of untrusted code (Pull Request HEAD) may lead to repository compromise if untrusted code gets executed in a privileged job.

## Recommendations

- Avoid using `issue_comment` unless necessary, consider using label gates instead to trigger workflows.
- If you must use `issue_comment` to trigger workflow runs, consider limiting the token that forked repos can use to read-only access to the repository or disallowing forks entirely.

Issue comment triggers are vulnerable to abuse by malicious actors. Triggering workflow run that checkout code through `issue_comment` can allow a malicious actor to execute code in the time between a comment being posted and the workflow run being triggered. Issue comment events are also not subject to the same security checks or pull request approvals that `pull_request` events are.

- [How to Secure your GitHub Actions Workflows with CodeQL](https://github.blog/security/application-security/how-to-secure-your-github-actions-workflows-with-codeql/#issueoops-security-pitfalls-with-issue_comment-trigger)
