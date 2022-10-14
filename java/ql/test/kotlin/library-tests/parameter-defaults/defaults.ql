import java

from Callable realMethod, Callable defaultsProxy
where
  defaultsProxy = realMethod.getKotlinParameterDefaultsProxy() and
  realMethod.fromSource()
select realMethod, defaultsProxy
