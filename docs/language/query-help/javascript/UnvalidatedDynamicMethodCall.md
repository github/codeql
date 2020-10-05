# Unvalidated dynamic method call

```
ID: js/unvalidated-dynamic-method-call
Kind: path-problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-754

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-754/UnvalidatedDynamicMethodCall.ql)

JavaScript makes it easy to look up object properties dynamically at runtime. In particular, methods can be looked up by name and then called. However, if the method name is user-controlled, an attacker could choose a name that makes the application invoke an unexpected method, which may cause a runtime exception. If this exception is not handled, it could be used to mount a denial-of-service attack.

For example, there might not be a method of the given name, or the result of the lookup might not be a function. In either case the method call will throw a `TypeError` at runtime.

Another, more subtle example is where the result of the lookup is a standard library method from `Object.prototype`, which most objects have on their prototype chain. Examples of such methods include `valueOf`, `hasOwnProperty` and `__defineSetter__`. If the method call passes the wrong number or kind of arguments to these methods, they will throw an exception.


## Recommendation
It is best to avoid dynamic method lookup involving user-controlled names altogether, for instance by using a `Map` instead of a plain object.

If the dynamic method lookup cannot be avoided, consider whitelisting permitted method names. At the very least, check that the method is an own property and not inherited from the prototype object. If the object on which the method is looked up contains properties that are not methods, you should additionally check that the result of the lookup is a function. Even if the object only contains methods, it is still a good idea to perform this check in case other properties are added to the object later on.


## Example
In the following example, an HTTP request parameter `action` property is used to dynamically look up a function in the `actions` map, which is then invoked with the `payload` parameter as its argument.


```javascript
var express = require('express');
var app = express();

var actions = {
  play(data) {
    // ...
  },
  pause(data) {
    // ...
  }
}

app.get('/perform/:action/:payload', function(req, res) {
  let action = actions[req.params.action];
  // BAD: `action` may not be a function
  res.end(action(req.params.payload));
});

```
The intention is to allow clients to invoke the `play` or `pause` method, but there is no check that `action` is actually the name of a method stored in `actions`. If, for example, `action` is `rewind`, `action` will be `undefined` and the call will result in a runtime error.

The easiest way to prevent this is to turn `actions` into a `Map` and using `Map.prototype.has` to check whether the method name is valid before looking it up.


```javascript
var express = require('express');
var app = express();

var actions = new Map();
actions.put("play", function play(data) {
  // ...
});
actions.put("pause", function pause(data) {
  // ...
});

app.get('/perform/:action/:payload', function(req, res) {
  if (actions.has(req.params.action)) {
    let action = actions.get(req.params.action);
    // GOOD: `action` is either the `play` or the `pause` function from above
    res.end(action(req.params.payload));
  } else {
    res.end("Unsupported action.");
  }
});

```
If `actions` cannot be turned into a `Map`, a `hasOwnProperty` check should be added to validate the method name:


```javascript
var express = require('express');
var app = express();

var actions = {
  play(data) {
    // ...
  },
  pause(data) {
    // ...
  }
}

app.get('/perform/:action/:payload', function(req, res) {
  if (actions.hasOwnProperty(req.params.action)) {
    let action = actions[req.params.action];
    if (typeof action === 'function') {
      // GOOD: `action` is an own method of `actions`
      res.end(action(req.params.payload));
      return;
    }
  }
  res.end("Unsupported action.");
});

```

## References
* OWASP: [Denial of Service](https://www.owasp.org/index.php/Denial_of_Service).
* MDN: [Map](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map).
* MDN: [Object.prototype](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/prototype).
* Common Weakness Enumeration: [CWE-754](https://cwe.mitre.org/data/definitions/754.html).