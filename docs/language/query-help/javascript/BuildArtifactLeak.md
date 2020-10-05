# Storage of sensitive information in build artifact

```
ID: js/build-artifact-leak
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-312 external/cwe/cwe-315 external/cwe/cwe-359

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-312/BuildArtifactLeak.ql)

Sensitive information included in a build artifact can allow an attacker to access the sensitive information if the artifact is published.


## Recommendation
Only store information that is meant to be publicly available in a build artifact.


## Example
The following example creates a `webpack` configuration that inserts all environment variables from the host into the build artifact:


```javascript
const webpack = require("webpack");

module.exports = [{
    plugins: [
        new webpack.DefinePlugin({
            "process.env": JSON.stringify(process.env)
        })
    ]
}];
```
The environment variables might include API keys or other sensitive information, and the build-system should instead insert only the environment variables that are supposed to be public.

The issue has been fixed below, where only the `DEBUG` environment variable is inserted into the artifact.


```javascript
const webpack = require("webpack");

module.exports = [{
    plugins: [
        new webpack.DefinePlugin({
            'process.env': JSON.stringify({ DEBUG: process.env.DEBUG })
        })
    ]
}];

```

## References
* webpack: [DefinePlugin API](https://webpack.js.org/plugins/define-plugin/).
* Common Weakness Enumeration: [CWE-312](https://cwe.mitre.org/data/definitions/312.html).
* Common Weakness Enumeration: [CWE-315](https://cwe.mitre.org/data/definitions/315.html).
* Common Weakness Enumeration: [CWE-359](https://cwe.mitre.org/data/definitions/359.html).