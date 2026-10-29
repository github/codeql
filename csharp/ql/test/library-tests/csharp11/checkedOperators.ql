import csharp

from Operator o
where o.getFile().getStem() = "CheckedOperators"
select o, o.getFunctionName(), o.getAPrimaryQlClass()
