/**
 * @name Polyfill.io Use
 * @description Import of compromised domain Polyfill.io (https://sansec.io/research/polyfill-supply-chain-attack)
 * @kind problem
 * @problem.severity warning
 * @id js/cwe-830/polyfill-io
 * @precision very-high
 */

import javascript

from
    HTML::Attribute a
where
    a.getName().toLowerCase() = "href" and
    exists(a.getValue().toLowerCase().indexOf("polyfill.io"))
select
    a, "Import of compromised CDN polyfill.io"
