/**
 * @name Hardcoded credentials in container configuration
 * @description Hardcoding credentials in workflow container or service configurations
 *              exposes secrets in the repository source code.
 * @kind problem
 * @precision high
 * @security-severity 9.0
 * @problem.severity error
 * @id actions/hardcoded-container-credentials
 * @tags actions
 *       security
 *       experimental
 *       external/cwe/cwe-798
 */

import actions
private import codeql.actions.ast.internal.Yaml
private import codeql.actions.ast.internal.Ast

/**
 * Gets a `credentials.password` scalar node from a container or service mapping within a job.
 */
YamlScalar getAHardcodedPassword(LocalJobImpl job, string context) {
  exists(YamlMapping creds |
    // Job-level container credentials
    creds = job.getNode().lookup("container").(YamlMapping).lookup("credentials") and
    context = "container"
    or
    // Service-level container credentials
    exists(YamlMapping service |
      service = job.getNode().lookup("services").(YamlMapping).lookup(_) and
      creds = service.lookup("credentials") and
      context = "service"
    )
  |
    result = creds.lookup("password") and
    // Not a ${{ }} expression reference (e.g. ${{ secrets.PASSWORD }})
    not result.getValue().regexpMatch("\\$\\{\\{.*\\}\\}")
  )
}

from LocalJob job, YamlScalar password, string context
where password = getAHardcodedPassword(job, context)
select password,
  "Hardcoded password in " + context + " credentials for job $@. Use an encrypted secret instead.",
  job, job.(Job).getId()
