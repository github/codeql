import csharp

from CollectionInitializer i, int n, int arg, ElementInitializer e
where e = i.getElementInitializer(n)
select i, n, e, e.getTarget(), arg, e.getArgument(arg)
