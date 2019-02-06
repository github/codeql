import semmle.javascript.Closure

from GoogRequire gr
select gr, gr.getNamespaceId()
