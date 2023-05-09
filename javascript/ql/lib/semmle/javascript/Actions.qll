/**
 * Libraries for modeling GitHub Actions workflow files written in YAML.
 * See https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions.
 */

import javascript

/**
 * Libraries for modeling GitHub Actions workflow files written in YAML.
 * See https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions.
 */
module Actions {
  /** A YAML node in a GitHub Actions workflow or a custom composite action file. */
  private class Node extends YamlNode {
    Node() {
      exists(File f |
        f = this.getLocation().getFile() and
        (
          f.getRelativePath().regexpMatch("(^|.*/)\\.github/workflows/.*\\.ya?ml$")
          or
          f.getBaseName() = ["action.yml", "action.yaml"]
        )
      )
    }
  }

  /**
   * A custom composite action. This is a mapping at the top level of an Actions YAML action file.
   * See https://docs.github.com/en/actions/creating-actions/metadata-syntax-for-github-actions.
   */
  class CompositeAction extends Node, YamlDocument, YamlMapping {
    CompositeAction() {
      this.getFile().getBaseName() = ["action.yml", "action.yaml"] and
      this.lookup("runs").(YamlMapping).lookup("using").(YamlScalar).getValue() = "composite"
    }

    /** Gets the `runs` mapping. */
    Runs getRuns() { result = this.lookup("runs") }
  }

  /**
   * An `runs` mapping in a custom composite action YAML.
   * See https://docs.github.com/en/actions/creating-actions/metadata-syntax-for-github-actions#runs
   */
  class Runs extends StepsContainer {
    CompositeAction action;

    Runs() { action.lookup("runs") = this }

    /** Gets the action that this `runs` mapping is in. */
    CompositeAction getAction() { result = action }

    /** Gets the `using` mapping. */
    Using getUsing() { result = this.lookup("using") }
  }

  /**
   * The parent class of the class that can contain `steps` mappings. (`Job` or `Runs` currently.)
   */
  abstract class StepsContainer extends YamlNode, YamlMapping {
    /** Gets the sequence of `steps` within this YAML node. */
    YamlSequence getSteps() { result = this.lookup("steps") }
  }

  /**
   * A `using` mapping in a custom composite action YAML.
   */
  class Using extends YamlNode, YamlScalar {
    Runs runs;

    Using() { runs.lookup("using") = this }

    /** Gets the `runs` mapping that this `using` mapping is in. */
    Runs getRuns() { result = runs }
  }

  /**
   * An Actions workflow. This is a mapping at the top level of an Actions YAML workflow file.
   * See https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions.
   */
  class Workflow extends Node, YamlDocument, YamlMapping {
    /** Gets the `jobs` mapping from job IDs to job definitions in this workflow. */
    YamlMapping getJobs() { result = this.lookup("jobs") }

    /** Gets the 'global' `env` mapping in this workflow. */
    WorkflowEnv getEnv() { result = this.lookup("env") }

    /** Gets the name of the workflow. */
    string getName() { result = this.lookup("name").(YamlString).getValue() }

    /** Gets the name of the workflow file. */
    string getFileName() { result = this.getFile().getBaseName() }

    /** Gets the `on:` in this workflow. */
    On getOn() { result = this.lookup("on") }

    /** Gets the job within this workflow with the given job ID. */
    Job getJob(string jobId) { result.getWorkflow() = this and result.getId() = jobId }
  }

  /**
   * An Actions On trigger within a workflow.
   * See https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#on.
   */
  class On extends YamlNode, YamlMappingLikeNode {
    Workflow workflow;

    On() { workflow.lookup("on") = this }

    /** Gets the workflow that this trigger is in. */
    Workflow getWorkflow() { result = workflow }
  }

  /** A common class for `env` in workflow, job or step. */
  abstract class Env extends YamlNode, YamlMapping { }

  /** A workflow level `env` mapping. */
  class WorkflowEnv extends Env {
    Workflow workflow;

    WorkflowEnv() { workflow.lookup("env") = this }

    /** Gets the workflow this field belongs to. */
    Workflow getWorkflow() { result = workflow }
  }

