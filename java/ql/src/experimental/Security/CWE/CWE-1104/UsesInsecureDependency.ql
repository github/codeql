/**
 * @name Using Insecure Dependency 
 * @description A dependency imported into your project is either deprecated or will cease to be supported in the near future.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/microsoft/using-insecure-dependency
 * @tags security
 *       external/cwe/cwe-1104
 */
import java


predicate usesInsecureDependency(Import i) {
  i.toString().splitAt(" ", 1) in [ "com.microsoft.aad.adal4j.*", 
    							    "AuthenticationContext",
    								"X509Certificate"
  								  ]
}

from Import imp
where imp = max(Import i | usesInsecureDependency(i) | i order by i.getFile().toString())
select imp.getFile(), imp.getLocation(), "The following imported package is either deprecated or will cease to be supported in the near future: "+imp.toString().splitAt(" ", 1)
