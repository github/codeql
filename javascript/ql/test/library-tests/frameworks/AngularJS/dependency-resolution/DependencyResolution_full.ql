import javascript
private import AngularJS

from InjectableFunction f, SimpleParameter p, DataFlow::Node nd
where nd = f.getCustomServiceDependency(p)
select p.getName(), nd
