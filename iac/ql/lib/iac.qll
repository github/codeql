import codeql.Locations
import codeql.files.FileSystem
import codeql.iac.Comments
import codeql.iac.Dependencies
// Azure
import codeql.iac.azure.ARM
import codeql.iac.azure.Pipelines
// AWS
import codeql.iac.aws.CloudFormation
// Containers / Docker
import codeql.iac.containers.Containers
import codeql.iac.containers.Images
// Compose
import codeql.iac.compose.Compose
// Kubernetes
import codeql.iac.kubernetes.Kubernetes
// HelmCharts
import codeql.iac.helmcharts.HelmChart
// Terraform / HCL
import hcl
// OpenAPI / Swagger
import codeql.iac.openapi.OpenApi
// YAML
import codeql.iac.YAML
import codeql.iac.YamlDocumentClassification
