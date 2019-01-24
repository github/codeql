import javascript

from VariableDeclarator vd, DataFlow::AnalyzedNode init
where init = vd.getInit().analyze()
select vd.getBindingPattern(), init, init.getAValue()