  /** A job level `env` mapping. */
  class JobEnv extends Env {
    Job job;

    JobEnv() { job.lookup("env") = this }

    /** Gets the job this field belongs to. */
    Job getJob() { result = job }
  }

  /** A step level `env` mapping. */
  class StepEnv extends Env {
    Step step;

    StepEnv() { step.lookup("env") = this }

    /** Gets the step this field belongs to. */
    Step getStep() { result = step }
  }

  /**
   * An Actions job within a workflow.
   * See https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobs.
   */
  class Job extends StepsContainer {
    string jobId;
    Workflow workflow;

    Job() { this = workflow.getJobs().lookup(jobId) }

    /**
     * Gets the ID of this job, as a string.
     * This is the job's key within the `jobs` mapping.
     */
    string getId() { result = jobId }

    /**
     * Gets the ID of this job, as a YAML scalar node.
     * This is the job's key within the `jobs` mapping.
     */
    YamlString getIdNode() { workflow.getJobs().maps(result, this) }

    /** Gets the human-readable name of this job, if any, as a string. */
    string getName() { result = this.getNameNode().getValue() }

    /** Gets the human-readable name of this job, if any, as a YAML scalar node. */
    YamlString getNameNode() { result = this.lookup("name") }

    /** Gets the step at the given index within this job. */
    Step getStep(int index) { result.getJob() = this and result.getIndex() = index }

    /** Gets the `env` mapping in this job. */
    JobEnv getEnv() { result = this.lookup("env") }

    /** Gets the workflow this job belongs to. */
    Workflow getWorkflow() { result = workflow }

    /** Gets the value of the `if` field in this job, if any. */
    JobIf getIf() { result.getJob() = this }

    /** Gets the value of the `runs-on` field in this job. */
    JobRunson getRunsOn() { result.getJob() = this }
  }

  /**
   * An `if` within a job.
   * See https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idif.
   */
  class JobIf extends YamlNode, YamlScalar {
    Job job;

    JobIf() { job.lookup("if") = this }

    /** Gets the step this field belongs to. */
    Job getJob() { result = job }
  }

  /**
   * A `runs-on` within a job.
   * See https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idruns-on.
   */
  class JobRunson extends YamlNode, YamlScalar {
    Job job;

    JobRunson() { job.lookup("runs-on") = this }

    /** Gets the step this field belongs to. */
    Job getJob() { result = job }
  }

  /**
   * A step within an Actions job.
   * See https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idsteps.
   */
  class Step extends YamlNode, YamlMapping {
    int index;
    StepsContainer parent;

    Step() { this = parent.getSteps().getElement(index) }

    /** Gets the 0-based position of this step within the sequence of `steps`. */
    int getIndex() { result = index }

    /** Gets the `job` this step belongs to, if the step belongs to a `job` in a workflow. Has no result if the step belongs to `runs` in a custom composite action. */
    Job getJob() { result = parent }

    /** Gets the `runs` this step belongs to, if the step belongs to a `runs` in a custom composite action. Has no result if the step belongs to a `job` in a workflow. */
    Runs getRuns() { result = parent }

    /** Gets the value of the `uses` field in this step, if any. */
    Uses getUses() { result.getStep() = this }

    /** Gets the value of the `run` field in this step, if any. */
    Run getRun() { result.getStep() = this }

    /** Gets the value of the `if` field in this step, if any. */
    StepIf getIf() { result.getStep() = this }

    /** Gets the value of the `env` field in this step, if any. */
    StepEnv getEnv() { result = this.lookup("env") }

    /** Gets the ID of this step, if any. */
    string getId() { result = this.lookup("id").(YamlString).getValue() }
  }

  /**
   * An `if` within a step.
   * See https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idstepsif.
   */
  class StepIf extends YamlNode, YamlScalar {
    Step step;

    StepIf() { step.lookup("if") = this }

    /** Gets the step this field belongs to. */
    Step getStep() { result = step }
  }

