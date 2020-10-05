# Loop bound injection

```
ID: js/loop-bound-injection
Kind: path-problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-834

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-834/LoopBoundInjection.ql)

Using the `.length` property of an untrusted object as a loop bound may cause indefinite looping since a malicious attacker can set the `.length` property to a very large number. For example, when a program that expects an array is passed a JSON object such as `{length: 1e100}`, the loop will be run for 10<sup>100</sup> iterations. This may cause the program to hang or run out of memory, which can be used to mount a denial-of-service (DoS) attack.


## Recommendation
Either check that the object is indeed an array or limit the size of the `.length` property.


## Example
In the example below, an HTTP request handler iterates over a user-controlled object `obj` using the `obj.length` property in order to copy the elements from `obj` to an array.


```javascript
var express = require('express');
var app = express();

app.post("/foo", (req, res) => {
    var obj = req.body;

    var ret = [];

    // Potential DoS if obj.length is large.
    for (var i = 0; i < obj.length; i++) {
        ret.push(obj[i]);
    }
});

```
This is not secure since an attacker can control the value of `obj.length`, and thereby cause the loop to iterate indefinitely. Here the potential DoS is fixed by enforcing that the user-controlled object is an array.


```javascript
var express = require('express');
var app = express();

app.post("/foo", (req, res) => {
    var obj = req.body;
    
    if (!(obj instanceof Array)) { // Prevents DoS.
        return [];
    }

    var ret = [];

    for (var i = 0; i < obj.length; i++) {
        ret.push(obj[i]);
    }
});

```

## References
* Common Weakness Enumeration: [CWE-834](https://cwe.mitre.org/data/definitions/834.html).