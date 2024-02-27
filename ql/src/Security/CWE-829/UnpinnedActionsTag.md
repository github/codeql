# Unpinned tag for 3rd party Action in workflow

The individual jobs in a GitHub Actions workflow can interact with (and compromise) other jobs. For example, a job querying the environment variables used by a later job, writing files to a shared directory that a later job processes, or even more directly by interacting with the Docker socket and inspecting other running containers and executing commands in them. This means that a compromise of a single action within a workflow can be very significant, as that compromised action would have access to all secrets configured on your repository, and may be able to use the `GITHUB_TOKEN` to write to the repository. Consequently, there is significant risk in sourcing actions from third-party repositories on GitHub. For information on some of the steps an attacker could take, see "Security hardening for GitHub Actions."

## Recommendation

Pin an action to a full length commit SHA. This is currently the only way to use an action as an immutable release. Pinning to a particular SHA helps mitigate the risk of a bad actor adding a backdoor to the action's repository, as they would need to generate a SHA-1 collision for a valid Git object payload. When selecting a SHA, you should verify it is from the action's repository and not a repository fork.

## Example

In this example, the Actions workflow uses an unpinned version.

```yaml
name: "Unpinned Action Example"

jobs:
  build:
    steps:
      - name: Checkout repository
        uses: actions-third-party-mirror/checkout@v3

      - run: |
          ./build.sh
```

The Action is pinned in the example below.

```yaml
name: "Pinned Action Example"

jobs:
  build:
    steps:
      - name: Checkout repository
        uses: actions-mirror-third-party/checkout@ac593985615ec2ede58e132d2e21d2b1cbd6127c

      - run: |
          ./build.sh
```

## References

- GitHub: [Security hardening for GitHub Actions](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)
- Common Weakness Enumeration: [CWE-829](https://cwe.mitre.org/data/definitions/829.html).
