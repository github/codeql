import actions
private import codeql.actions.TaintTracking
import codeql.actions.DataFlow
private import codeql.actions.dataflow.ExternalFlow
import codeql.actions.dataflow.FlowSources
import codeql.actions.security.PoisonableSteps

string unzipRegexp() { result = ".*(unzip|tar)\\s+.*" }

string unzipDirArgRegexp() {
  result = "-d\\s+\"([^ ]+)\".*" or
  result = "-d\\s+'([^ ]+)'.*"
}

abstract class UntrustedArtifactDownloadStep extends Step {
  abstract string getPath();
}

class GitHubDownloadArtifactActionStep extends UntrustedArtifactDownloadStep, UsesStep {
  GitHubDownloadArtifactActionStep() {
    // By default, the permissions are scoped so they can only download Artifacts within the current workflow run.
    // To elevate permissions for this scenario, you can specify a github-token along with other repository and run identifiers
    this.getCallee() = "actions/download-artifact" and
    this.getArgument("run-id").matches("%github.event.workflow_run.id%") and
    exists(this.getArgument("github-token"))
  }

  override string getPath() {
    if exists(this.getArgument("path")) then result = this.getArgument("path") else result = ""
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
      not exists(this.getArgument(["branch", "branch_name"])) or
      not this.getArgument(["branch", "branch_name"]) = ["main", "master"]
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
      not this.getArgument("pr").matches("%github.event.pull_request.number%")
    )
  }

  override string getPath() {
    if exists(this.getArgument(["path", "download_path"]))
    then result = this.getArgument(["path", "download_path"])
    else
      if exists(this.getArgument("paths"))
      then result = this.getArgument("paths").splitAt(" ")
      else result = ""
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
    then result = this.getArgument("path")
    else result = "./artifacts"
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
          .splitAt("\n")
          .regexpMatch(unzipRegexp() + unzipDirArgRegexp())
    then
      result =
        this.getAFollowingStep()
            .(Run)
            .getScript()
            .splitAt("\n")
            .regexpCapture(unzipRegexp() + unzipDirArgRegexp(), 2)
    else
      if this.getAFollowingStep().(Run).getScript().splitAt("\n").regexpMatch(unzipRegexp())
      then result = ""
      else none()
  }
}

class GHRunArtifactDownloadStep extends UntrustedArtifactDownloadStep, Run {
  string script;

  GHRunArtifactDownloadStep() {
    // eg: - run: gh run download ${{ github.event.workflow_run.id }} --repo "${GITHUB_REPOSITORY}" --name "artifact_name"
    this.getScript() = script and
    script.splitAt("\n").regexpMatch(".*gh\\s+run\\s+download.*") and
    script.splitAt("\n").matches("%github.event.workflow_run.id%") and
    (
      script.splitAt("\n").regexpMatch(unzipRegexp()) or
      this.getAFollowingStep().(Run).getScript().splitAt("\n").regexpMatch(unzipRegexp())
    )
  }

  override string getPath() {
    if
      this.getAFollowingStep()
          .(Run)
          .getScript()
          .splitAt("\n")
          .regexpMatch(unzipRegexp() + unzipDirArgRegexp()) or
      script.splitAt("\n").regexpMatch(unzipRegexp() + unzipDirArgRegexp())
    then
      result = script.splitAt("\n").regexpCapture(unzipRegexp() + unzipDirArgRegexp(), 2) or
      result =
        this.getAFollowingStep()
            .(Run)
            .getScript()
            .splitAt("\n")
            .regexpCapture(unzipRegexp() + unzipDirArgRegexp(), 2)
    else
      if
        this.getAFollowingStep().(Run).getScript().splitAt("\n").regexpMatch(unzipRegexp()) or
        script.splitAt("\n").regexpMatch(unzipRegexp())
      then result = ""
      else none()
  }
}

class DirectArtifactDownloadStep extends UntrustedArtifactDownloadStep, Run {
  string script;

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
    this.getScript() = script and
    script.splitAt("\n").matches("%github.event.workflow_run.artifacts_url%") and
    (
      script.splitAt("\n").regexpMatch(unzipRegexp()) or
      this.getAFollowingStep().(Run).getScript().splitAt("\n").regexpMatch(unzipRegexp())
    )
  }

  override string getPath() {
    if
      script.splitAt("\n").regexpMatch(unzipRegexp() + unzipDirArgRegexp()) or
      this.getAFollowingStep()
          .(Run)
          .getScript()
          .splitAt("\n")
          .regexpMatch(unzipRegexp() + unzipDirArgRegexp())
    then
      result = script.splitAt("\n").regexpCapture(unzipRegexp() + unzipDirArgRegexp(), 2) or
      result =
        this.getAFollowingStep()
            .(Run)
            .getScript()
            .splitAt("\n")
            .regexpCapture(unzipRegexp() + unzipDirArgRegexp(), 2)
    else result = ""
  }
}

class ArtifactPoisoningSink extends DataFlow::Node {
  ArtifactPoisoningSink() {
    exists(UntrustedArtifactDownloadStep download, PoisonableStep poisonable |
      download.getAFollowingStep() = poisonable and
      (
        poisonable.(Run).getScriptScalar() = this.asExpr()
        or
        poisonable.(UsesStep) = this.asExpr()
      ) and
      (
        not poisonable instanceof LocalScriptExecutionRunStep or
        poisonable.(LocalScriptExecutionRunStep).getCommand().matches(download.getPath() + "%")
      )
    )
  }
}

/**
 * A taint-tracking configuration for unsafe artifacts
 * that is used may lead to artifact poisoning
 */
private module ArtifactPoisoningConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof ArtifactPoisoningSink }
}

/** Tracks flow of unsafe artifacts that is used in an insecure way. */
module ArtifactPoisoningFlow = TaintTracking::Global<ArtifactPoisoningConfig>;
