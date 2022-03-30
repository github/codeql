import javascript
private import AngularJS

from InjectableFunction f, string name
where exists(f.getDependencyParameter(name))
select f, name
