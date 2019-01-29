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

* Extraction of JavaScript files (but not TypeScript files) on LGTM is now parallelized. By default, the extractor uses as many threads as there are processors, but this can be overridden by setting the `LGTM_INDEX_THREADS` environment variable. In particular, setting `LGTM_INDEX_THREADS` to 1 disables parallel extraction.
* The extractor now supports additional [Flow](https://flow.org/) syntax.
* The extractor now supports [Nullish Coalescing](https://github.com/tc39/proposal-nullish-coalescing) expressions.
* The extractor now supports [TypeScript 3.2](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-3-2.html).
* The TypeScript extractor now handles the control-flow of logical operators and destructuring assignments more accurately.
