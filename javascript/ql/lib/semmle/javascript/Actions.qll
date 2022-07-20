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
  /** A YAML node in a GitHub Actions workflow file. */
  private class Node extends YAMLNode {
    Node() {
      this.getLocation()
          .getFile()
          .getRelativePath()
          .regexpMatch("(^|.*/)\\.github/workflows/.*\\.yml$")
    }
  }

  /**
   * An Actions workflow. This is a mapping at the top level of an Actions YAML workflow file.
   * See https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions.
   */
  class Workflow extends Node, YAMLDocument, YAMLMapping {
    /** Gets the `jobs` mapping from job IDs to job definitions in this workflow. */
    YAMLMapping getJobs() { result = this.lookup("jobs") }

    /** Gets the name of the workflow. */
    string getName() { result = this.lookup("name").(YAMLString).getValue() }

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
  class On extends YAMLNode, YAMLMappingLikeNode {
    Workflow workflow;

    On() { workflow.lookup("on") = this }

    /** Gets the workflow that this trigger is in. */
    Workflow getWorkflow() { result = workflow }
  }

  /**
   * An Actions job within a workflow.
   * See https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobs.
   */
  class Job extends YAMLNode, YAMLMapping {
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
    YAMLString getIdNode() { workflow.getJobs().maps(result, this) }

    /** Gets the human-readable name of this job, if any, as a string. */
    string getName() { result = this.getNameNode().getValue() }

    /** Gets the human-readable name of this job, if any, as a YAML scalar node. */
    YAMLString getNameNode() { result = this.lookup("name") }

    /** Gets the step at the given index within this job. */
    Step getStep(int index) { result.getJob() = this and result.getIndex() = index }

    /** Gets the sequence of `steps` within this job. */
    YAMLSequence getSteps() { result = this.lookup("steps") }

    /** Gets the workflow this job belongs to. */
    Workflow getWorkflow() { result = workflow }

    /** Gets the value of the `if` field in this job, if any. */
    JobIf getIf() { result.getJob() = this }
  }

  /**
   * An `if` within a job.
   * See https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idif.
   */
  class JobIf extends YAMLNode, YAMLScalar {
    Job job;

    JobIf() { job.lookup("if") = this }

    /** Gets the step this field belongs to. */
    Job getJob() { result = job }
  }

  /**
   * A step within an Actions job.
   * See https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idsteps.
   */
  class Step extends YAMLNode, YAMLMapping {
    int index;
    Job job;

    Step() { this = job.getSteps().getElement(index) }

    /** Gets the 0-based position of this step within the sequence of `steps`. */
    int getIndex() { result = index }

    /** Gets the job this step belongs to. */
    Job getJob() { result = job }

    /** Gets the value of the `uses` field in this step, if any. */
    Uses getUses() { result.getStep() = this }

    /** Gets the value of the `run` field in this step, if any. */
    Run getRun() { result.getStep() = this }

    /** Gets the value of the `if` field in this step, if any. */
    StepIf getIf() { result.getStep() = this }

    /** Gets the ID of this step, if any. */
    string getId() { result = this.lookup("id").(YAMLString).getValue() }
  }

  /**
   * An `if` within a step.
   * See https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idstepsif.
   */
  class StepIf extends YAMLNode, YAMLScalar {
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
  class Uses extends YAMLNode, YAMLScalar {
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
  class With extends YAMLNode, YAMLMapping {
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
  class Ref extends YAMLNode, YAMLString {
    With with;

    Ref() { with.lookup("ref") = this }

    /** Gets the `with` field this field belongs to. */
    With getWith() { result = with }
  }

  /**
   * A `run` field within an Actions job step, which runs command-line programs using an operating system shell.
   * See https://docs.github.com/en/free-pro-team@latest/actions/reference/workflow-syntax-for-github-actions#jobsjob_idstepsrun.
   */
  class Run extends YAMLNode, YAMLString {
    Step step;

    Run() { step.lookup("run") = this }

    /** Gets the step that executes this `run` command. */
    Step getStep() { result = step }

    /**
     * Holds if `${{ e }}` is a GitHub Actions expression evaluated within this `run` command.
     * See https://docs.github.com/en/free-pro-team@latest/actions/reference/context-and-expression-syntax-for-github-actions.
     * Only finds simple expressions like `${{ github.event.comment.body }}`, where the expression contains only alphanumeric characters, underscores, dots, or dashes.
     * Does not identify more complicated expressions like `${{ fromJSON(env.time) }}`, or ${{ format('{{Hello {0}!}}', github.event.head_commit.author.name) }}
     */
    string getASimpleReferenceExpression() {
      // We use `regexpFind` to obtain *all* matches of `${{...}}`,
      // not just the last (greedy match) or first (reluctant match).
      result =
        this.getValue()
            .regexpFind("\\$\\{\\{\\s*[A-Za-z0-9_\\.\\-]+\\s*\\}\\}", _, _)
            .regexpCapture("\\$\\{\\{\\s*([A-Za-z0-9_\\.\\-]+)\\s*\\}\\}", 1)
    }
  }
}
