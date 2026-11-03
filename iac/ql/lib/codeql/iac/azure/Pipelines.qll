private import codeql.iac.YAML
private import codeql.files.FileSystem

module AzurePipelines {
  private predicate hasPipelineBaseName(YamlDocument doc) {
    doc.getFile().getBaseName() = ["azure-pipelines.yml", "azure-pipelines.yaml"]
  }

  private predicate hasPipelineShape(YamlMapping doc) {
    exists(doc.lookup("steps")) or
    exists(doc.lookup("jobs")) or
    exists(doc.lookup("stages")) or
    exists(doc.lookup("extends"))
  }

  /**
   * Holds if `doc` is a GitHub Actions workflow rather than an Azure DevOps
   * pipeline.
   *
   * GitHub Actions workflows live under `.github/workflows/` and are required
   * to declare an `on:` trigger, whereas Azure DevOps pipelines are triggered
   * with `trigger:`/`pr:` and never use a top-level `on:` key. Both formats
   * share `jobs:`/`steps:` keys, so without this exclusion a workflow would be
   * misclassified as a pipeline by `hasPipelineShape`.
   */
  private predicate isGitHubActionsWorkflow(YamlDocument doc) {
    doc.getFile().getRelativePath().matches("%.github/workflows/%")
    or
    exists(doc.(YamlMapping).lookup("on"))
  }

  /**
   * Azure DevOps Pipeline file or referenced template.
   */
  class Document extends YamlNode, YamlDocument, YamlMapping {
    Document() {
      this.getFile().getExtension() = ["yml", "yaml"] and
      (hasPipelineBaseName(this) or hasPipelineShape(this)) and
      not isGitHubActionsWorkflow(this)
    }

    override string toString() { result = "Azure DevOps Pipeline" }

    /**
     * Gets the top-level trigger-like entry named `name`, if any.
     */
    YamlValue getTrigger(string name) { result = this.lookup(name) }

    /**
     * Gets the pipeline pool, if any.
     */
    Pool getPool() { result = this.lookup("pool") }

    /**
     * Gets a pipeline parameter, if any.
     */
    Parameter getAParameter() { result = this.lookup("parameters").getAChild() }

    /**
     * Gets a pipeline variable, if any.
     */
    Variable getAVariable() { result = this.lookup("variables").getAChild() }

    /**
     * Gets the pipeline variable with the given name, if any.
     */
    YamlValue getVariable(string name) {
      exists(Variable var | var = this.getAVariable() and var.getName() = name |
        result = var.getValue()
      )
    }

    /**
     * Gets a pipeline step, if any.
     */
    Step getAStep() { result.getEnclosingDocument() = this }

    /**
     * Gets a pipeline stage, if any.
     */
    Stage getAStage() { result = this.lookup("stages").getAChild() }

    /**
     * Gets a pipeline job, if any.
     */
    Job getAJob() {
      result = this.lookup("jobs").getAChild()
      or
      result = this.getAStage().getAJob()
    }

    /**
     * Gets a pipeline repository resource, if any.
     */
    RepositoryResource getARepositoryResource() { result.getEnclosingDocument() = this }

    /**
     * Gets a pipeline resource, if any.
     */
    PipelineResource getAPipelineResource() { result.getEnclosingDocument() = this }

    /**
     * Gets a pipeline task step, if any.
     */
    Task getATaskStep() { result = this.getAStep().(Task) }

    /**
     * Gets a pipeline script step, if any.
     */
    Script getAScriptStep() { result = this.getAStep().(Script) }
  }

  /**
   * Azure DevOps Pipeline parameter.
   */
  class Parameter extends YamlNode, YamlMapping {
    Parameter() { exists(Document document | document.lookup("parameters").getChild(_) = this) }

    override string toString() { result = this.getName() }

    /**
     * Gets the parameter name.
     */
    string getName() { result = yamlToString(this.lookup("name")) }

    /**
     * Gets the parameter type, if any.
     */
    string getType() { result = yamlToString(this.lookup("type")) }

