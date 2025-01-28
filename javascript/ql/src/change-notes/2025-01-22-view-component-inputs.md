---
category: majorAnalysis
---
* Added a new threat model kind called `view-component-input`, which can enabled with [advanced setup](https://docs.github.com/en/code-security/code-scanning/creating-an-advanced-setup-for-code-scanning/customizing-your-advanced-setup-for-code-scanning#extending-codeql-coverage-with-threat-models).
  When enabled, all React props, Vue props, and input fields in an Angular component are seen as taint sources, even if none of the corresponding instantiation sites appear to pass in a tainted value.
  Some users may prefer this as a "defense in depth" option but note that it may result in false positives.
  Regardless of whether the threat model is enabled, CodeQL will propagate taint from the instantiation sites of such components into the components themselves.
