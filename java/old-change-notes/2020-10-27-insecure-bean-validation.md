lgtm,codescanning
* A new query "Insecure Bean Validation" (`java/insecure-bean-validation`) has been added. This query 
  finds server-side template injections caused by untrusted data flowing from a bean 
  property into a custom error message for a constraint validator. This 
  vulnerability can lead to arbitrary code execution.
