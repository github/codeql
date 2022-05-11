/**
 * @name Spring Implicit View Manipulation
 * @description Untrusted input in a Spring View Controller can lead to RCE.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/spring-view-manipulation-implicit
 * @tags security
 *       external/cwe/cwe-094
 */

import java
import SpringViewManipulationLib

private predicate canResultInImplicitViewConversion(Method m) {
  m.getReturnType() instanceof VoidType
  or
  m.getReturnType() instanceof MapType
  or
  m.getReturnType().(RefType).hasQualifiedName("org.springframework.ui", "Model")
}

private predicate maybeATestMethod(Method m) {
  exists(string s |
    s = m.getName() or
    s = m.getFile().getRelativePath() or
    s = m.getDeclaringType().getName()
  |
    s.matches(["%test%", "%example%", "%exception%"])
  )
}

private predicate mayBeExploitable(Method m) {
  // There should be a attacker controlled parameter in the URI for the attack to be exploitable.
  // This is possible only when there exists a parameter with the Spring `@PathVariable` annotation
  // applied to it.
  exists(Parameter p |
    p = m.getAParameter() and
    p.hasAnnotation("org.springframework.web.bind.annotation", "PathVariable") and
    // Having a parameter of say type `Long` is non exploitable as Java type
    // checking rules are applied prior to view name resolution, rendering the exploit useless.
    // hence, here we check for the param type to be a Java `String`.
    p.getType() instanceof TypeString and
    // Exclude cases where a regex check is applied on a parameter to prevent false positives.
    not m.(SpringRequestMappingMethod).getValue().matches("%{%:[%]%}%")
  ) and
  not maybeATestMethod(m)
}

from SpringRequestMappingMethod m
where
  thymeleafIsUsed() and
  mayBeExploitable(m) and
  canResultInImplicitViewConversion(m) and
  // If there's a parameter of type`HttpServletResponse`, Spring Framework does not interpret
  // it as a view name, but just returns this string in HTTP Response preventing exploitation
  // This also applies to `@ResponseBody` annotation.
  not m.getParameterType(_) instanceof HttpServletResponse and
  // A spring request mapping method which does not have response body annotation applied to it
  m.getAnAnnotation().getType() instanceof SpringRequestMappingAnnotationType and
  not m.getAnAnnotation().getType() instanceof SpringResponseBodyAnnotationType and
  // `@RestController` inherits `@ResponseBody` internally so it should be ignored.
  not m.getDeclaringType() instanceof SpringRestController
select m, "This method may be vulnerable to spring view manipulation vulnerabilities"
