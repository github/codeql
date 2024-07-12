# Functionaility from untrusted source/domain - customizations

You can extend the behavior of the `js/functionality-from-untrusted-source` and `js/functionality-from-untrusted-domain` queries using [CodeQL data extensions](https://codeql.github.com/docs/codeql-language-guides/customizing-library-models-for-javascript/).

This allows you to require Subresource Integrity (SRI) checks on specific content delivery network (CDN) hostnames, and add additional domains to warn on, respectively.

For example, this YAML model can be used inside a CodeQL model pack to alert on uses of `example.com` in imported functionality, extending the `js/functionality-from-untrusted-domain` query:

```yaml
extensions:
  - addsTo:
      pack: codeql/javascript-all
      extensible: untrustedDomain
    data:
      - ["example.com"]
```

To add new hostnames that always require SRI checking, this YAML model can be used to require SRI on `cdn.example.com`, extending the `js/functionality-from-untrusted-source` query:

```yaml
extensions:
  - addsTo:
      pack: codeql/javascript-all
      extensible: isCdnDomainWithCheckingRequired
    data:
      - ["cdn.example.com"]
```

A suitable [model pack](https://docs.github.com/en/code-security/codeql-cli/using-the-advanced-functionality-of-the-codeql-cli/creating-and-working-with-codeql-packs#creating-a-codeql-model-pack) might be:

```yaml
name: my-org/javascript-untrusted-functionality-model-pack
version: 1.0.0
extensionTargets:
  codeql/java-all: '*'
dataExtensions:
  - models/**/*.yml
```

## References

- [Customizing library models for javascript](https://codeql.github.com/docs/codeql-language-guides/customizing-library-models-for-javascript/)
- [Creating and working with CodeQL packs](https://docs.github.com/en/code-security/codeql-cli/using-the-advanced-functionality-of-the-codeql-cli/creating-and-working-with-codeql-packs#creating-a-codeql-model-pack)
