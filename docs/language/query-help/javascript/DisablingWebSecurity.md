# Disabling Electron webSecurity

```
ID: js/disabling-electron-websecurity
Kind: problem
Severity: error
Precision: very-high
Tags: security frameworks/electron

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Electron/DisablingWebSecurity.ql)

Electron is secure by default through a same-origin policy requiring all JavaScript and CSS code to originate from the machine running the Electron application. Setting the `webSecurity` property of a `webPreferences` object to `false` will disable the same-origin policy.

Disabling the same-origin policy is strongly discouraged.


## Recommendation
Do not disable `webSecurity`.


## Example
The following example shows `webSecurity` being disabled.


```javascript
const mainWindow = new BrowserWindow({
  webPreferences: {
    webSecurity: false
  }
})
```
This is problematic, since it allows the execution of insecure code from other domains.


## References
* Electron Documentation: [Security, Native Capabilities, and Your Responsibility](https://electronjs.org/docs/tutorial/security#5-do-not-disable-websecurity)