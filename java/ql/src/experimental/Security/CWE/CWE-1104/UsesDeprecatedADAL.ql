/**
 * @name Depending upon Microsoft Azure Active Directory Authentication Library (ADAL) 
 * @description ADAL is deprecated
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/microsoft/azure/dependency-upon-adal
 * @tags security
 *       external/cwe/cwe-1104
 */
import java

from ClassInstanceExpr adal
where adal.getConstructedType().hasQualifiedName("com.microsoft.aad.adal4j", "AuthenticationContext")
select adal