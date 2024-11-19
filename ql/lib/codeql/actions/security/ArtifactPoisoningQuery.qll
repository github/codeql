import actions
private import codeql.actions.TaintTracking
import codeql.actions.DataFlow
import codeql.actions.dataflow.FlowSources
import codeql.actions.security.PoisonableSteps
import codeql.actions.security.UntrustedCheckoutQuery

string unzipRegexp() { result = "(unzip|tar)\\s+.*" }

string unzipDirArgRegexp() { result = "(-d|-C)\\s+([^ ]+).*" }

abstract class UntrustedArtifactDownloadStep extends Step {
  abstract string getPath();
}

class GitHubDownloadArtifactActionStep extends UntrustedArtifactDownloadStep, UsesStep {
  GitHubDownloadArtifactActionStep() {
    this.getCallee() = "actions/download-artifact" and
    (
      // By default, the permissions are scoped so they can only download Artifacts within the current workflow run.
      // To elevate permissions for this scenario, you can specify a github-token along with other repository and run identifiers
      this.getArgument("run-id").matches("%github.event.workflow_run.id%") and
      exists(this.getArgument("github-token"))
      or
      // There is an artifact upload step in the same workflow which can be influenced by an attacker on a checkout step
      exists(LocalJob job, SimplePRHeadCheckoutStep checkout, UsesStep upload |
        this.getEnclosingWorkflow().getAJob() = job and
        job.getAStep() = checkout and
        checkout.getATriggerEvent().getName() = "pull_request_target" and
        checkout.getAFollowingStep() = upload and
        upload.getCallee() = "actions/upload-artifact"
      )
    )
  }

  override string getPath() {
    if exists(this.getArgument("path"))
    then result = normalizePath(this.getArgument("path"))
    else result = "GITHUB_WORKSPACE/"
  }
}

class DownloadArtifactActionStep extends UntrustedArtifactDownloadStep, UsesStep {
  DownloadArtifactActionStep() {
    this.getCallee() =
      [
        "dawidd6/action-download-artifact", "marcofaggian/action-download-multiple-artifacts",
        "benday-inc/download-latest-artifact", "blablacar/action-download-last-artifact",
        "levonet/action-download-last-artifact", "bettermarks/action-artifact-download",
        "aochmann/actions-download-artifact", "cytopia/download-artifact-retry-action",
        "alextompkins/download-prior-artifact", "nmerget/download-gzip-artifact",
        "benday-inc/download-artifact", "synergy-au/download-workflow-artifacts-action",
        "ishworkh/docker-image-artifact-download", "ishworkh/container-image-artifact-download",
        "sidx1024/action-download-artifact", "hyperskill/azblob-download-artifact",
        "ma-ve/action-download-artifact-with-retry"
      ] and
    (
      not exists(this.getArgument(["branch", "branch_name"]))
      or
      exists(this.getArgument(["branch", "branch_name"])) and
      this.getArgument("allow_forks") = "true"
    ) and
    (
      not exists(this.getArgument(["commit", "commitHash", "commit_sha"])) or
      not this.getArgument(["commit", "commitHash", "commit_sha"])
          .matches("%github.event.pull_request.head.sha%")
    ) and
    (
      not exists(this.getArgument("event")) or
      not this.getArgument("event") = "pull_request"
    ) and
    (
      not exists(this.getArgument(["run-id", "run_id", "workflow-run-id", "workflow_run_id"])) or
      this.getArgument(["run-id", "run_id", "workflow-run-id", "workflow_run_id"])
          .matches("%github.event.workflow_run.id%")
    ) and
    (
      not exists(this.getArgument("pr")) or
      not this.getArgument("pr")
          .matches(["%github.event.pull_request.number%", "%github.event.number%"])
    )
  }

  override string getPath() {
    if exists(this.getArgument(["path", "download_path"]))
    then result = normalizePath(this.getArgument(["path", "download_path"]))
    else
      if exists(this.getArgument("paths"))
      then result = normalizePath(this.getArgument("paths").splitAt(" "))
      else result = "GITHUB_WORKSPACE/"
  }
}

