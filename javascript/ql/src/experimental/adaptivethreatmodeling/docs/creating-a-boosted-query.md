# Creating a boosted security query

You can use adaptive threat modeling (ATM) to boost security queries by enlarging their threat model to find more potential vulnerabilities.

Adaptive threat modeling is a set of CodeQL libraries for writing boosted security queries.
Boosted security queries identify potential vulnerabilities missed by an existing query by semi-automatically enlarging the query's threat model.
For more information about ATM, see "[About adaptive threat modeling](./about-adaptive-threat-modeling.md)."

**Note: Adaptive threat modeling is in beta and subject to change.
It is currently only available for JavaScript and TypeScript code.**

## About boosted queries

Boosted queries use machine learning to semi-automatically enlarge a query's threat model.
A boosted query predicts new security vulnerabilities that the standard query cannot identify.
Each extra result is scored, with higher scores more likely to be true positive results.

**Note: Currently, adaptive threat modeling only supports boosting sinks.**

To create a boosted query, you supply an ATM configuration that provides the following information:

- The [data flow configuration](https://help.semmle.com/QL/learn-ql/javascript/dataflow.html#global-data-flow) for the known endpoints (known sources and sinks), as a starting point for boosting.
- A sink endpoint filter, which is used to filter out implausible sinks from the set of candidate sinks predicted by the machine learning model.
  The sinks that remain after applying the sink endpoint filter are the known as the effective sinks.
- Optionally, new additional flow steps.
  These may be needed to find data flow paths from the known sources to the effective sinks.

For more information about how adaptive threat modeling works, see "[About adaptive threat modeling](./about-adaptive-threat-modeling.md)."

## Example: boosting the standard NoSQL injection JavaScript query

Before working through this example, ensure that you have correctly set up adaptive threat modeling and can run a boosted query.
For more information, see "[Setting up adaptive threat modeling](https://github.com/github/vscode-codeql-starter/tree/experimental/atm#readme)."

A potential NoSQL injection vulnerability occurs when a user-controlled object becomes part of a query that is run against a NoSQL database.
The CodeQL library for JavaScript contains a [standard query](https://github.com/github/codeql/blob/master/javascript/ql/src/Security/CWE-089/SqlInjection.ql) that discovers such vulnerabilities.
This standard query works by defining a data flow configuration that marks user-controlled objects as taint sources and specific arguments of database access calls as taint sinks.

To know which arguments should be taint sinks, the CodeQL library for JavaScript models a set of popular NoSQL libraries by defining the structure of these libraries in QL.
However, the CodeQL library for JavaScript does not model rare or bespoke NoSQL libraries.
Consequently, the standard NoSQL injection query will not detect vulnerabilities in projects which use these libraries.
This guide will show you how to use adaptive threat modeling to boost the standard NoSQL injection query to find new candidate vulnerabilities.

### Downloading the example CodeQL database

For this example, we have created a CodeQL database for you to test your boosted query against.
To follow along with this guide, download the CodeQL database for this project by visiting https://drive.google.com/open?id=1I8M0yySyIH9xPzkPER85azZ6pWp0C5mb.
Add the downloaded database to CodeQL for VS Code and select it as your current database.
For more information about CodeQL for VS Code, visit "[CodeQL for VS Code](https://help.semmle.com/codeql/codeql-for-vscode.html)."

### About the standard NoSQL injection JavaScript query

The standard query for NoSQL injection in the CodeQL library for JavaScript is located at [`ql/javascript/ql/src/Security/CWE-089/SqlInjection.ql`](https://github.com/github/codeql/blob/master/javascript/ql/src/Security/CWE-089/SqlInjection.ql).
It uses a data flow configuration located at [`ql/javascript/ql/src/semmle/javascript/security/dataflow/NosqlInjection.qll`](https://github.com/github/codeql/blob/master/javascript/ql/src/semmle/javascript/security/dataflow/NosqlInjection.qll) to specify a threat model for NoSQL injection.
This threat model incorporates sources (`isSource`), sinks (`isSink`), sanitizers (`isSanitizer`, `isSanitizerGuard`), and additional flow steps (`isAdditionalFlowStep`).

### Specifying the data flow configuration for the known endpoints

First, create a stub boosted query by creating a new file named `NosqlInjectionATM.ql` and copying over the contents of the [`step1.ql` stub query](resources/step1.ql).

Now, we will specify the data flow configuration for the known endpoints.
Since we are boosting an existing security query we can reuse the predicates from the existing data flow configuration.

1. Open the data flow configuration for the standard security query.
    For NoSQL injection, the standard query is located at [`ql/javascript/ql/src/semmle/javascript/security/dataflow/NosqlInjection.qll`](https://github.com/github/codeql/blob/master/javascript/ql/src/semmle/javascript/security/dataflow/NosqlInjection.qll).

2. Port over all the predicates from the standard query to the ATM configuration class.

    - Copy and paste the predicates from the data flow configuration for the standard query to the ATM configuration class.
      For NoSQL injection, copy the predicates from the data flow configuration within `NosqlInjection.qll` to the `NosqlInjectionATMConfig` class.
    - Rename the `isSource` and `isSink` predicates to `isKnownSource` and `isKnownSink` respectively.
    - Add the required import statements alongside the other import statements in the boosted query file.
      For NoSQL injection, add `import semmle.javascript.security.TaintedObject` and `import semmle.javascript.security.dataflow.NosqlInjectionCustomizations::NosqlInjection` alongside the other import statements in `NosqlInjectionATM.ql`.

    Your query should now look like the contents of the [`step2.ql` query](resources/step2.ql).

3. Test both `isKnownSource` predicates and the `isKnownSink` predicate by [quick-evaluating them](https://help.semmle.com/codeql/codeql-for-vscode/procedures/using-extension.html#running-a-specific-part-of-a-query-or-library) with CodeQL for VS Code and checking that they have results.
    There must be at least one known source and known sink in the database, otherwise ATM will not produce any results.

4. Check whether the standard query has an `isAdditionalFlowStep` or `isAdditionalTaintStep` predicate defined in its data flow configuration.

    For some standard queries, the additional flow steps defined within these predicates will only work with modeled objects.
    However ATM will generate results including non-modeled objects, so in these circumstances, boosting will fail.
    To make sure the query is boosted properly, we need to explicitly include non-modeled objects in the additional flow steps.

    For NoSQL injection, the standard query includes the following logic in the `isAdditionalFlowStep` predicate to propagate taint flow from a property of a query object to the query object itself:

    ```codeql
    // additional flow step to track taint through NoSQL query objects
    inlbl = TaintedObject::label() and
    outlbl = TaintedObject::label() and
    exists(NoSQL::Query query, DataFlow::SourceNode queryObj |
      queryObj.flowsToExpr(query) and
      queryObj.flowsTo(trg) and
      src = queryObj.getAPropertyWrite().getRhs()
    )
    ```

    This additional flow step only propagates taint within objects modeled by the CodeQL library for JavaScript.
    We therefore need to relax the additional flow step to include objects predicted by ATM. 
  
    One of the ways that we can do this is by observing that query objects, both modeled and unmodeled, are sinks for NoSQL injection.
    Specifically, we can relax the additional flow step such that all objects that are sinks, rather than just all modeled query objects, are included as possible targets `trg` of the flow step.
    
    Relax the additional flow step for NoSQL injection by adding the following QL code to the bottom of the `isAdditionalFlowStep` predicate within the `NosqlInjectionATMConfig` class:

    ```codeql
    or
    // relaxed version of previous step to track taint through predicted NoSQL query objects
    any(ATM::Configuration cfg).isSink(trg) and
    src = trg.(DataFlow::SourceNode).getAPropertyWrite().getRhs()
    ```

    Your query should now look like the [`step3.ql` query](resources/step3.ql).

### Creating a sink endpoint filter

We have now defined all the known endpoints for our boosted query and included non-modeled objects in any additional flow steps.
The next step is to create an endpoint filter.
This will exclude candidate endpoints predicted by machine learning that we can easily recognize as incorrect.

1. Consider the main properties that the sinks for the security query you'd like to define have in common.
    For NoSQL injection, a typical sink looks like the query object `{ password }` in the following snippet:

    ```js
    MongoClient.connect("mongodb://someHost:somePort/", (err, client) => {
      if (err) throw err;
      let db = client.db("someDbName");
      db.collection("someCollection").find({ password }).toArray((err, result) => {
        if (err) throw err;
        console.log(result);
        client.close();
      });
    });
    ```

    One of the common properties of these sinks is that they are typically arguments to API calls.
    We therefore filter out candidate sinks that don't meet this criterion.

2. Add logic to the `isEffectiveSink` predicate such that it holds only when the data flow node `candidateSink` has these properties.
    For NoSQL injection, add the following logic which restricts sinks to be arguments to API calls using the `EndpointFilterUtils` library:

    ```codeql
    override predicate isEffectiveSink(DataFlow::Node candidateSink) {
      exists(DataFlow::CallNode call |
        call = EndpointFilterUtils::getALikelyExternalLibraryCall() and
        candidateSink = call.getAnArgument()
      )
    }
    ```

    Your query should now look like the [`step4.ql` query](resources/step4.ql).

3. Run the boosted query and examine the results.
    Look for common sources of false positive results.
    In the example project, one of the sources of false positives is the arguments to logging calls such as `Logger.log`, for instance:

    ```js
    // Logger.log = (message, ...objs) => console.log(message, objs);
    Logger.log("/updateName called with new name", req.body.name);
    ```

4. Add additional logic to the `isEffectiveSink` predicate to remove common sources of false positives.
    In the example project, you can remove arguments to likely logging calls from the set of effective sinks using the `CoreKnowledge` library:

    ```codeql
    override predicate isEffectiveSink(DataFlow::Node candidateSink) {
      candidateSink = EndpointFilterUtils::getALikelyExternalLibraryCall().getAnArgument() and
      not (
        // Remove modeled sinks
        CoreKnowledge::isKnownLibrarySink(candidateSink) or
        // Remove common kinds of unlikely sinks
        CoreKnowledge::isKnownStepSrc(candidateSink) or
        CoreKnowledge::isUnlikelySink(candidateSink)
      )
    }
    ```

    Your query should now look like the [`step5.ql` query](resources/step5.ql).

5. Where possible, continue this process to eliminate whole classes of false positives by adding filtering logic to the `isEffectiveSink` predicate.

    In the example project, another source of false positives is the sinks that are arguments to [Express](https://expressjs.com/) API calls such as `res.json`, for instance:

    ```js
    router.post('/updateName', async (req, res) => {
      // ...
      res.json({
        name: req.body.name
      });
    });
    ```

    To remove these, we can use the `HTTP` module from the CodeQL library for JavaScript:

    ```codeql
    override predicate isEffectiveSink(DataFlow::Node candidateSink) {
      candidateSink = EndpointFilterUtils::getALikelyExternalLibraryCall().getAnArgument() and
      not (
        // Remove modeled sinks
        CoreKnowledge::isKnownLibrarySink(candidateSink) or
        // Remove common kinds of unlikely sinks
        CoreKnowledge::isKnownStepSrc(candidateSink) or
        CoreKnowledge::isUnlikelySink(candidateSink) or
        // Remove calls to APIs that aren't relevant to NoSQL injection
        call.getReceiver().asExpr() instanceof HTTP::RequestExpr or
        call.getReceiver().asExpr() instanceof HTTP::ResponseExpr
      )
    }
    ```

    Your query should now look like the [`step6.ql` query](resources/step6.ql).

## Conclusion

Congratulations, you've boosted your first security query!
Run it and take a look at the new alerts.
Higher scores typically indicate a higher chance of a true positive.
Note that the boosted query does not include results from the standard query.
For full coverage, the boosted query and the standard query should be run together.

Here are three ways you can improve your boosted query further:

- You can remove more false positives by refining the sink endpoint filter.
- You can add more true positives by adding more known endpoints.
- You can also recover more true positives by implementing further additional flow steps.

## Further information

### Improving your boosted query further

To see an example of how to further improve your boosted query, check out the [boosted NoSQL injection query](https://github.com/github/codeql/blob/experimental/atm/javascript/ql/src/experimental/adaptivethreatmodeling/NosqlInjectionATM.ql) provided with the ATM libraries.
One of the ways in which this query improves on the query described in this guide is by implementing further additional flow steps to recover more true positives.
Specifically, this query generalizes the additional flow step described earlier in this guide.
The additional flow step now includes more complex query objects, such as in the following code:

```js
const notes = await Note.find({
  $or: [
    {
      isPublic: true
    },
    {
      ownerToken: req.body.token
    }
  ]
}).exec();
```

### Including the standard results

By default, ATM only provides results when there is data flow from a known source to an effective sink.
This means that the results of a boosted query do not contain results from the standard query.

To get all of the results in the boosted query:

1. Remove the sinks that are relevant to NoSQL injection from the sink endpoint filter.
    You can do this by replacing `CoreKnowledge::isKnownLibrarySink(candidateSink)` with `(CoreKnowledge::isKnownLibrarySink(candidateSink) and not candidateSink instanceof NosqlInjection::Sink)` in the `isEffectiveSink` predicate.

2. Remove the standard results filter from the [select clause](https://help.semmle.com/QL/ql-handbook/queries.html#select-clauses).
    You can do this by deleting the line containing the expression `isFlowLikelyInBaseQuery(source.getNode(), sink.getNode())`.

Your final query should look like the [`optional-step6-all-results.ql`](./resources/optional-step6-all-results.ql) query.
