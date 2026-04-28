/**
 * @name npm publish missing --provenance flag
 * @description The npm publish command does not include '--provenance'. Provenance attestation
 *              cryptographically links the published package to a specific source commit and
 *              workflow run.
 * @kind problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision high
 * @id actions/missing-provenance-flag
 * @tags actions
 *       security
 *       supply-chain
 *       external/cwe/cwe-353
 */

import actions

from Run run, string command
where
  command = run.getScript().getACommand() and
  command.regexpMatch("(?i).*\\bnpm\\s+publish\\b.*") and
  not command.regexpMatch("(?i).*\\bnpm\\s+publish\\b.*--provenance\\b.*")
select run,
  "npm publish command does not include '--provenance'. Add '--provenance' to cryptographically link the package to this source commit and workflow run."
