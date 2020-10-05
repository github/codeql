# Prototype pollution

```
ID: js/prototype-pollution
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-250 external/cwe/cwe-400

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-400/PrototypePollution.ql)

Most JavaScript objects inherit the properties of the built-in `Object.prototype` object. Prototype pollution is a type of vulnerability in which an attacker is able to modify `Object.prototype`. Since most objects inherit from the compromised `Object.prototype`, the attacker can use this to tamper with the application logic, and often escalate to remote code execution or cross-site scripting.

One way to cause prototype pollution is through use of an unsafe *merge* or *extend* function to recursively copy properties from an untrusted source object. Such a call can modify any object reachable from the destination object, and the built-in `Object.prototype` is usually reachable through the special properties `__proto__` and `constructor.prototype`. An attacker can abuse this by sending an object with these property names and thereby modify `Object.prototype`.


## Recommendation
Update your library dependencies in order to use a safe version of the *merge* or *extend* function. If your library has no fixed version, switch to another library.


## Example
In the example below, the untrusted value `req.query.prefs` is parsed as JSON and then copied into a new object:


```javascript
app.get('/news', (req, res) => {
  let prefs = lodash.merge({}, JSON.parse(req.query.prefs));
})

```
Prior to lodash 4.17.11 this would be vulnerable to prototype pollution. An attacker could send the following GET request:

```
GET /news?prefs={"constructor":{"prototype":{"xxx":true}}}
```
This causes the `xxx` property to be injected on `Object.prototype`. Fix this by updating the lodash version:


```json
{
  "dependencies": {
    "lodash": "^4.17.12"
  }
}

```
Note that some web frameworks, such as Express, parse query parameters using extended URL-encoding by default. When this is the case, the application may be vulnerable even if not using `JSON.parse`. The example below would also be susceptible to prototype pollution:


```javascript
app.get('/news', (req, res) => {
  let config = lodash.merge({}, {
    prefs: req.query.prefs
  });
})

```
In the above example, an attacker can cause prototype pollution by sending the following GET request:

```
GET /news?prefs[constructor][prototype][xxx]=true
```

## References
* Prototype pollution attacks: [lodash](https://hackerone.com/reports/380873), [jQuery](https://hackerone.com/reports/454365), [extend](https://hackerone.com/reports/381185), [just-extend](https://hackerone.com/reports/430291), [merge.recursive](https://hackerone.com/reports/381194).
* Express: [urlencoded()](https://expressjs.com/en/api.html#express.urlencoded)
* Common Weakness Enumeration: [CWE-250](https://cwe.mitre.org/data/definitions/250.html).
* Common Weakness Enumeration: [CWE-400](https://cwe.mitre.org/data/definitions/400.html).