import actions

class ArtifactDownloadStep extends Step {
  ArtifactDownloadStep() {
    // eg: - uses: dawidd6/action-download-artifact@v2
    this.(UsesStep).getCallee() = "dawidd6/action-download-artifact" and
    // exclude downloads outside the current directory
    // TODO: add more checks to make sure the artifacts can be controlled
    not exists(this.(UsesStep).getArgumentExpr("path"))
    or
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
    this.(UsesStep).getCallee() = "actions/github-script" and
    exists(string script |
      this.(UsesStep).getArgument("script") = script and
      script.matches("%listWorkflowRunArtifacts(%") and
      script.matches("%downloadArtifact(%")
    )
    or
    // eg: - run: gh run download "${WORKFLOW_RUN_ID}" --repo "${GITHUB_REPOSITORY}" --name "artifact_name"
    this.(Run).getScript().splitAt("\n").regexpMatch(".*gh\\s+run\\s+download.*")
    or
    // eg:
    // run: |
    //   artifacts_url=${{ github.event.workflow_run.artifacts_url }}
    //   gh api "$artifacts_url" -q '.artifacts[] | [.name, .archive_download_url] | @tsv' | while read artifact
    //   do
    //     IFS=$'\t' read name url <<< "$artifact"
    //     gh api $url > "$name.zip"
    //     unzip -d "$name" "$name.zip"
    //   done
    this.(Run).getScript().splitAt("\n").matches("%github.event.workflow_run.artifacts_url%")
  }
}
