/**
 * Provides YAML document classification shared across IaC YAML query families.
 *
 * This library identifies the broad document kind of a YAML document (Azure
 * DevOps Pipelines, Kubernetes/Helm, Compose, OpenAPI, or CloudFormation) and
 * excludes content that is out of scope for YAML-focused IaC queries even
 * though it may be reachable through the same YAML abstract syntax tree:
 *
 * - JSON files. The extractor represents JSON using the same node types as
 *   YAML, since JSON is a syntactic subset of YAML. Callers that only intend
 *   to analyze literal YAML syntax must not rely on node type alone.
 * - Azure Resource Manager (ARM) templates. ARM templates are JSON by
 *   default (`azuredeploy.json`), but can also carry a `.yaml` extension
 *   while keeping the ARM `$schema` marker, so the exclusion is schema-based
 *   rather than purely extension-based.
 *
 * Terraform, HCL, and Bicep are not represented as `YamlNode`s at all in this
 * extractor, so no additional exclusion is required for them here.
 */

import iac
private import codeql.iac.YAML
private import codeql.iac.azure.Pipelines
private import codeql.iac.helmcharts.HelmChart
private import codeql.iac.compose.Compose
private import codeql.iac.openapi.OpenApi
private import codeql.iac.aws.CloudFormation

module YamlDocumentClassification {
  /**
   * A YAML document whose source file uses a YAML extension (`.yml` or
   * `.yaml`), as opposed to a JSON file that happens to be representable by
   * the same node types.
   */
  class YamlSyntaxDocument extends YamlNode, YamlDocument, YamlMapping {
    YamlSyntaxDocument() { this.getFile().getExtension() = ["yml", "yaml"] }
  }

  /**
   * Holds if `doc` carries the Azure Resource Manager (ARM) template schema
   * marker. ARM templates are out of scope for YAML-focused IaC queries even
   * when authored with a `.yaml` extension.
   */
  private predicate hasArmSchemaMarker(YamlSyntaxDocument doc) {
    yamlToString(doc.lookup("$schema")).matches("%schema.management.azure.com%")
  }

  /**
   * The kind of a supported in-scope YAML document.
   */
  class DocumentKind extends string {
    DocumentKind() {
      this = ["ado-pipeline", "kubernetes-helm", "compose", "openapi", "cloudformation"]
    }
  }

  /**
   * Holds if `doc` is a supported, in-scope YAML document of the given
   * `kind`.
   *
   * A document is only classified once its file extension is `.yml`/`.yaml`
   * and it does not carry the ARM template schema marker. Callers writing
   * YAML-only IaC queries should use this predicate, rather than the
   * underlying per-schema `Document` classes directly, so that ARM/JSON
   * content is consistently excluded.
   */
  predicate isSupportedYamlDocument(YamlSyntaxDocument doc, DocumentKind kind) {
    not hasArmSchemaMarker(doc) and
    (
      doc instanceof AzurePipelines::Document and kind = "ado-pipeline"
      or
      doc instanceof HelmChart::Document and kind = "kubernetes-helm"
      or
      doc instanceof Compose::Document and kind = "compose"
      or
      doc instanceof OpenApi::Document and kind = "openapi"
      or
      doc instanceof CloudFormation::Document and kind = "cloudformation"
    )
  }

  /**
   * Gets a supported, in-scope YAML document of any kind.
   */
  YamlSyntaxDocument getASupportedYamlDocument() { isSupportedYamlDocument(result, _) }
}
