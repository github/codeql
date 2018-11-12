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

> Changes that affect alerts in many files or from many queries
> For example, changes to file classification

## Changes to code extraction

* The TypeScript compiler is now bundled with the distribution, and no longer needs to be installed manually.
  Should the compiler version need to be overridden, set the `SEMMLE_TYPESCRIPT_HOME` environment variable to
  point to an installation of the `typescript` NPM package.
