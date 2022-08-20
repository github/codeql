import javascript

from StringLiteral sl
where sl.getFile().getBaseName() = "test.js"
select sl, sl.getValue(), sl.getRawValue(), sl.getStringValue(), sl.getUnderlyingValue()
