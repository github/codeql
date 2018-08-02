import javascript

from NewExpr new, ClassDefinition klass
where klass.getConstructor().getInit() = new.(CallSite).getACallee() 
select new.getFile().getBaseName(), new.getCalleeName(), klass.getFile().getBaseName(), klass.getName()
