[[ condition: enterprise-only ]]

# Improvements to JavaScript analysis

## Changes to code extraction

* Parallel extraction of JavaScript files (but not TypeScript files) on LGTM is now supported. If LGTM is configured to evaluate queries using multiple threads, then JavaScript files are also extracted using multiple threads.
* Experimental support for [E4X](https://developer.mozilla.org/en-US/docs/Archive/Web/E4X), a legacy language extension developed by Mozilla, is available.
* Additional [Flow](https://flow.org/) syntax is now supported.
* [Nullish Coalescing](https://github.com/tc39/proposal-nullish-coalescing) expressions are now supported.
* [TypeScript 3.2](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-3-2.html) is now supported.
* The TypeScript extractor now handles the control flow of logical operators and destructuring assignments more accurately.