    /**
     * Gets the parameter default value, if any.
     */
    YamlValue getDefault() { result = this.lookup("default") }

    /**
     * Gets an allowed value for the parameter, if any.
     */
    YamlValue getAnAllowedValue() { result = this.lookup("values").getAChild() }
  }

  /**
   * Azure DevOps Pipeline stage.
   */
  class Stage extends YamlNode, YamlMapping {
    Stage() { exists(Document document | document.lookup("stages").getAChildNode() = this) }

    override string toString() { result = this.getName() }

    /**
     * Gets the stage name.
     */
    string getName() { result = yamlToString(this.lookup("stage")) }

    /**
     * Gets a job in the stage, if any.
     */
    Job getAJob() { result = this.lookup("jobs").getAChild() }

    /**
     * Gets the stage condition, if any.
     */
    YamlValue getCondition() { result = this.lookup("condition") }
  }

  /**
   * Azure DevOps Pipeline job.
   */
  class Job extends YamlNode, YamlMapping {
    Job() {
      exists(Document document | document.lookup("jobs").getAChildNode() = this)
      or
      exists(Stage stage | stage.lookup("jobs").getAChildNode() = this)
    }

    override string toString() { result = this.getName() }

    /**
     * Gets the job name.
     */
    string getName() {
      result = yamlToString(this.lookup("job"))
      or
      result = yamlToString(this.lookup("deployment"))
    }

    /**
     * Gets the job pool, if any.
     */
    Pool getPool() { result = this.lookup("pool") }

    /**
     * Gets a step in the job, if any.
     */
    Step getAStep() { result = this.lookup("steps").getAChild() }

    /**
     * Gets the job condition, if any.
     */
    YamlValue getCondition() { result = this.lookup("condition") }
  }

  /**
   * Azure DevOps Pipeline deployment job.
   */
  class DeploymentJob extends Job {
    DeploymentJob() { exists(this.lookup("deployment")) }
  }

  /**
   * Azure DevOps Pipeline pool.
   *
   * https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/pool
   */
  class Pool extends YamlNode, YamlMapping {
    Pool() {
      exists(Document document | document.lookup("pool") = this)
      or
      exists(Job job | job.lookup("pool") = this)
    }

    /**
     * Gets the pool name, if any.
     */
    string getName() { result = yamlToString(this.lookup("name")) }

    /**
     * Gets the pool VM image, if any.
     */
    string getVmImage() { result = yamlToString(this.lookup("vmImage")) }

    /**
     * Gets the pool demands, if any.
     */
    string getADemand() { result = yamlToString(this.lookup("demands")) }
  }

  /**
   * Azure DevOps Pipeline variables.
   *
   * https://learn.microsoft.com/en-us/azure/devops/pipelines/process/variables
   */
  class Variable extends YamlNode, YamlMapping {
    Variable() {
      exists(Document document | document.lookup("variables").getChild(_) = this)
      or
      exists(Stage stage | stage.lookup("variables").getChild(_) = this)
      or
      exists(Job job | job.lookup("variables").getChild(_) = this)
    }

    override string toString() { result = this.getName() }

    /**
     * Get the variable name.
     */
    string getName() { result = yamlToString(this.lookup("name")) }

    /**
     * Gets the variable value, if any.
     */
    YamlValue getValue() { result = this.lookup("value") }
  }

  /**
   * Azure DevOps Pipeline step.
   *
   * https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/steps
   */
  class Step extends YamlNode, YamlMapping {
    Step() {
      exists(Document document | document.lookup("steps").getAChildNode() = this)
      or
      exists(Job job | job.lookup("steps").getAChildNode() = this)
    }

    override string toString() { result = this.getDisplayName() }

    /**
     * Gets the enclosing Azure DevOps Pipeline document.
     */
    Document getEnclosingDocument() {
      result.lookup("steps").getAChildNode() = this
      or
      this.getFile() = result.getFile()
    }

    /**
     * Gets the step display name, if any.
     */
    string getDisplayName() { result = yamlToString(this.lookup("displayName")) }

