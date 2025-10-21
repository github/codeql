---
applyTo: "*/ql/src/change-notes/*.md"
---

# Validation guide for query-pack change notes

When reviewing change notes in a pull request, ensure that they meet the following standards. Suggest changes if necessary.

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
| `breaking`       | Any breaking change to the query pack, the most common of which is the deletion of an existing query. |
| `deprecated`     | An existing query has been marked as `deprecated`. |
| `newQuery`       | A new query has been added. |
| `queryMetadata`  | The metadata of a query has been changed (e.g., to increase or reduce the `@precision`). |
| `majorAnalysis`  | The set of results produced by a query has changed (fewer false positives, more true positives, etc.) enough to be noticed by users of the query pack. |
| `minorAnalysis`  | The set of results produced by a query has changed, but only in scenarios that affect relatively few users. |
| `fix`            | A fix that does not change the results reported by a query (e.g., a performance fix). |

### Examples
#### Valid

```yaml
---
category: newQuery
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
