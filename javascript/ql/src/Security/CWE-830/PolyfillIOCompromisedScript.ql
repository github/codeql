/**
 * @name Polyfill.io script use
 * @description Use of script from compromised domain Polyfill.io (https://sansec.io/research/polyfill-supply-chain-attack)
 * @kind problem
 * @security-severity 7.2
 * @problem.severity error
 * @id js/polyfill-io-compromised-script
 * @precision high
 * @tags security
 *       external/cwe/cwe-830
 */

import javascript
import semmle.javascript.security.FunctionalityFromUntrustedSource

from AddsUntrustedUrl s
where s.getUrl().regexpMatch("^(?i)https?://(cdn\\.)?polyfill\\.io/.*")
select s, "Script loaded from known-compromised content delivery network with no integrity check"
