# Automodel Java Extraction Queries

This pack contains the automodel extraction queries for Java.

## Extraction Queries in `java/ql/automodel/src`

This pack contains extraction queries for application mode and framework mode.

| Kind | Mode | Query File |
|------|------|------------|
| Candidates | Application Mode | [AutomodelApplicationModeExtractCandidates.ql](https://github.com/github/codeql/blob/main/java/ql/automodel/src/AutomodelApplicationModeExtractCandidates.ql) |
| + Examples | Application Mode | [AutomodelApplicationModeExtractPositiveExamples.ql](https://github.com/github/codeql/blob/main/java/ql/automodel/src/AutomodelApplicationModeExtractPositiveExamples.ql) |
| - Examples | Application Mode | [AutomodelApplicationModeExtractNegativeExamples.ql](https://github.com/github/codeql/blob/main/java/ql/automodel/src/AutomodelApplicationModeExtractNegativeExamples.ql) |
| Candidates | Framework Mode | [AutomodelFrameworkModeExtractCandidates.ql](https://github.com/github/codeql/blob/main/java/ql/automodel/src/AutomodelFrameworkModeExtractCandidates.ql) |
| + Examples | Framework Mode | [AutomodelFrameworkModeExtractPositiveExamples.ql](https://github.com/github/codeql/blob/main/java/ql/automodel/src/AutomodelFrameworkModeExtractPositiveExamples.ql) |
| - Examples | Framework Mode | [AutomodelFrameworkModeExtractNegativeExamples.ql](https://github.com/github/codeql/blob/main/java/ql/automodel/src/AutomodelFrameworkModeExtractNegativeExamples.ql) |

## Running the Queries

The extraction queries are part of a separate query pack, `java-automodel-queries`. Use this pack to run them. The queries are tagged appropriately, you can use the tags (example here: https://github.com/github/codeql/blob/main/java/ql/automodel/src/AutomodelApplicationModeExtractNegativeExamples.ql#L8) to construct query suites.

For example, a query suite selecting all example extraction queries (positive and negative) for application mode looks like this:

```
# File: automodel-application-mode-extraction-examples.qls
# ---
# Query suite for extracting examples for automodel

- description: Automodel application mode examples extraction.
- queries: .
  from: codeql/java-automodel-queries
- include:
    tags contain all:
    - automodel
    - extract
    - application-mode
    - examples
```

## Important Software Design Concepts and Goals

### Concept: `Endpoint`

Endpoints are source code locations of interest. All +/- examples and all candidates are endpoints, but not all endpoints are examples or candidates. Each mode decides what endpoints are relevant. For instance, if the Java application mode wants to support candidates for sinks that are arguments passed to unknown method calls, then the Java application mode implementation needs to make sure that method arguments are endpoints. If you look at the `TApplicationModeEndpoint` implementation in [AutomodelApplicationModeCharacteristics.qll](https://github.com/github/codeql/blob/main/java/ql/automodel/src/AutomodelApplicationModeCharacteristics.qll), you can see that this is the case: the `TExplicitArgument` implements this behavior.

Whether or not an endpoint is a +/- example, or a candidate depends on the individual extraction queries.

### Concept: `EndpointCharacteristics`

In the file [AutomodelSharedCharacteristics.ql](https://github.com/github/codeql/blob/main/java/ql/automodel/src/AutomodelSharedCharacteristics.ql), you will find the definition of the QL class `EndpointCharacteristic`.

An endpoint characteristic is a QL class that "tags" all endpoints for which the characteristic's `appliesToEndpoint` predicate holds. The characteristic defines a `hasImplications` predicate that declares whether all the endpoints should be considered as sinks/sources/negatives, and with which confidence.

The +/- and candidate extraction queries largely<sup>[1](#largely-use-characteristics)</sup> use characteristics to decide which endpoint to select. For instance, if a characteristic exists that applies to an endpoint, and the characteristic implies (cf. `hasImplications`) that the endpoint is a sink with a high confidence &ndash; then that endpoint will be selected as a positive example. See the use of `isKnownAs` in [AutomodelFrameworkModeExtractPositiveExamples.ql](https://github.com/github/codeql/blob/main/java/ql/automodel/src/AutomodelFrameworkModeExtractPositiveExamples.ql).

<a name="largely-use-characteristics">1</a>: Candidate extraction queries are an exception, they treat `UninterestingToModelCharacteristic` differently.

#### :warning: Warning

Do not to "fix" shortcomings that could be fixed by a better prompt or better example selection by adding language- or mode-specific characteristics . Those "fixes" tend to be confusing downstream when questions like "why wasn't this location selected as a candidate?" is harder and harder to answer. It's best to rely on characteristics in the code that is shared across all languages and modes (see [Shared Code](#shared-code)).

## Shared Code

A significant part of the behavior of extraction queries is implemented in shared modules. When we add support for new languages, we expect to move the shared code to a separate QL pack. In the mean time, shared code modules must not import any java libraries.
