package p;

@FunctionalInterface
public interface MyFunction<T1, T2, T3> {

  // summary=p;MyFunction;true;apply;(Object,Object);;Argument[this].SyntheticField[ArgType2];ReturnValue;value;tb-generated
  // summary=p;MyFunction;true;apply;(Object,Object);;Argument[0];Argument[this].SyntheticField[ArgType0];value;tb-generated
  // summary=p;MyFunction;true;apply;(Object,Object);;Argument[1];Argument[this].SyntheticField[ArgType1];value;tb-generated
  T3 apply(T1 x, T2 y);
}
