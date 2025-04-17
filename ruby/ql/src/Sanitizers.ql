/**
 * @name Sanitizers
 * @id rb/meta/sanitizers
 * @kind problem
 * @severity info
 */
import codeql.ruby.DataFlow
import codeql.ruby.security.XSS

from StoredXss::Sanitizer s
where s instanceof DataFlow::CallNode
select s, "XSS sanitizer"