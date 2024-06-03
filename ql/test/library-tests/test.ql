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
  actionsSourceModel(action, version, output, kind, provenance)
}

query predicate summaries(
  string action, string version, string input, string output, string kind, string provenance
) {
  actionsSummaryModel(action, version, input, output, kind, provenance)
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

query predicate writeToGitHubEnv1(string content) {
  exists(string t |
    t =
      [
        "FOO\n{\n  echo 'JSON_RESPONSE<<EOF'\n  ls | grep -E \"*.(tar.gz|zip)$\"\n  echo EOF\n  } >> \"$GITHUB_ENV\"\nBAR"
        //"FOO\n{\n  echo 'JSON_RESPONSE<<EOF'\n  echo \"$TITLE\"\n  echo EOF\n} >> \"$GITHUB_ENV\"\nBAR",
        //"FOO\necho \"VAR3<<EOF\" >> $GITHUB_ENV\necho \"$TITLE\" >> $GITHUB_ENV\necho \"EOF\" >> $GITHUB_ENV\nBAR",
      ] and
    //linesFileWrite(t, _, "$GITHUB_ENV", content, _)
    blockFileWrite(t, _, "$GITHUB_ENV", content, _)
    //extractFileWrite(t, "GITHUB_ENV", content)
  )
}

query predicate writeToGitHubEnv(string key, string value, string content) {
  exists(string t |
    t =
      [
        // block
        "{\n  echo 'VAR0<<EOF'\n  echo \"$TITLE\"\n  echo EOF\n} >> \"$GITHUB_ENV\"\n",
        "{\necho 'VAR1<<EOF'\necho \"$TITLE\"\necho EOF\n} >> \"$GITHUB_ENV\"",
        "{\necho 'VAR2<<EOF'\necho '$ISSUE'\necho 'EOF'\n} >> \"$GITHUB_ENV\"",
        "FOO\n{\n  echo 'VAR22<<EOF'\n  ls | grep -E \"*.(tar.gz|zip)$\"\n  echo EOF\n  } >> \"$GITHUB_ENV\"\nBAR",
        // multiline
        "FOO\necho \"VAR3<<EOF\" >> $GITHUB_ENV\necho \"$TITLE\" >> $GITHUB_ENV\necho \"EOF\" >> $GITHUB_ENV\nBAR",
        "echo \"PACKAGES_FILE_LIST<<EOF\" >> \"${GITHUB_ENV}\"\nls | grep -E \"*.(tar.gz|zip)$\" >> \"${GITHUB_ENV}\"\nls | grep -E \"*.(txt|md)$\" >> \"${GITHUB_ENV}\"\necho \"EOF\" >> \"${GITHUB_ENV}\"",
        // heredoc 1
        "cat >> $GITHUB_ENV << EOL\nVAR4=${ISSUE_BODY1}\nEOL",
        "cat > $GITHUB_ENV << EOL\nVAR5<<DELIM\nHello\nWorld\nDELIM\nEOL",
        // heredoc 2
        "cat << EOL >> $GITHUB_ENV\nVAR6=${ISSUE_BODY3}\nEOL\n",
        "cat <<EOF |  sed 's/l/e/g' > $GITHUB_ENV\nVAR7<<DELIM\nHello\nWorld\nDELIM\nEOF\n",
        "\ncat <<-EOF >> \"$GITHUB_ENV\"\nVAR8=$(echo \"FOO\")\nVAR9<<DELIM\nHello\nWorld\nDELIM\nEOF",
        // single line
        "\necho \"::set-env name=VAR10::$(<pr-id1.txt)\"",
        "echo '::set-env name=VAR11::$(<pr-id2.txt)'", "echo ::set-env name=VAR12::$(<pr-id3.txt)",
        "echo \"VAR13=$(<test-results1/sha-number)\" >> $GITHUB_ENV",
        "echo 'VAR14=$(<test-results2/sha-number)' >> $GITHUB_ENV",
        "echo VAR15=$(<test-results3/sha-number) >> $GITHUB_ENV",
        "echo VAR16=$(cat issue.txt | sed 's/\\r/\\n/g' | grep -ioE '\\s*[a-z0-9_-]+/[a-z0-9_-]+\\s*$' | tr -d ' ') >> $GITHUB_ENV",
      ] and
    extractFileWrite(t, "GITHUB_ENV", content) and
    extractVariableAndValue(content, key, value)
  )
}

query predicate writeToGitHubOutput(string key, string value, string content) {
  exists(string t |
    t =
      [
        "echo \"::set-output name=VAR1::$(<pr-id1.txt)\"",
        "echo '::set-output name=VAR2::$(<pr-id2.txt)'",
        "echo ::set-output name=VAR3::$(<pr-id3.txt)",
        "echo \"VAR4=$(<test-results1/sha-number)\" >> $GITHUB_OUTPUT",
        "echo 'VAR5=$(<test-results2/sha-number)' >> $GITHUB_OUTPUT",
        "echo VAR6=$(<test-results3/sha-number) >> $GITHUB_OUTPUT",
        "echo VAR7=$(<test-results4/sha-number) >> \"$GITHUB_OUTPUT\"",
        "echo VAR8=$(<test-results5/sha-number) >> ${GITHUB_OUTPUT}",
        "echo VAR9=$(<test-results6/sha-number) >> \"${GITHUB_OUTPUT}\"",
      ] and
    extractFileWrite(t, "GITHUB_OUTPUT", content) and
    extractVariableAndValue(content, key, value)
  )
}

query predicate isBashParameterExpansion(string parameter, string operator, string params) {
  exists(string test |
    test =
      [
        "$parameter1", "${parameter2}", "${!parameter3}", "${#parameter4}", "${parameter5:-value}",
        "${parameter6:=value}", "${parameter7:+value}", "${parameter8:?value}",
        "${parameter9:=default value}", "${parameter10##*/}", "${parameter11/#pattern/string}",
        "${parameter12/%pattern/string}", "${parameter13,pattern}", "${parameter14,,pattern}",
        "${parameter15^pattern}", "${parameter16^^pattern}", "${parameter17:start}",
        "${parameter18#pattern}", "${parameter19##pattern}", "${parameter20%pattern}",
        "${parameter21%%pattern}", "${parameter22/pattern/string}",
        "${parameter23//pattern/string}",
      ] and
    isBashParameterExpansion(test, parameter, operator, params)
  )
}
