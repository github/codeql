lgtm,codescanning
* New query "Insecure Bean Validation" (java/insecure-bean-validation) added. This query 
  finds Server-Side Template Injections caused by untrusted data flowing from a Bean 
  property being validated into a custom constraint violation error message. This 
  vulnerability leads to arbitrary code execution.

