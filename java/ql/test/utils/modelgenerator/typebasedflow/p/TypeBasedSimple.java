package p;

public class TypeBasedSimple<T> {

  // heuristic-summary=p;TypeBasedSimple;true;TypeBasedSimple;(Object);;Argument[0];Argument[this].SyntheticField[ArgType0];value;tb-generated
  public TypeBasedSimple(T t) {}

  // heuristic-summary=p;TypeBasedSimple;true;get;();;Argument[this].SyntheticField[ArgType0];ReturnValue;value;tb-generated
  public T get() {
    return null;
  }

  // heuristic-summary=p;TypeBasedSimple;true;get;(Object);;Argument[this].SyntheticField[ArgType0];ReturnValue;value;tb-generated
  public T get(Object o) {
    return null;
  }

  // heuristic-summary=p;TypeBasedSimple;true;id;(Object);;Argument[this].SyntheticField[ArgType0];ReturnValue;value;tb-generated
  // heuristic-summary=p;TypeBasedSimple;true;id;(Object);;Argument[0];Argument[this].SyntheticField[ArgType0];value;tb-generated
  // heuristic-summary=p;TypeBasedSimple;true;id;(Object);;Argument[0];ReturnValue;value;tb-generated
  public T id(T x) {
    return null;
  }

  // heuristic-summary=p;TypeBasedSimple;true;id2;(Object);;Argument[0];ReturnValue;value;tb-generated
  public <S> S id2(S x) {
    return null;
  }

  // heuristic-summary=p;TypeBasedSimple;true;set;(Object);;Argument[0];Argument[this].SyntheticField[ArgType0];value;tb-generated
  public void set(T x) {}

  // heuristic-summary=p;TypeBasedSimple;true;set;(int,Object);;Argument[1];Argument[this].SyntheticField[ArgType0];value;tb-generated
  public void set(int x, T y) {}

  // No summary as S is unrelated to T
  public <S> void set2(S x) {}
}
