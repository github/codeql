# Query classification and display

## Attributable Queries

The results of some queries are unsuitable for attribution to individual
developers. Most of them have a threshold value on which they trigger,
for example all metric violations and statistics based queries. The
results of such queries would all be attributed to the person pushing
the value over (or under) the threshold. Some queries only trigger when
another one doesn't. An example of this is the MaybeNull query which
only triggers if the AlwaysNull query doesn't. A small change in the
data flow could make an alert switch from AlwaysNull to MaybeNull (or
vice versa). As a result we attribute both a fix and an introduction to
the developer that changed the data flow. For this particular example
the funny attribution results are more a nuisance than a real problem;
the overall alert count remains unchanged. However, for the duplicate
and similar code queries the effects can be much more severe, as they
come in versions for "duplicate file" and "duplicate function" among
many others, where "duplicate function" only triggers if "duplicate
file" didn't. As a result adding some code to a duplicate file might
result in a "fix" of a "duplicate file" alert and an introduction of
many "duplicate function" alerts. This would be highly unfair.
Currently, only the duplicate and similar code queries exhibit this
"exchanging one for many" alerts when trying to attribute their results.
Therefore we currently exclude all duplicate code related alerts from
attribution.

The following queries are excluded from attribution:

- Metric violations, i.e. the ones with metadata properties like
  `@(error|warning|recommendation)-(to|from)`
- Queries with tag `non-attributable`

This check is applied when the results of a single attribution are
loaded into the datastore. This means that any change to this behaviour
will only take effect on newly attributed revisions but the historical
data remains unchanged.

## Query severity and precision

We currently classify queries on two axes, with some additional tags.
Those axes are severity and precision, and are defined using the
query-metadata properties `@problem.severity` and `@precision`.

For severity, we have the following categories:

- Error
- Warning
- Recommendation

These categories may change in the future.

For precision, we have the following categories:

- very-high
- high
- medium
- low

As [usual](https://en.wikipedia.org/wiki/Precision_and_recall),
precision is defined as the percentage of query results that are true
positives, i.e., precision = number of true positives / (number of true
positives + number of false positives). There is no hard-and-fast rule
for which precision ranges correspond to which categories.

We expect these categories to remain unchanged for the foreseeable
future.

### A note on precision

Intuitively, precision measures how well the query performs at finding the
results it is supposed to find, i.e., how well it implements its
(informal, unwritten) rule. So how precise a query is depends very much
on what we consider that rule to be. We generally try to sharpen our
rules to focus on results that a developer might actually be interested
in.

## Which queries to run and display on LGTM

The following queries are run:

Precision:     | very-high | high    | medium  | low
---------------|-----------|---------|---------|----
Error          | **Yes**   | **Yes** | **Yes** | No
Warning        | **Yes**   | **Yes** | **Yes** | No
Recommendation | **Yes**   | **Yes** | No      | No

The following queries have their results displayed by default:

Precision:     | very-high | high    | medium | low
---------------|-----------|---------|--------|----
Error          | **Yes**   | **Yes** | No     | No
Warning        | **Yes**   | **Yes** | No     | No
Recommendation | **Yes**   | No      | No     | No
  
Results for queries that are run but not displayed by default can be
made visible by editing the project configuration.
  
Queries from custom query packs (in-repo or site-wide) are always run
and displayed by default. They can be hidden by editing the project
config, and "disabled" by removing them from the query pack.