class LegitLabsDownloadArtifactActionStep extends UntrustedArtifactDownloadStep, UsesStep {
  LegitLabsDownloadArtifactActionStep() {
    this.getCallee() = "Legit-Labs/action-download-artifact" and
    (
      not exists(this.getArgument("branch")) or
      not this.getArgument("branch") = ["main", "master"]
    ) and
    (
      not exists(this.getArgument("commit")) or
      not this.getArgument("commit").matches("%github.event.pull_request.head.sha%")
    ) and
    (
      not exists(this.getArgument("event")) or
      not this.getArgument("event") = "pull_request"
    ) and
    (
      not exists(this.getArgument("run_id")) or
      not this.getArgument("run_id").matches("%github.event.workflow_run.id%")
    ) and
    (
      not exists(this.getArgument("pr")) or
      not this.getArgument("pr").matches("%github.event.pull_request.number%")
    )
  }

  override string getPath() {
    if exists(this.getArgument("path"))
    then result = normalizePath(this.getArgument("path"))
    else result = "GITHUB_WORKSPACE/artifacts"
  }
}

class ActionsGitHubScriptDownloadStep extends UntrustedArtifactDownloadStep, UsesStep {
  string script;

  ActionsGitHubScriptDownloadStep() {
    // eg:
    // - uses: actions/github-script@v6
    //   with:
    //     script: |
    //       let allArtifacts = await github.rest.actions.listWorkflowRunArtifacts({
    //           owner: context.repo.owner,
    //           repo: context.repo.repo,
    //           run_id: context.payload.workflow_run.id,
    //       });
    //       let matchArtifact = allArtifacts.data.artifacts.filter((artifact) => {
    //           return artifact.name == "<ARTEFACT_NAME>"
    //       })[0];
    //       let download = await github.rest.actions.downloadArtifact({
    //           owner: context.repo.owner,
    //           repo: context.repo.repo,
    //           artifact_id: matchArtifact.id,
    //           archive_format: 'zip',
    //       });
    //      var fs = require('fs');
    //      fs.writeFileSync('${{github.workspace}}/test-results.zip', Buffer.from(download.data));
    this.getCallee() = "actions/github-script" and
    this.getArgument("script") = script and
    script.matches("%listWorkflowRunArtifacts(%") and
    script.matches("%downloadArtifact(%") and
    script.matches("%writeFileSync(%") and
    // Filter out artifacts that were created by pull-request.
    not script.matches("%exclude_pull_requests: true%")
  }

  override string getPath() {
    if
      this.getAFollowingStep()
          .(Run)
          .getScript()
          .getACommand()
          .regexpMatch(unzipRegexp() + unzipDirArgRegexp())
    then
      result =
        normalizePath(trimQuotes(this.getAFollowingStep()
                .(Run)
                .getScript()
                .getACommand()
                .regexpCapture(unzipRegexp() + unzipDirArgRegexp(), 3)))
    else
      if this.getAFollowingStep().(Run).getScript().getACommand().regexpMatch(unzipRegexp())
      then result = "GITHUB_WORKSPACE/"
      else none()
  }
}

class GHRunArtifactDownloadStep extends UntrustedArtifactDownloadStep, Run {
  GHRunArtifactDownloadStep() {
    // eg: - run: gh run download ${{ github.event.workflow_run.id }} --repo "${GITHUB_REPOSITORY}" --name "artifact_name"
    this.getScript().getACommand().regexpMatch(".*gh\\s+run\\s+download.*") and
    (
      this.getScript().getACommand().regexpMatch(unzipRegexp()) or
      this.getAFollowingStep().(Run).getScript().getACommand().regexpMatch(unzipRegexp())
    )
  }

  override string getPath() {
    if
      this.getAFollowingStep()
          .(Run)
          .getScript()
          .getACommand()
          .regexpMatch(unzipRegexp() + unzipDirArgRegexp()) or
      this.getScript().getACommand().regexpMatch(unzipRegexp() + unzipDirArgRegexp())
    then
      result =
        normalizePath(trimQuotes(this.getScript()
                .getACommand()
                .regexpCapture(unzipRegexp() + unzipDirArgRegexp(), 3))) or
      result =
        normalizePath(trimQuotes(this.getAFollowingStep()
                .(Run)
                .getScript()
                .getACommand()
                .regexpCapture(unzipRegexp() + unzipDirArgRegexp(), 3)))
    else
      if
        this.getAFollowingStep().(Run).getScript().getACommand().regexpMatch(unzipRegexp()) or
        this.getScript().getACommand().regexpMatch(unzipRegexp())
      then result = "GITHUB_WORKSPACE/"
      else none()
  }
}

