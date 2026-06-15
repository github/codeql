import csharp

from TupleType tt, int i
where tt.fromSource()
select tt.getName(), tt.toStringWithTypes(), tt.getUnderlyingType().toStringWithTypes(),
  tt.getArity(), i, tt.getElement(i).getName()