    /**
     * Gets the step type based on its defining key, if any.
     */
    string getType() {
      exists(this.lookup("task")) and result = "task"
      or
      exists(this.lookup("script")) and result = "script"
      or
      exists(this.lookup("bash")) and result = "bash"
      or
      exists(this.lookup("powershell")) and result = "powershell"
      or
      exists(this.lookup("pwsh")) and result = "pwsh"
      or
      exists(this.lookup("checkout")) and result = "checkout"
      or
      exists(this.lookup("template")) and result = "template"
    }
  }

  /**
   * Azure DevOps Pipeline task step.
   */
  class Task extends Step {
    Task() { this.getType() = "task" }

    /**
     * Get the task name.
     */
    string getName() { result = yamlToString(this.lookup("task")) }
  }

  class TaskInputs extends YamlNode, YamlMapping {
    private Task task;

    TaskInputs() { task.lookup("inputs") = this }

    /**
     * Gets the input named `name`, if any.
     */
    YamlValue getInput(string name) { result = this.lookup(name) }
  }

  /**
   * Azure DevOps Pipeline script step.
   */
  class Script extends Step {
    Script() { this.getType() = ["script", "bash", "powershell", "pwsh"] }

    /**
     * Gets the script step kind.
     */
    string getScriptKind() { result = this.getType() }

    /**
     * Gets the inline script content.
     */
    YamlValue getScriptContent() { result = this.lookup(this.getScriptKind()) }
  }

  /**
   * Azure DevOps Pipeline checkout step.
   */
  class Checkout extends Step {
    Checkout() { this.getType() = "checkout" }

    /**
     * Gets the checkout target.
     */
    string getRepository() { result = yamlToString(this.lookup("checkout")) }

    /**
     * Gets the `persistCredentials` setting, if any.
     */
    YamlValue getPersistCredentials() { result = this.lookup("persistCredentials") }
  }

  /**
   * Azure DevOps Pipeline template step.
   */
  class TemplateStep extends Step {
    TemplateStep() { this.getType() = "template" }

    /**
     * Gets the referenced template path.
     */
    string getTemplate() { result = yamlToString(this.lookup("template")) }
  }

  /**
   * Azure DevOps repository resource.
   */
  class RepositoryResource extends YamlNode, YamlMapping {
    RepositoryResource() {
      exists(Document document |
        document.lookup("resources").(YamlMapping).lookup("repositories").getAChildNode() = this
      )
    }

    override string toString() { result = "Repository resource '" + this.getAlias() + "'" }

    /**
     * Gets the enclosing Azure DevOps Pipeline document.
     */
    Document getEnclosingDocument() {
      result.lookup("resources").(YamlMapping).lookup("repositories").getAChildNode() = this
    }

    /**
     * Gets the resource alias.
     */
    string getAlias() { result = yamlToString(this.lookup("repository")) }

    /**
     * Gets the repository name.
     */
    string getName() { result = yamlToString(this.lookup("name")) }

    /**
     * Gets the referenced revision, if any.
     */
    string getRef() { result = yamlToString(this.lookup("ref")) }
  }

  /**
   * Azure DevOps pipeline resource.
   */
  class PipelineResource extends YamlNode, YamlMapping {
    PipelineResource() {
      exists(Document document |
        document.lookup("resources").(YamlMapping).lookup("pipelines").getAChildNode() = this
      )
    }

    override string toString() { result = "Pipeline resource '" + this.getAlias() + "'" }

    /**
     * Gets the enclosing Azure DevOps Pipeline document.
     */
    Document getEnclosingDocument() {
      result.lookup("resources").(YamlMapping).lookup("pipelines").getAChildNode() = this
    }

    /**
     * Gets the resource alias.
     */
    string getAlias() { result = yamlToString(this.lookup("pipeline")) }

    /**
     * Gets the source pipeline.
     */
    string getSource() { result = yamlToString(this.lookup("source")) }

    /**
     * Gets the branch selector, if any.
     */
    string getBranch() { result = yamlToString(this.lookup("branch")) }
  }
}
