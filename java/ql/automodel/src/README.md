# Automodel Java Extraction Queries

This pack contains the automodel extraction queries for Java. Automodel uses extraction queries to extract the information it needs in order to create a prompt for a large language model. There's extraction queries for positive examples (things that are known to be, e.g., a sink), for negative examples (things that are known not to be, e.g., a sink), and for candidates (things where we should ask the large language model to classify).

## Extraction Queries in `java/ql/automodel/src`

Included in this pack are queries for both application mode and framework mode.

| Kind | Mode | Query File |
|------|------|------------|
| Candidates | Application Mode | [AutomodelApplicationModeExtractCandidates.ql](https://github.com/github/codeql/blob/main/java/ql/automodel/src/AutomodelApplicationModeExtractCandidates.ql) |
| Positive Examples | Application Mode | [AutomodelApplicationModeExtractPositiveExamples.ql](https://github.com/github/codeql/blob/main/java/ql/automodel/src/AutomodelApplicationModeExtractPositiveExamples.ql) |
| Negative Examples | Application Mode | [AutomodelApplicationModeExtractNegativeExamples.ql](https://github.com/github/codeql/blob/main/java/ql/automodel/src/AutomodelApplicationModeExtractNegativeExamples.ql) |
| Candidates | Framework Mode | [AutomodelFrameworkModeExtractCandidates.ql](https://github.com/github/codeql/blob/main/java/ql/automodel/src/AutomodelFrameworkModeExtractCandidates.ql) |
| Positive Examples | Framework Mode | [AutomodelFrameworkModeExtractPositiveExamples.ql](https://github.com/github/codeql/blob/main/java/ql/automodel/src/AutomodelFrameworkModeExtractPositiveExamples.ql) |
| Negative Examples | Framework Mode | [AutomodelFrameworkModeExtractNegativeExamples.ql](https://github.com/github/codeql/blob/main/java/ql/automodel/src/AutomodelFrameworkModeExtractNegativeExamples.ql) |

## Running the Queries

The extraction queries are part of a separate query pack, `codeql/java-automodel-queries`. Use this pack to run them. The queries are tagged appropriately, you can use the tags (example here: https://github.com/github/codeql/blob/main/java/ql/automodel/src/AutomodelApplicationModeExtractNegativeExamples.ql#L8) to construct query suites.

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

Endpoints are source code locations of interest. All positive examples, negative examples, and all candidates are endpoints, but not all endpoints are examples or candidates. Each mode decides which endpoints are relevant. For instance, if the Java application mode wants to support candidates for sinks that are arguments passed to unknown method calls, then the Java application mode implementation needs to make sure that method arguments are endpoints. If you look at the `TApplicationModeEndpoint` implementation in [AutomodelApplicationModeCharacteristics.qll](https://github.com/github/codeql/blob/main/java/ql/automodel/src/AutomodelApplicationModeCharacteristics.qll), you can see that this is the case: the `TExplicitArgument` implements this behavior.

Whether or not an endpoint is a positive/negative example, or a candidate depends on the individual extraction queries.

### Concept: `EndpointCharacteristics`

In the file [AutomodelSharedCharacteristics.ql](https://github.com/github/codeql/blob/main/java/ql/automodel/src/AutomodelSharedCharacteristics.ql), you will find the definition of the QL class `EndpointCharacteristic`.

An endpoint characteristic is a QL class that "tags" all endpoints for which the characteristic's `appliesToEndpoint` predicate holds. The characteristic defines a `hasImplications` predicate that declares whether all the endpoints should be considered as sinks/sources/negatives, and with which confidence.

The positive, negative, and candidate extraction queries largely[^1] use characteristics to decide which endpoint to select. For instance, if a characteristic exists that applies to an endpoint, and the characteristic implies (cf. `hasImplications`) that the endpoint is a sink with a high confidence &ndash; then that endpoint will be selected as a positive example. See the use of `isKnownAs` in [AutomodelFrameworkModeExtractPositiveExamples.ql](https://github.com/github/codeql/blob/main/java/ql/automodel/src/AutomodelFrameworkModeExtractPositiveExamples.ql).

[^1]: Candidate extraction queries are an exception, they treat `UninterestingToModelCharacteristic` differently.

#### :warning: Warning

Do not try to "fix" shortcomings that could be fixed by a better prompt or better example selection by adding language- or mode-specific characteristics . Those "fixes" tend to be confusing downstream when questions like "why wasn't this location selected as a candidate?" becomes progressively harder and harder to answer. It's best to rely on characteristics in the code that is shared across all languages and modes (see [Shared Code](#shared-code)).

## Shared Code

A significant part of the behavior of extraction queries is implemented in shared modules. When we add support for new languages, we expect to move the shared code to a separate QL pack. In the mean time, shared code modules must not import any java libraries.

## Packaging

Automodel extraction queries come as a dedicated package. See [qlpack.yml](https://github.com/github/codeql/blob/main/java/ql/automodel/src/qlpack.yml). The [publish.sh](https://github.com/github/codeql/blob/main/java/ql/automodel/publish.sh) script is responsible for publishing a new version to the [package registry](https://github.com/orgs/codeql/packages/container/package/java-automodel-queries). **The extraction queries are functionally coupled with other automodel components. Only publish the query pack as part of the automodel release process.**

### Backwards Compatibility

We try to keep changes to extraction queries backwards-compatible whenever feasible. There's several reasons:

 - That automodel can always decide which version of the package to run is a flawed assumption. We don't have direct control over the version of the extraction queries running on the user's local machine.
 - An automodel deployment will sometimes require the extraction queries to be published. If the new version of the extraction queries works with the old version of automodel, then it is much easier to roll back deployments of automodel.

## Candidate Examples

This section contains a few examples of the kinds of candidates that our queries might select, and why.

:warning: For clarity, this section presents "candidates" that are **actual** sinks. Therefore, the candidates presented here would actually be selected as positive examples in practice - rather than as candidates.

### Framework Mode Candidates

Framework mode is special because in framework mode, we extract candidates (as well as examples) from the implementation of a framework or library while the resulting models are applied in code bases that are _using_ the framework or library.

In framework mode, endpoints currently can have a number of shapes (see: `newtype TFrameworkModeEndpoint` in [AutomodelApplicationModeExtractCandidates.ql](https://github.com/github/codeql/blob/main/java/ql/automodel/src/AutomodelFrameworkModeCharacteristics.qll)). Depending on what kind of endpoint it is, the candidate is a candidate for one or several extensible types (eg., `sinkModel`, `sourceModel`).

#### Framework Mode Sink Candidates

Sink candidates in framework mode are modelled as formal parameters of functions defined within the framework. We use these to represent the corresponding inputs of function calls in a client codebase, which would be passed into those parameters.

For example, customer code could call the `Files.copy` method:

```java
// customer code using a library
...
Files.copy(userInputPath, outStream);
...
```

In order for `userInputPath` to be modeled as a sink, the corresponding parameter must be selected as a candidate. In the following example, assuming they're not modeled yet, the parameters `source` and `out` would be candidates:

```java
// Files.java
// library code that's analyzed in framework mode
public class Files {
  public static void copy(Path source, OutputStream out) throws IOException {
    // ...
  }
}
```

#### Framework Mode Source Candidates

Source candidates are a bit more varied than sink candidates:

##### Parameters as Source Candidates

A parameter could be a source, e.g. when a framework passes user-controlled data to a handler defined in customer code.
```java
// customer code using a library:
import java.net.http.WebSocket;

final class MyListener extends WebSocket.Listener {
  @override
  public CompletionStage<?> onText(WebSocket ws, CharSequence cs, boolean last) {
    ... process data that was received from websocket
  }
}
```

In this case, data passed to the program via a web socket connection is a source of remote data. Therefore, when we look at the implementation of `WebSocket.Listener` in framework mode, we need to produce a candidate for each parameter:

```java
// WebSocket.java
// library code that's analyzed in framework mode
interface Listener {
  ...
  default CompletionStage<?> onText(WebSocket webSocket CharSequence data, boolean last) {
      // <omitting default implementation>
  }
  ...
}
```

For framework mode, all parameters of the `onText` method should be candidates. If the candidates result in a model, the parameters of classes implementing this interface will be recognized as sources of remote data.

:warning: a consequence of this is that we can have endpoints in framework mode that are both sink candidates, as well as source candidates.

##### Return Values as Source Candidates

The other kind of source candidate we model is the return value of a method. For example:

```java
public class Socket {
  ...
  public InputStream getInputStream() throws IOException {
    ...
  }
  ...
}
```

This method returns a source of remote data that should be modeled as a sink. We therefore want to select the _method_ as a candidate.

### Application Mode Candidates

In application mode, we extract candidates from an application that is using various libraries.

#### Application Mode Source Candidates

##### Overridden Parameters as Source Candidates

In application mode, a parameter of a method that is overriding another method is taken as a source parameter to account for cases like the `WebSocket.Listener` example above where an application is implementing a "handler" that receives remote data.

##### Return Values as Source Candidates

Just like in framework mode, application mode also has to consider the return value of a call as a source candidate. The difference is that in application mode, we extract from the application sources, not the library sources. Therefore, we use the invocation expression as a candidate (unlike in framework mode, where we use the method definition).

#### Application Mode Sink Candidates

In application mode, arguments to calls are sink candidates.
