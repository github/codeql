/**
 * Provides classes for contributing a model, or using the interpreted results
 * of a model represented as data.
 *
 * - Use the `ModelInput` module to contribute new models.
 * - Use the `ModelOutput` module to access the model results in terms of API nodes.
 *
 * The package name refers to an NPM package name or a path within a package name such as `lodash/extend`.
 * The string `global` refers to the global object (whether it came from the `global` package or not).
 *
 * A `(package, type)` tuple may refer to the exported type named `type` from the NPM package `package`.
 * For example, `(express, Request)` would match a parameter below due to the type annotation:
 * ```ts
 * import * as express from 'express';
 * export function handler(req: express.Request) { ... }
 * ```
 */

private import javascript
private import internal.ApiGraphModels as Shared
private import internal.ApiGraphModelsSpecific as Specific
import Shared::ModelInput as ModelInput
import Shared::ModelOutput as ModelOutput

/**
 * A remote flow source originating from a CSV source row.
 */
private class RemoteFlowSourceFromCsv extends RemoteFlowSource {
  RemoteFlowSourceFromCsv() { this = ModelOutput::getASourceNode("remote").getAnImmediateUse() }

  override string getSourceType() { result = "Remote flow" }
}

/**
 * Like `ModelOutput::summaryStep` but with API nodes mapped to data-flow nodes.
 */
private predicate summaryStepNodes(DataFlow::Node pred, DataFlow::Node succ, string kind) {
  exists(API::Node predNode, API::Node succNode |
    Specific::summaryStep(predNode, succNode, kind) and
    pred = predNode.getARhs() and
    succ = succNode.getAnImmediateUse()
  )
}

/** Data flow steps induced by summary models of kind `value`. */
private class DataFlowStepFromSummary extends DataFlow::SharedFlowStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    summaryStepNodes(pred, succ, "value")
  }
}

/** Taint steps induced by summary models of kind `taint`. */
private class TaintStepFromSummary extends TaintTracking::SharedTaintStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    summaryStepNodes(pred, succ, "taint")
  }
}
