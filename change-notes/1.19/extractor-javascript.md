[[ condition: enterprise-only ]]

# Improvements to JavaScript analysis

## General improvements

* On LGTM, files whose name ends in `.min.js` or `-min.js` are no longer extracted by default, since they most likely contain minified code and results in these files would be hidden by default anyway. To extract such files anyway, you can add the following filters to your `lgtm.yml` file (or add them to existing filters):

```yaml
extraction:
  javascript:
    index:
      filters:
        - include: "**/*.min.js"
        - include: "**/*-min.js"
```

* The TypeScript compiler is now bundled with the distribution, and no longer needs to be installed manually.
  Should the compiler version need to be overridden, set the `SEMMLE_TYPESCRIPT_HOME` environment variable to
  point to an installation of the `typescript` NPM package.

## Changes to code extraction

* The extractor now supports [Optional Chaining](https://github.com/tc39/proposal-optional-chaining) expressions.

* The extractor now supports additional [Flow](https://flow.org/) syntax.