  /**
   * Gets a regular expression that parses an `owner/repo@version` reference within a `uses` field in an Actions job step.
   * The capture groups are:
   * 1: The owner of the repository where the Action comes from, e.g. `actions` in `actions/checkout@v2`
   * 2: The name of the repository where the Action comes from, e.g. `checkout` in `actions/checkout@v2`.
   * 3: The version reference used when checking out the Action, e.g. `v2` in `actions/checkout@v2`.
   */
  private string usesParser() { result = "([^/]+)/([^/@]+)@(.+)" }

  /**
   * A `uses` field within an Actions job step, which references an action as a reusable unit of code.
   * See https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idstepsuses.
   *
   * For example:
   * ```
   * uses: actions/checkout@v2
   * ```
   *
   * Does not handle local repository references, e.g. `.github/actions/action-name`.
   */
  class Uses extends YamlNode, YamlScalar {
    Step step;

    Uses() { step.lookup("uses") = this }

    /** Gets the step this field belongs to. */
    Step getStep() { result = step }

    /** Gets the owner and name of the repository where the Action comes from, e.g. `actions/checkout` in `actions/checkout@v2`. */
    string getGitHubRepository() {
      result =
        this.getValue().regexpCapture(usesParser(), 1) + "/" +
          this.getValue().regexpCapture(usesParser(), 2)
    }

    /** Gets the version reference used when checking out the Action, e.g. `v2` in `actions/checkout@v2`. */
    string getVersion() { result = this.getValue().regexpCapture(usesParser(), 3) }
  }

  /**
   * A `with` field within an Actions job step, which references an action as a reusable unit of code.
   * See https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idstepswith.
   *
   * For example:
   * ```
   * with:
   *   arg1: 1
   *   arg2: abc
   * ```
   */
  class With extends YamlNode, YamlMapping {
    Step step;

    With() { step.lookup("with") = this }

    /** Gets the step this field belongs to. */
    Step getStep() { result = step }
  }

  /**
   * A `ref:` field within an Actions `with:` specific to `actions/checkout` action.
   *
   * For example:
   * ```
   * uses: actions/checkout@v2
   * with:
   *   ref: ${{ github.event.pull_request.head.sha }}
   * ```
   */
  class Ref extends YamlNode, YamlString {
    With with;

    Ref() { with.lookup("ref") = this }

    /** Gets the `with` field this field belongs to. */
    With getWith() { result = with }
  }

  /**
   * Holds if `${{ e }}` is a GitHub Actions expression evaluated within this YAML string.
   * See https://docs.github.com/en/free-pro-team@latest/actions/reference/context-and-expression-syntax-for-github-actions.
   * Only finds simple expressions like `${{ github.event.comment.body }}`, where the expression contains only alphanumeric characters, underscores, dots, or dashes.
   * Does not identify more complicated expressions like `${{ fromJSON(env.time) }}`, or ${{ format('{{Hello {0}!}}', github.event.head_commit.author.name) }}
   */
  string getASimpleReferenceExpression(YamlString node) {
    // We use `regexpFind` to obtain *all* matches of `${{...}}`,
    // not just the last (greedy match) or first (reluctant match).
    result =
      node.getValue()
          .regexpFind("\\$\\{\\{\\s*[A-Za-z0-9_\\[\\]\\*\\(\\)\\.\\-]+\\s*\\}\\}", _, _)
          .regexpCapture("\\$\\{\\{\\s*([A-Za-z0-9_\\[\\]\\*\\((\\)\\.\\-]+)\\s*\\}\\}", 1)
  }

  /** Extracts the 'name' part from env.name */
  bindingset[name]
  string getEnvName(string name) { result = name.regexpCapture("env\\.([A-Za-z0-9_]+)", 1) }

  /**
   * A `run` field within an Actions job step, which runs command-line programs using an operating system shell.
   * See https://docs.github.com/en/free-pro-team@latest/actions/reference/workflow-syntax-for-github-actions#jobsjob_idstepsrun.
   */
  class Run extends YamlNode, YamlString {
    Step step;

    Run() { step.lookup("run") = this }

    /** Gets the step that executes this `run` command. */
    Step getStep() { result = step }
  }
}
