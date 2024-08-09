/**
 * @name Generate flow models
 * @description Queries to generate source, sink, summary and type models.
 * @kind table
 * @id rb/utils/modeleditor/generate-model
 * @tags modeleditor generate-model framework-mode
 */

private import internal.Types
private import internal.Summaries
private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow
private import codeql.ruby.frameworks.data.ModelsAsData

module ModelExportConfig implements ModelExportSig {
  predicate shouldContain(API::Node node) {
    exists(DataFlow::MethodNode method | node = method.backtrack())
  }

  predicate shouldContainType(string type) {
    type = any(DataFlow::ModuleNode mod).getQualifiedName() + ["", "!"]
  }
}

module ExportedModel = ModelExport<ModelExportConfig>;

query predicate typeModel = ExportedModel::typeModel/3;

/**
 * Holds if the value at `(type, path)` should be seen as a flow
 * source of the given `kind`.
 *
 * The kind `remote` represents a general remote flow source.
 */
query predicate sourceModel(string type, string path, string kind) { none() }

/**
 * Holds if the value at `(type, path)` should be seen as a sink
 * of the given `kind`.
 */
query predicate sinkModel(string type, string path, string kind) { none() }

/**
 * Holds if calls to `(type, path)`, the value referred to by `input`
 * can flow to the value referred to by `output`.
 *
 * `kind` should be either `value` or `taint`, for value-preserving or taint-preserving steps,
 * respectively.
 */
query predicate summaryModel(string type, string path, string input, string output, string kind) {
  Summaries::summaryModel(type, path, input, output, kind)
  or
  ExportedModel::summaryModel(type, path, input, output, kind)
}

/**
 * Holds if `path` can be substituted for a token `TypeVar[name]`.
 */
query predicate typeVariableModel(string name, string path) { none() }