class DirectArtifactDownloadStep extends UntrustedArtifactDownloadStep, Run {
  DirectArtifactDownloadStep() {
    // eg:
    // run: |
    //   artifacts_url=${{ github.event.workflow_run.artifacts_url }}
    //   gh api "$artifacts_url" -q '.artifacts[] | [.name, .archive_download_url] | @tsv' | while read artifact
    //   do
    //     IFS=$'\t' read name url <<< "$artifact"
    //     gh api $url > "$name.zip"
    //     unzip -d "$name" "$name.zip"
    //   done
    this.getScript().getACommand().matches("%github.event.workflow_run.artifacts_url%") and
    (
      this.getScript().getACommand().regexpMatch(unzipRegexp()) or
      this.getAFollowingStep().(Run).getScript().getACommand().regexpMatch(unzipRegexp())
    )
  }

  override string getPath() {
    if
      this.getScript().getACommand().regexpMatch(unzipRegexp() + unzipDirArgRegexp()) or
      this.getAFollowingStep()
          .(Run)
          .getScript()
          .getACommand()
          .regexpMatch(unzipRegexp() + unzipDirArgRegexp())
    then
      result =
        normalizePath(trimQuotes(this.getScript()
                .getACommand()
                .regexpCapture(unzipRegexp() + unzipDirArgRegexp(), 3))) or
      result =
        normalizePath(trimQuotes(this.getAFollowingStep()
                .(Run)
                .getScript()
                .getACommand()
                .regexpCapture(unzipRegexp() + unzipDirArgRegexp(), 3)))
    else result = "GITHUB_WORKSPACE/"
  }
}

class ArtifactPoisoningSink extends DataFlow::Node {
  UntrustedArtifactDownloadStep download;
  PoisonableStep poisonable;

  ArtifactPoisoningSink() {
    download.getAFollowingStep() = poisonable and
    // excluding artifacts downloaded to /tmp
    not download.getPath().regexpMatch("^/tmp.*") and
    (
      poisonable.(Run).getScript() = this.asExpr() and
      (
        // Check if the poisonable step is a local script execution step
        // and the path of the command or script matches the path of the downloaded artifact
        isSubpath(poisonable.(LocalScriptExecutionRunStep).getPath(), download.getPath())
        or
        // Checking the path for non local script execution steps is very difficult
        not poisonable instanceof LocalScriptExecutionRunStep
        // Its not easy to extract the path from a non-local script execution step so skipping this check for now
        // and isSubpath(poisonable.(Run).getWorkingDirectory(), download.getPath())
      )
      or
      poisonable.(UsesStep) = this.asExpr() and
      (
        not poisonable instanceof LocalActionUsesStep and
        download.getPath() = "GITHUB_WORKSPACE/"
        or
        isSubpath(poisonable.(LocalActionUsesStep).getPath(), download.getPath())
      )
    )
  }

  string getPath() { result = download.getPath() }
}

/**
 * A taint-tracking configuration for unsafe artifacts
 * that is used may lead to artifact poisoning
 */
private module ArtifactPoisoningConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ArtifactSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof ArtifactPoisoningSink }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(PoisonableStep step |
      pred instanceof ArtifactSource and
      pred.asExpr().(Step).getAFollowingStep() = step and
      (
        succ.asExpr() = step.(Run).getScript() or
        succ.asExpr() = step.(UsesStep)
      )
    )
    or
    exists(Run run |
      pred instanceof ArtifactSource and
      pred.asExpr().(Step).getAFollowingStep() = run and
      succ.asExpr() = run.getScript() and
      exists(run.getScript().getAFileReadCommand())
    )
  }
}

/** Tracks flow of unsafe artifacts that is used in an insecure way. */
module ArtifactPoisoningFlow = TaintTracking::Global<ArtifactPoisoningConfig>;
