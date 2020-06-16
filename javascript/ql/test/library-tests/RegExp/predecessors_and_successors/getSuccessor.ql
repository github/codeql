import javascript

from RegExpTerm pred, RegExpTerm succ
where succ = pred.getSuccessor()
select pred, succ
