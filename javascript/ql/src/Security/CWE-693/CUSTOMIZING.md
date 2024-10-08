# Insecure Helmet Configuration - customizations

You can extend the required [Helmet security settings](https://helmetjs.github.io/) using [data extensions](https://codeql.github.com/docs/codeql-language-guides/customizing-library-models-for-javascript/) in a [CodeQL model pack](https://docs.github.com/en/code-security/codeql-cli/using-the-advanced-functionality-of-the-codeql-cli/creating-and-working-with-codeql-packs#creating-a-codeql-model-pack).

They are defaulted to just `frameguard` and `contentSecurityPolicy`, but you can add more using this method, to require them not to be set to `false` (which explicitly disables them) in the Helmet configuration.

For example, this YAML model can be used inside a CodeQL model pack to require `frameguard` and `contentSecurityPolicy`:

```yaml
extensions:
  - addsTo:
      pack: codeql/javascript-all
      extensible: requiredHelmetSecuritySetting
    data:
      - ["frameguard"]
      - ["contentSecurityPolicy"]
```

Note: Using `frameguard` and `contentSecurityPolicy` is an example: the query already enforces these, so it is not necessary to add it with your own data extension.

A suitable [model pack](https://docs.github.com/en/code-security/codeql-cli/using-the-advanced-functionality-of-the-codeql-cli/creating-and-working-with-codeql-packs#creating-a-codeql-model-pack) might be:

```yaml
name: my-org/javascript-helmet-insecure-config-model-pack
version: 1.0.0
extensionTargets:
  codeql/javascript-all: '*'
dataExtensions:
  - models/**/*.yml
```

## References

- [Helmet security settings](https://helmetjs.github.io/)
- [Customizing library models for javascript](https://codeql.github.com/docs/codeql-language-guides/customizing-library-models-for-javascript/)
- [Creating and working with CodeQL packs](https://docs.github.com/en/code-security/codeql-cli/using-the-advanced-functionality-of-the-codeql-cli/creating-and-working-with-codeql-packs#creating-a-codeql-model-pack)
