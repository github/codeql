# CodeQL pack change notes

Each CodeQL query pack and library pack has a CHANGELOG.md file to track how that pack changes with each release. Any non-trivial, user-visible change to a query pack or library pack should include a corresponding change-note file.

## How change notes are used
### How change notes are combined to form the CHANGELOG.md file

When a new release of a pack is published, the publishing process consolidates all of the change-note files from that pack's `change-notes` directory into the pack's `CHANGELOG.md` file. The consolidation process does the following:

- Strips all frontmatter from each change note.
- Strips all leading and trailing blank lines from the description of each change note.
- Adds a newline at the end of the description of any change note that does not already end with a newline.
- Groups change notes by `category`.
- Adds a section to the CHANGELOG.md file for each `category` that contains at least one change note. The section consists of a section heading followed by the contents of each change note in that `category`.
- Deletes the individual change-note files.

### How change notes affect the version of the pack

When a new release of a pack is published, the pack's version number is advanced based on the categories of the changes in that version:
- If any change note has a SemVer effect of `major version bump`, then the version number's major component will be incremented (e.g., `1.4.5` -> `2.0.0`).
- Otherwise, if any change note has a SemVer effect of `minor version bump`, then the version number's minor component will be incremented (e.g., `1.4.5` -> `1.5.0`).
- Otherwise, the version number's patch component will be incremented (e.g., `1.4.5` -> `1.4.6`).
Thus, it is important to choose the correct category for each change note, so that users can rely on the pack's version number to indicate compatibility with previous versions of the pack.

## Format of a change-note file
### File path

The location of the change-note file depends on whether it is for a query pack or library pack:
- For a query pack, the change-note file must be placed in the `ql/src/change-notes` directory of the query pack.
- For a library pack, the change-note file must be placed in the `ql/lib/change-notes` directory of the library pack.
  - NOTE: the `shared` library packs, which live in `/shared/<pack-name>`, do not follow the same structure as other library packs. For these packs, the change-note file must be placed in the `/shared/<pack-name>/change-notes` directory.

#### Examples
##### Valid file paths for query-pack change notes

- actions/ql/src/change-notes
- cpp/ql/src/change-notes
- javascript/ql/src/change-notes
- ql/ql/src/change-notes

##### Invalid file paths for query-pack change notes

- actions/ql/SRC/change-notes
- cpp/ql/lib/change-notes
- javascript/ql/change-notes
- ql/ql/src/change-notes/released
- ql/ql/src/change notes/released

##### Valid file paths for library-pack change notes

- go/ql/lib/change-notes
- swift/ql/lib/change-notes
- csharp/ql/lib/change-notes

##### Invalid file paths for library-pack change notes

- go/ql/src/change-notes
- go/ql/LIB/change-notes
- swift/change-notes
- swift/ql/src/change-notes
- csharp/ql/src/change-notes
- csharp/ql/change-notes

##### Valid file paths for `shared` library-pack change notes

- shared/mad/change-notes

##### Invalid file paths for `shared` library-pack change notes

- shared/mad/ql/lib/change-notes
- shared/mad/lib/change-notes
- shared/mad/src/change-notes

### File name

The change-note file must be named `YYYY-MM-DD-id.md`, where `YYYY-MM-DD` is the date of the change and `id` is a short sequence of American-English words, separated by hyphens, that describes the change.

#### Examples of file names
##### Valid file names

- 2020-10-12-new-db-client-library.md
- 2025-01-01-refactored-shopping-cart-logic.md
- 2021-11-24-removed-log4j-library.md
- 2021-12-14-int-overflow-query.md

##### Invalid file names

- 3000-60-32-invalid-date.md
- no-date-in-file-name.md
- 2019-01-01 file name contains spaces.md
- 2022-05-05-wrong-file-extension.txt

### Frontmatter

The change-note file must begin with YAML frontmatter. Valid YAML properties include:

- `category`
  - Required
  - A string that labels the kind of change. The `category` serves two purposes. First, when a new version of a CodeQL pack is released, its change notes will be grouped together by their `category` and combined to form the pack's CHANGELOG.md file. Second, the `category` also determines how this change will affect the semantic-version number of the pack's next release.
  - The set of categories from which to select will depend on whether the change note is for a query pack or a library pack. See the next section, titled "Change categories", for the available categories for each type of pack.

#### Change categories

There is one set of available categories for query packs, and another set of available categories for library packs. Be sure to choose a category from the correct set.

##### Query-pack change categories

