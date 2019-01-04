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

* The extractor now supports [Nullish Coalescing](https://github.com/tc39/proposal-nullish-coalescing) expressions.
* The TypeScript extractor now handles the control-flow of logical operators and destructuring assignments more accurately.
