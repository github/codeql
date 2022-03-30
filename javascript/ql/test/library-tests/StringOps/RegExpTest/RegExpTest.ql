import javascript

query StringOps::RegExpTest regexpTest() { any() }

from StringOps::RegExpTest test
select test, test.getRegExp(), test.getRegExpOperand(), test.getStringOperand(), test.getPolarity()
