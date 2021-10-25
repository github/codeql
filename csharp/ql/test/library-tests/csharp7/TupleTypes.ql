import csharp

from TupleType tt, int i
where tt.getAnElement().fromSource()
select tt.getName(), tt.toStringWithTypes(), tt.getUnderlyingType().toStringWithTypes(),
  tt.getArity(), i, tt.getElement(i)
