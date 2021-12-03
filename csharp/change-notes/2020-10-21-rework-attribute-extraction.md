lgtm,codescanning
* Attribute extraction has been extended to extract attributes not only from source
code, but from referenced assemblies too. This change may lead to more results in
queries that rely on attributes. Note that, as more attributes might be extracted,
the DB size might increase.
