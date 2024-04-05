import actions

string unzipRegexp() { result = ".*(unzip|tar)\\s+.*" }

string unzipDirArgRegexp() {
  result = "-d\\s+\"([^ ]+)\".*" or
  result = "-d\\s+'([^ ]+)'.*"
}

abstract class ArtifactDownloadStep extends Step {
  abstract string getPath();
}

class Dawidd6ActionDownloadArtifactDownloadStep extends ArtifactDownloadStep, UsesStep {
  Dawidd6ActionDownloadArtifactDownloadStep() {
    // eg: - uses: dawidd6/action-download-artifact@v2
    this.getCallee() = "dawidd6/action-download-artifact" and
    // An attacker should not be able to push to local branches which `branch` normally is used for.
    (
      not exists(this.getArgument("branch")) or
      not this.getArgument("branch") = ["main", "master"]
    )
  }

  override string getPath() {
    if exists(this.getArgument("path")) then result = this.getArgument("path") else result = ""
  }
}

class ActionsGitHubScriptDownloadStep extends ArtifactDownloadStep, UsesStep {
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
    script.matches("%writeFileSync%")
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

class GHRunArtifactDownloadStep extends ArtifactDownloadStep, Run {
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

class DirectArtifactDownloadStep extends ArtifactDownloadStep, Run {
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

abstract class PoisonableStep extends Step { }

class CommandExecutionRunStep extends PoisonableStep, Run {
  CommandExecutionRunStep() {
    exists(ArtifactDownloadStep step |
      step.getAFollowingStep() = this and
      // Heuristic:
      // Run step with a command starting with `./xxxx`, `sh xxxx`, `node xxxx`, ...
      // eg: `./test.sh`, `sh test.sh`, `node test.js`, ...
      this.getScript()
          .trim()
          .regexpMatch(".*(./|(node|python|ruby|sh)\\s+)" + step.getPath() + ".*")
    )
  }
}

predicate writeToGithubEnv(Run run, string key, string value) {
  exists(string script, string line |
    script = run.getScript() and
    line = script.splitAt("\n") and
    key = line.regexpCapture("echo\\s+(\")?([^=]+)\\s*=(.*)(\")?\\s*>>\\s*\\$GITHUB_ENV", 2) and
    value = line.regexpCapture("echo\\s+(\")?([^=]+)\\s*=(.*)(\")?\\s*>>\\s*\\$GITHUB_ENV", 3)
  )
}

class EnvVarInjectionRunStep extends PoisonableStep, Run {
  EnvVarInjectionRunStep() {
    exists(ArtifactDownloadStep step, string value |
      step.getAFollowingStep() = this and
      // Heuristic:
      // Run step with env var definition based on file content.
      // eg: `echo "sha=$(cat test-results/sha-number)" >> $GITHUB_ENV`
      writeToGithubEnv(this, _, value) and
      value.regexpMatch(".*cat\\s+.*")
    )
  }
}
