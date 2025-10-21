---
applyTo: >
  actions/ql/lib/change-notes/*.md,
  cpp/ql/lib/change-notes/*.md,
  csharp/ql/lib/change-notes/*.md,
  go/ql/lib/change-notes/*.md,
  java/ql/lib/change-notes/*.md,
  javascript/ql/lib/change-notes/*.md,
  python/ql/lib/change-notes/*.md,
  ruby/ql/lib/change-notes/*.md,
  rust/ql/lib/change-notes/*.md,
  shared/mad/change-notes/*.md,
  shared/quantum/change-notes/*.md,
  shared/regex/change-notes/*.md,
  shared/ssa/change-notes/*.md,
  shared/typos/change-notes/*.md,
  shared/util/change-notes/*.md,
  shared/xml/change-notes/*.md,
  shared/yaml/change-notes/*.md,
  swift/ql/lib/change-notes/*.md
---

# Validation guide for library-pack change notes

When performing a code review, ensure that the Markdown change-notes in the pull request meet the following standards:

## File name
The file name must match this pattern: `YYYY-MM-DD-description.md`
- `YYYY-MM-DD` should refer to the year, month, and day, respectively, of the change;
- `description` should refer to a short alphanumerical text, separated by hyphens, that describes the change-note;
- The extension should be ".md".

### Examples
#### Valid

- 2020-10-12-new-client-library.md
- 2025-01-01-refactored-database-logic.md
- 2022-12-25-removed-log4j.md

#### Invalid

- 3000-60-32-invalid-date.md
- no-date-in-file-name.md
- 2019-01-01 file name contains spaces.md

## Frontmatter
The file must begin with YAML frontmatter. Valid YAML frontmatter properties include:

- `category`
  - Required
  - This is a string that identifies one of a fixed set of categories that the change falls into.
- `tags`
  - Optional
  - A list of string tags.


### Categories
| Category         | Description |
|------------------|-------------|
| `breaking`       | Any breaking change to the library pack, the most common of which is the deletion of an existing API. |
| `deprecated`     | An existing API has been marked as deprecated. |
| `feature`        | A new library API has been added. |
| `majorAnalysis`  | An API has changed in a way that may affect the results produced by a query that consumes the API. |
| `minorAnalysis`  | An API has changed in a way that may affect the results produced by a query that consumes the API, but only in scenarios that affect relatively few users. |
| `fix`            | An API has been fixed in a way that is not likely to affect the results produced by a query that consumes the API. |

### Examples
#### Valid

```yaml
---
category: feature
---
```

```yaml
---
category: majorAnalysis
tags: cpp
---
```

#### Invalid

##### Missing `category` property

```yaml
---
tags: cpp
---
```

##### Invalid category `bug`; use `fix` instead

```yaml
---
category: bug
---
```

## Description
The content after the YAML frontmatter must be an American-English description of the change in one or more unordered Markdown list entries.

### Examples

#### Valid

```markdown
* Added support for the Nim programming language.
```

#### Invalid

##### Change description is not in a bullet-list entry
```markdown
Added support for the Nim programming language.
```

##### No headers; only list entries
```markdown
# Fixes
* Fixed C++ source parsing to handle comma operator.
```