| Category       | SemVer effect      | Description |
|----------------|--------------------|-------------|
| breaking       | major version bump | Any breaking change to the query pack, the most common of which is the deletion of an existing query. |
| deprecated     | minor version bump | An existing query has been marked as `deprecated`. |
| newQuery       | minor version bump | A new query has been added. |
| queryMetadata  | minor version bump | The metadata of a query has been changed (e.g., to increase or reduce the `@precision`). |
| majorAnalysis  | minor version bump | The set of results produced by a query has changed (fewer false positives, more true positives, etc.) enough to be noticed by users of the query pack. |
| minorAnalysis  | patch version bump | The set of results produced by a query has changed, but only in scenarios that affect relatively few users. |
| fix            | patch version bump | A fix that does not change the results reported by a query (e.g., a performance fix). |

##### Library-pack change categories

| Category       | SemVer effect      | Description |
|----------------|--------------------|-------------|
| breaking       | major version bump | Any breaking change to the library pack, the most common of which is the deletion of an existing API. |
| deprecated     | minor version bump | An existing API has been marked as `deprecated`. |
| feature        | minor version bump | A new library API has been added. |
| majorAnalysis  | minor version bump | An API has changed in a way that may affect the results produced by a query that consumes the API. |
| minorAnalysis  | patch version bump | An API has changed in a way that may affect the results produced by a query that consumes the API, but only in scenarios that affect relatively few users. |
| fix            | patch version bump | An API has been fixed in a way that is not likely to affect the results produced by a query that consumes the API. |

#### Examples of frontmatter
##### Valid frontmatter for query-pack change notes

```yaml
---
category: newQuery
---
```

```yaml
---
category: fix
---
```

##### Invalid frontmatter for query-pack change notes

This example is invalid because `feature` is not a valid category for query-pack change notes:

```yaml
---
category: feature
---
```

This example is invalid because it is missing the required `category` property:

```yaml
---
---
```

This example is invalid because `bug` is not a valid category; use `fix` instead:

```yaml
---
category: bug
---
```

##### Valid frontmatter for library-pack change notes

```yaml
---
category: feature
---
```

```yaml
---
category: majorAnalysis
---
```

##### Invalid frontmatter for library-pack change notes

This example is invalid because `newQuery` is not a valid category for library-pack change notes:

```yaml
---
category: newQuery
---
```

This example is invalid because `deprecated` is misspelled:

```yaml
---
category: deprected
---
```

### Description

After the YAML frontmatter, the rest of the Markdown file is the user-visible content of the change note. This should usually be a single unordered Markdown-list entry (starting with `*`). However, it is also acceptable for the change note to have multiple list entries if there are multiple changes that are closely related and have the same `category`.

For consistency, change notes should be written in American English.

### Examples of change-note descriptions
#### Valid change-note descriptions

```markdown
* Added support for the Nim programming language.
```

```markdown
* Fixed `cpp` extractor to support the comma operator in all contexts.
```

```markdown
* Minimized memory consumption.
* Upgraded to new GC algorithm.
* Optimized performance of string handling functions.
```

#### Invalid change-note descriptions

This example is invalid because it is missing the leading `*` for the list entry:

```markdown
Added support for the Nim programming language.
```

This example is invalid because it begins with a heading instead of a list entry:

```markdown
# Fixes
* Fixed C++ source parsing to handle comma operator.
```

This example is invalid because it is written in British English; use "Minimize" instead of "Minimise":

```markdown
* Minimise memory consumption.
```

## Examples of complete change notes
### Valid complete change notes for query packs

```yaml
---
category: newQuery
---
* Added a new query, `cpp/integer-overflow`, to detect code that depends on the result of signed integer overflow.
```

```yaml
---
category: majorAnalysis
---
* Added taint flow model for `std::codecvt`.
* Changed QL classes to require explicit import statements.
```

### Invalid complete change notes for query packs

This example is invalid because `feature` is not a valid category for query-pack change notes:

```yaml
---
category: feature
---
* Optimized SQL query performance for large databases.
```

This example is invalid because the Markdown description does not begin with `*`:

```yaml
---
category: breaking
---
+ Disabled `go/sql-injection` query by default due to high false positive rate.
- Removed `go/old-xml-library` query.
```

### Valid complete change notes for library packs

```yaml
---
category: fix
---
* Fixed a performance issue where the `cpp/integer-overflow` query would time out on large databases.
```

```yaml
---
category: majorAnalysis
---
* Added taint flow model for `std::string`.
```

### Invalid complete change notes for library packs

This example is invalid because it contains too many changes in one note and the changes are not closely related:

```yaml
---
category: breaking
---
* Added support for analysing Ruby on Rails applications.
* Minimized memory consumption.
* Improved data flow analysis precision.
* Added more logging for debugging purposes.
* Optimized performance of string handling functions.
```

This example is invalid because `newQuery` is not a valid category for library-pack change notes:

```yaml
---
category: newQuery
---
* Added a new query, `cpp/integer-overflow`, to detect code that depends on the result of signed integer overflow.
```