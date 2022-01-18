# Adding change notes for query and library changes

Each CodeQL query pack or library pack has its own change log to track how that pack changes with each release. Any non-trivial, user-visible change to a query or library should add a change note to the affected pack. This document describes how to do that.

## Creating a change note
To create a new change note for a pack, create a new markdown file in the `change-notes` directory of the pack (e.g., in `cpp/ql/src/change-notes` for the C++ standard query pack). The markdown file must be named `YYYY-MM-DD-id.md`, where `YYYY-MM-DD` is the date of the change, and `id` is a short string to help identify the change. For example, if you were adding a new integer overflow query to the C++ standard query pack, you might do so from a branch named `int-overflow-query`, with a change note file named `cpp/ql/src/change-notes/2021-12-14-int-overflow-query.md`. Here are a few example change note files:

```yaml
---
category: newQuery
---
* Added a new query, `cpp/integer-overflow`, to detect code that depends on the result of signed integer overflow.
```

```yaml
---
category: fix
---
* Fixed a performance issue where the `cpp/integer-overflow` query would time out on large databases.
```

```yaml
---
category: minorAnalysis
---
* Added taint flow model for `std::codecvt`.
```

```yaml
---
category: majorAnalysis
---
* Added taint flow model for `std::string`.
```

### Metadata
The change note file requires some metadata at the beginning of the file. This metadata is later used to determine how to advance the version number of the pack next time it is published, and to group related change notes in the final changelog. The metadata is YAML, enclosed by a `---` line before and after.

The valid YAML properties in the metadata are:

- `category` - Required. This is a string that identifies one of a fixed set of categories that the change falls into. In the full changelog for the pack, the change notes for a particular release will be grouped together by category. The category also determines how this change will affect the version number of the pack's next release. For more information on available categories, see the Change Categories section below.
- `tags` - Optional. A list of string tags. These are not currently used by the change note infrastructure, so just omit this property.

### Description
After the `---` line following the metadata, the rest of the markdown file is the user-visible content of the change note. This should usually be a single markdown bullet list entry (starting with `*`), although it is acceptable to have multiple bullet entries in the same change note if there are multiple changes that are closely related and have the same category metadata.

## Change categories
Each change note must specifiy a `category` property in its metadata. This category servers two purposes: It determines how the change affects the version number of the next release of the pack, and it is used to group related changes in the final changelog. There is one set of available categories for query packs, and another set of available categories for library packs.

### Query pack change categories
| Category       | SemVer effect      | Description |
|----------------|--------------------|-------------|
| breaking       | major version bump | Any breaking change to the query pack, the most common of which is the deletion of an existing query. |
| deprecated     | minor version bump | An existing query has been marked as `deprecated`. |
| newQuery       | minor version bump | A new query has been added. |
| queryMetadata  | minor version bump | The metadata of a query has been changed (e.g., to increase or reduce the `@precision`). |
| majorAnalysis  | minor version bump | The set of results produced by a query has changed (fewer false positives, more true positives, etc.) enough to be noticed by users of the query pack. |
| minorAnalysis  | patch version bump | The set of results produced by a query has changed, but only in scenarios that affect relatively few users. |
| fix            | patch version bump | A fix that does not change the results reported by a query (e.g., a performance fix). |

### Library pack change categories
| Category       | SemVer effect      | Description |
|----------------|--------------------|-------------|
| breaking       | major version bump | Any breaking change to the library pack, the most common of which is the deletion of an existing API. |
| deprecated     | minor version bump | An existing API has been marked as `deprecated`. |
| feature        | minor version bump | A new library API has been added. |
| majorAnalysis  | minor version bump | An API has changed in a way that may affect the results produced by a query that consumes the API. |
| minorAnalysis  | patch version bump | An API has changed in a way that may affect the results produced by a query that consumes the API, but only in scenarios that affect relatively few users. |
| fix            | patch version bump | An API has been fixed in a way that is not likely to affect the results produced by a query that consumes the API. |

## How the final changelog is created
When a new release of a pack is published, the publishing process consolidates all of the change note files from that pack's `change-notes` directory into the pack's `CHANGELOG.md` file. The consolidation process does the following:

- Strips all metadata from each change note.
- Strips all leading and trailing blank lines from the description of each change note.
- Adds a newline at the end of the description of any change note that does not already end with a newline.
- Groups change notes by category.
- Adds a section to the changelog for each category that contains at least one change note. The section consists of a section heading followed by the contents of each change note in that category.
- Deletes the individual change note files.

## How change notes affect the version of the pack
When a new release of a pack is published, the pack's version number is advanced based on the categories of the changes in that version:
- If any change note has a SemVer effect of `major version bump`, then the version number's major component will be incremented (e.g., `1.4.5` -> `2.0.0`).
- Otherwise, if any change note has a SemVer effect of `minor version bump`, then the version number's minor component will be incremented (e.g., `1.4.5` -> `1.5.0`).
- Otherwise, the version number's patch component will be incremented (e.g., `1.4.5` -> `1.4.6`).
Thus, it is important to choose the correct category for each change note, so that users can rely on the pack's version number to indicate compatibility with previous versions of the pack.
