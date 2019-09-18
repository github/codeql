import javascript
private import AngularJS

from InjectableFunction f, CustomServiceReference s, CustomServiceDefinition custom
where s = f.getAResolvedDependency(_) and s = custom.getServiceReference()
select f, custom.getName()
