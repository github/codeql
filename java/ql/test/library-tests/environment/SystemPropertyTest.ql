import default
import semmle.code.java.environment.SystemProperty

from Expr systemPropertyAccess, string propertyName
where systemPropertyAccess = getSystemProperty(propertyName)
select systemPropertyAccess, propertyName
