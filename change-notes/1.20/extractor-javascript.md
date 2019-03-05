[[ condition: enterprise-only ]]

# Improvements to JavaScript analysis

> NOTES
>
> Please describe your changes in terms that are suitable for
> customers to read. These notes will have only minor tidying up
> before they are published as part of the release notes.
>
> This file is written for lgtm users and should contain *only*
> notes about changes that affect lgtm enterprise users. Add
> any other customer-facing changes to the `studio-java.md`
> file.
>

## General improvements

## Changes to code extraction

* Parallel extraction of JavaScript files (but not TypeScript files) on LGTM is now supported. The `LGTM_THREADS` environment variable can be set to indicate how many files should be extracted in parallel. If this variable is not set, parallel extraction is disabled.
* The extractor now offers experimental support for [E4X](https://developer.mozilla.org/en-US/docs/Archive/Web/E4X), a legacy language extension developed by Mozilla.
* The extractor now supports additional [Flow](https://flow.org/) syntax.
* The extractor now supports [Nullish Coalescing](https://github.com/tc39/proposal-nullish-coalescing) expressions.
* The extractor now supports [TypeScript 3.2](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-3-2.html).
* The TypeScript extractor now handles the control-flow of logical operators and destructuring assignments more accurately.
