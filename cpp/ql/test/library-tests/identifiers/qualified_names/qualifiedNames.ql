import cpp

from
  Declaration d, string namespaceQualifier, string typeQualifier, string baseName, string globalName
where
  d.hasQualifiedName(namespaceQualifier, typeQualifier, baseName) and
  (
    d.hasGlobalName(globalName)
    or
    not d.hasGlobalName(_) and
    globalName = "(not global)"
  )
select d, d.getQualifiedName(), namespaceQualifier, typeQualifier, baseName, globalName
