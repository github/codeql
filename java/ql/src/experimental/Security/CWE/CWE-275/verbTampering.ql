import java
import semmle.code.xml.WebXML

class ValidHTTPMethods extends string {
  ValidHTTPMethods() {
    this = "OPTIONS" or
    this = "GET" or
    this = "HEAD" or
    this = "PATCH" or
    this = "POST" or
    this = "PUT" or
    this = "DELETE" or
    this = "TRACE" or
    this = "CONNECT"
  }
}

from WebResourceCollectionClass c, ValidHTTPMethods m
where
  // get all instances where
  // the parent security-constraint declares an auth-constraint
  exists(c.getDeclaringConstraint().getAuthConstraint()) and
  // there is at least one valid HTTP method which is not included
  not forex( | m = c.getAHTTPMethodValue())
select c, "Auth constraint applied to $@ does not check for $@ verb", c, "web resource collection",
  m, m
