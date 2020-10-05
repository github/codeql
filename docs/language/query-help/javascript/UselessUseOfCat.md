# Unnecessary use of `cat` process

```
ID: js/unnecessary-use-of-cat
Kind: problem
Severity: error
Precision: high
Tags: correctness security maintainability

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-078/UselessUseOfCat.ql)

Using the unix command `cat` only to read a file is an unnecessarily complex way to achieve something that can be done in a simpler and safer manner using the Node.js `fs.readFile` API.

The use of `cat` for simple file reads leads to code that is unportable, inefficient, complex, and can lead to subtle bugs or even security vulnerabilities.


## Recommendation
Use `fs.readFile` or `fs.readFileSync` to read files from the file system.


## Example
The following example shows code that reads a file using `cat`:


```javascript
var child_process = require('child_process');

module.exports = function (name) {
    return child_process.execSync("cat " + name).toString();
};

```
The code in the example will break if the input `name` contains special characters (including space). Additionally, it does not work on Windows and if the input is user-controlled, a command injection attack can happen.

The `fs.readFile` API should be used to avoid these potential issues:


```javascript
var fs = require('fs');

module.exports = function (name) {
    return fs.readFileSync(name).toString();
};

```

## References
* OWASP: [Command Injection](https://www.owasp.org/index.php/Command_Injection).
* Node.js: [File System API](https://nodejs.org/api/fs.html).
* [The Useless Use of Cat Award](http://porkmail.org/era/unix/award.html#cat).