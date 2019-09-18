import javascript

from DataFlow::NewNode new, ClassDefinition klass
where klass.getConstructor().getInit() = new.getACallee()
select new.getFile().getBaseName(), new.getCalleeName(), klass.getFile().getBaseName(),
  klass.getName()
