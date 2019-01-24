import javascript

from TypeParameter parameter
select parameter.getLocalTypeName().getAnAccess(),
  "refers to " + parameter.getName() + " on " + parameter.getHost().describe()
