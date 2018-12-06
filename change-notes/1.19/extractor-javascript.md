[[ condition: enterprise-only ]]

# Improvements to JavaScript analysis

## General improvements

* On LGTM, files whose name ends in `.min.js` or `-min.js` are no longer extracted by default. These files usually contain minified code and any alerts in these files would be hidden by default. If you still want to extract code from these files, you can add the following filters to your `lgtm.yml` file (or add them to existing filters):

```yaml
extraction:
  javascript:
    index:
      filters:
        - include: "**/*.min.js"
        - include: "**/*-min.js"
```

* The TypeScript compiler is now included in the LGTM Enterprise and QL command-line tools installations, and you no longer need to install it manually.
  If you need to override the compiler version, set the `SEMMLE_TYPESCRIPT_HOME` environment variable to
  point to an installation of the `typescript` NPM package.

## Changes to code extraction

The extractor now supports:

* [Optional Chaining](https://github.com/tc39/proposal-optional-chaining) expressions.
* Additional [Flow](https://flow.org/) syntax.
