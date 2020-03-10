import javascript

from RegExpTerm pred, RegExpTerm succ
where pred = succ.getPredecessor()
select pred, succ
