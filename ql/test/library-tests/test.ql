import codeql.actions.Ast
import codeql.actions.Helper
import codeql.actions.Cfg as Cfg
import codeql.actions.DataFlow
import codeql.Locations
import codeql.actions.dataflow.ExternalFlow

query predicate files(File f) { any() }

query predicate workflows(Workflow w) { any() }

query predicate reusableWorkflows(ReusableWorkflow w) { any() }

query predicate compositeActions(CompositeAction w) { any() }

query predicate jobs(Job s) { any() }

query predicate localJobs(LocalJob s) { any() }

query predicate extJobs(ExternalJob s) { any() }

query predicate steps(Step s) { any() }

query predicate runSteps(Run run, string body) { run.getScript() = body }

query predicate runExprs(Run s, Expression e) { e = s.getAnScriptExpr() }

query predicate uses(Uses s) { any() }

query predicate stepUses(UsesStep s) { any() }

query predicate usesArgs(Uses call, string argname, Expression arg) {
  call.getArgumentExpr(argname) = arg
}

query predicate runStepChildren(Run run, AstNode child) { child.getParentNode() = run }

query predicate parentNodes(AstNode child, AstNode parent) { child.getParentNode() = parent }

query predicate cfgNodes(Cfg::Node n) { any() }

query predicate dfNodes(DataFlow::Node e) { any() }

query predicate argumentNodes(DataFlow::ArgumentNode e) { any() }

query predicate usesIds(UsesStep s, string a) { s.getId() = a }

query predicate nodeLocations(DataFlow::Node n, Location l) { n.getLocation() = l }

query predicate scopes(Cfg::CfgScope c) { any() }

query predicate sources(string action, string version, string output, string kind, string provenance) {
  sourceModel(action, version, output, kind, provenance)
}

query predicate summaries(
  string action, string version, string input, string output, string kind, string provenance
) {
  summaryModel(action, version, input, output, kind, provenance)
}

query predicate calls(DataFlow::CallNode call, string callee) { callee = call.getCallee() }

query predicate needs(DataFlow::Node e) { e.asExpr() instanceof NeedsExpression }

query string testNormalizeExpr(string s) {
  s =
    [
      "github.event.pull_request.user['login']", "github.event.pull_request.user[\"login\"]",
      "github.event.pull_request['user']['login']", "foo['bar'] == baz"
    ] and
  result = normalizeExpr(s)
}

query predicate writeToGitHubEnv(string key, string value) {
  exists(string t |
    t =
      [
        "echo \"::set-env name=id1::$(<pr-id1.txt)\"", "echo '::set-env name=id2::$(<pr-id2.txt)'",
        "echo ::set-env name=id3::$(<pr-id3.txt)",
        "echo \"sha1=$(<test-results1/sha-number)\" >> $GITHUB_ENV",
        "echo 'sha2=$(<test-results2/sha-number)' >> $GITHUB_ENV",
        "echo sha3=$(<test-results3/sha-number) >> $GITHUB_ENV",
      ] and
    extractLineAssignment(t, "ENV", key, value)
  )
}

query predicate writeToGitHubOutput(string key, string value) {
  exists(string t |
    t =
      [
        "echo \"::set-output name=id1::$(<pr-id1.txt)\"",
        "echo '::set-output name=id2::$(<pr-id2.txt)'",
        "echo ::set-output name=id3::$(<pr-id3.txt)",
        "echo \"sha1=$(<test-results1/sha-number)\" >> $GITHUB_OUTPUT",
        "echo 'sha2=$(<test-results2/sha-number)' >> $GITHUB_OUTPUT",
        "echo sha3=$(<test-results3/sha-number) >> $GITHUB_OUTPUT",
        "echo sha4=$(<test-results4/sha-number) >> \"$GITHUB_OUTPUT\"",
        "echo sha5=$(<test-results5/sha-number) >> ${GITHUB_OUTPUT}",
        "echo sha6=$(<test-results6/sha-number) >> \"${GITHUB_OUTPUT}\"",
      ] and
    extractLineAssignment(t, "OUTPUT", key, value)
  )
}
