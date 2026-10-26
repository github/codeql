import csharp

from LocalScopeVariable v
where v.getFile().getStem() = "Scoped" and v.isScoped()
select v, v.getAPrimaryQlClass()
