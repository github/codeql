# Unsafe dynamic method access

```
ID: js/unsafe-dynamic-method-access
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-094

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-094/UnsafeDynamicMethodAccess.ql)

Calling a user-controlled method on certain objects can lead to invocation of unsafe functions, such as `eval` or the `Function` constructor. In particular, the global object contains the `eval` function, and any function object contains the `Function` constructor in its `constructor` property.


## Recommendation
Avoid invoking user-controlled methods on the global object or on any function object. Whitelist the permitted method names or change the type of object the methods are stored on.


## Example
In the following example, a message from the document's parent frame can invoke the `play` or `pause` method. However, it can also invoke `eval`. A malicious website could embed the page in an iframe and execute arbitrary code by sending a message with the name `eval`.


```javascript
// API methods
function play(data) {
  // ...
}
function pause(data) {
  // ...
}

window.addEventListener("message", (ev) => {
    let message = JSON.parse(ev.data);

    // Let the parent frame call the 'play' or 'pause' function 
    window[message.name](message.payload);
});

```
Instead of storing the API methods in the global scope, put them in an API object or Map. It is also good practice to prevent invocation of inherited methods like `toString` and `valueOf`.


```javascript
// API methods
let api = {
  play: function(data) {
    // ...
  },
  pause: function(data) {
    // ...
  }
};

window.addEventListener("message", (ev) => {
    let message = JSON.parse(ev.data);

    // Let the parent frame call the 'play' or 'pause' function
    if (!api.hasOwnProperty(message.name)) {
      return;
    }
    api[message.name](message.payload);
});

```

## References
* OWASP: [Code Injection](https://www.owasp.org/index.php/Code_Injection).
* MDN: [Global functions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects#Function_properties).
* MDN: [Function constructor](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function).
* Common Weakness Enumeration: [CWE-94](https://cwe.mitre.org/data/definitions/94.html).