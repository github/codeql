import csharp

from CollectionExpression ce, Expr element, int i
where element = ce.getElement(i)
select ce, ce.getType().toString(), i.toString(), element
