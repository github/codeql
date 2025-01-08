# Unpinned tag for 3rd party Action in workflow

## Description

Using a tag for a 3rd party Action that is not pinned to a commit can lead to executing an untrusted Action through a supply chain attack.

## Recommendations

Pinning an action to a full length commit SHA is currently the only way to use a non-immutable action as an immutable release. Pinning to a particular SHA helps mitigate the risk of a bad actor adding a backdoor to the action's repository, as they would need to generate a SHA-1 collision for a valid Git object payload. When selecting a SHA, you should verify it is from the action's repository and not a repository fork.


### Configuration

If there is an Action publisher that you trust, you can include the owner name/organization in a data extension model pack to add it to the allow list for this query. Adding owners to this list will prevent security alerts when using unpinned tags for Actions published by that owner.

#### Example

To allow any Action from the publisher `octodemo`, such as `octodemo/3rd-party-action`, follow these steps:

1. Create a data extension file `/models/trusted-owner.model.yml` with the following content:

    ```yaml
    extensions:
      - addsTo: 
          pack: codeql/actions-all
          extensible: trustedActionsOwnerDataModel 
        data:
          - ["octodemo"]
    ```

2. Create a model pack file `/codeql-pack.yml` with the following content:

    ```yaml
    name: my-org/actions-extensions-model-pack
    version: 0.0.0
    library: true
    extensionTargets:
      codeql/actions-all: '*'
    dataExtensions:
      - models/**/*.yml
    ```

3. Ensure that the model pack is included in your CodeQL analysis.

By following these steps, you will add `octodemo` to the list of trusted Action publishers, and the query will no longer generate security alerts for unpinned tags from this publisher.

## Examples

### Incorrect Usage

```yaml
- uses: tj-actions/changed-files@v44
```

### Correct Usage

```yaml
- uses: tj-actions/changed-files@c65cd883420fd2eb864698a825fc4162dd94482c # v44
```

## References

- [Using third-party actions](https://docs.github.com/en/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions#using-third-party-actions)
- [Extending CodeQL coverage with CodeQL model packs in default setup](https://docs.github.com/en/code-security/code-scanning/managing-your-code-scanning-configuration/editing-your-configuration-of-default-setup#extending-codeql-coverage-with-codeql-model-packs-in-default-setup)
- [Creating and working with CodeQL packs](https://docs.github.com/en/code-security/codeql-cli/using-the-advanced-functionality-of-the-codeql-cli/creating-and-working-with-codeql-packs#creating-a-codeql-model-pack)

