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
 
 ## References
 - [Extending CodeQL coverage with CodeQL model packs in default setup](https://docs.github.com/en/code-security/code-scanning/managing-your-code-scanning-configuration/editing-your-configuration-of-default-setup#extending-codeql-coverage-with-codeql-model-packs-in-default-setup)
 - [Creating and working with CodeQL packs](https://docs.github.com/en/code-security/codeql-cli/using-the-advanced-functionality-of-the-codeql-cli/creating-and-working-with-codeql-packs#creating-a-codeql-model-pack)
 - [Customizing library models for GitHub Actions](https://codeql.github.com/docs/codeql-language-guides/customizing-library-models-for-actions/)
