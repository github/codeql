/**
 * @description Used to debug the discovery of regexp literals.
 * @kind problem
 */

import codeql.ruby.regexp.internal.RegExpTracking
import ruby

from DataFlow::Node source, DataFlow::Node sink
where source = regExpSource(sink)
select sink, "Regexp from $@ is used.", source, "this source"
