package p;

import java.util.List;
import java.util.function.Function;

public class TypeBasedComplex<T> {

  // summary=p;TypeBasedComplex;true;addMany;(List);;Argument[0].Element;Argument[this].SyntheticField[ArgType0];value;tb-generated
  public void addMany(List<T> xs) {}

  // summary=p;TypeBasedComplex;true;getMany;();;Argument[this].SyntheticField[ArgType0];ReturnValue.Element;value;tb-generated
  public List<T> getMany() {
    return null;
  }

  // summary=p;TypeBasedComplex;true;apply;(Function);;Argument[this].SyntheticField[ArgType0];Argument[0].Parameter[0];value;tb-generated
  public Integer apply(Function<T, Integer> f) {
    return null;
  }

  // A method that doesn't mention `T` in its type signature.
  // This is for testing that we don't generate a summary that involves the
  // implicit field for `T`.
  // summary=p;TypeBasedComplex;true;apply2;(Object,Function);;Argument[0];Argument[1].Parameter[0];value;tb-generated
  // summary=p;TypeBasedComplex;true;apply2;(Object,Function);;Argument[1].ReturnValue;ReturnValue;value;tb-generated
  public <T1, T2> T2 apply2(T1 x, Function<T1, T2> f) {
    return null;
  }

  // summary=p;TypeBasedComplex;true;flatMap;(Function);;Argument[this].SyntheticField[ArgType0];Argument[0].Parameter[0];value;tb-generated
  // summary=p;TypeBasedComplex;true;flatMap;(Function);;Argument[this].SyntheticField[ArgType0];ReturnValue.SyntheticField[ArgType0];value;tb-generated
  // summary=p;TypeBasedComplex;true;flatMap;(Function);;Argument[0].ReturnValue.Element;Argument[this].SyntheticField[ArgType0];value;tb-generated
  // summary=p;TypeBasedComplex;true;flatMap;(Function);;Argument[0].ReturnValue.Element;Argument[0].Parameter[0];value;tb-generated
  // summary=p;TypeBasedComplex;true;flatMap;(Function);;Argument[0].ReturnValue.Element;ReturnValue.SyntheticField[ArgType0];value;tb-generated
  public TypeBasedComplex<T> flatMap(Function<T, List<T>> f) {
    return null;
  }

  // summary=p;TypeBasedComplex;true;flatMap2;(Function);;Argument[this].SyntheticField[ArgType0];Argument[0].Parameter[0];value;tb-generated
  // summary=p;TypeBasedComplex;true;flatMap2;(Function);;Argument[0].ReturnValue.Element;ReturnValue.SyntheticField[ArgType0];value;tb-generated
  public <S> TypeBasedComplex<S> flatMap2(Function<T, List<S>> f) {
    return null;
  }

  // summary=p;TypeBasedComplex;true;map;(Function);;Argument[this].SyntheticField[ArgType0];Argument[0].Parameter[0];value;tb-generated
  // summary=p;TypeBasedComplex;true;map;(Function);;Argument[0].ReturnValue;ReturnValue;value;tb-generated
  public <S> S map(Function<T, S> f) {
    return null;
  }

  // summary=p;TypeBasedComplex;true;mapComplex;(Function);;Argument[this].SyntheticField[ArgType0];Argument[0].Parameter[0];value;tb-generated
  // summary=p;TypeBasedComplex;true;mapComplex;(Function);;Argument[0].ReturnValue;ReturnValue.SyntheticField[ArgType0];value;tb-generated
  public <S> TypeBasedComplex<S> mapComplex(Function<T, S> f) {
    return null;
  }

  // summary=p;TypeBasedComplex;true;returnComplex;(Function);;Argument[this].SyntheticField[ArgType0];Argument[0].Parameter[0];value;tb-generated
  // summary=p;TypeBasedComplex;true;returnComplex;(Function);;Argument[this].SyntheticField[ArgType0];ReturnValue.SyntheticField[ArgType0];value;tb-generated
  // summary=p;TypeBasedComplex;true;returnComplex;(Function);;Argument[0].ReturnValue.SyntheticField[ArgType0];Argument[this].SyntheticField[ArgType0];value;tb-generated
  // summary=p;TypeBasedComplex;true;returnComplex;(Function);;Argument[0].ReturnValue.SyntheticField[ArgType0];Argument[0].Parameter[0];value;tb-generated
  // summary=p;TypeBasedComplex;true;returnComplex;(Function);;Argument[0].ReturnValue.SyntheticField[ArgType0];ReturnValue.SyntheticField[ArgType0];value;tb-generated
  public TypeBasedComplex<T> returnComplex(Function<T, TypeBasedComplex<T>> f) {
    return null;
  }

  // summary=p;TypeBasedComplex;true;set;(Integer,Function);;Argument[1].ReturnValue;Argument[this].SyntheticField[ArgType0];value;tb-generated
  public void set(Integer x, Function<Integer, T> f) {}

  // summary=p;TypeBasedComplex;true;applyMyFunction;(MyFunction,Integer);;Argument[this].SyntheticField[ArgType0];Argument[0].Parameter[0];value;tb-generated
  // summary=p;TypeBasedComplex;true;applyMyFunction;(MyFunction,Integer);;Argument[0].ReturnValue;Argument[this].SyntheticField[ArgType0];value;tb-generated
  // summary=p;TypeBasedComplex;true;applyMyFunction;(MyFunction,Integer);;Argument[0].ReturnValue;Argument[0].Parameter[0];value;tb-generated
  public Integer applyMyFunction(MyFunction<T, Integer, T> f, Integer x) {
    return null;
  }

  // summary=p;TypeBasedComplex;true;applyMyFunctionGeneric;(MyFunction,Object);;Argument[this].SyntheticField[ArgType0];Argument[0].Parameter[0];value;tb-generated
  // summary=p;TypeBasedComplex;true;applyMyFunctionGeneric;(MyFunction,Object);;Argument[0].ReturnValue;ReturnValue;value;tb-generated
  // summary=p;TypeBasedComplex;true;applyMyFunctionGeneric;(MyFunction,Object);;Argument[1];Argument[0].Parameter[1];value;tb-generated
  public <S1, S2> S2 applyMyFunctionGeneric(MyFunction<T, S1, S2> f, S1 x) {
    return null;
  }

  // summary=p;TypeBasedComplex;true;applyMyFunctionGeneric;(MyFunction,Object,Object);;Argument[0].ReturnValue;ReturnValue;value;tb-generated
  // summary=p;TypeBasedComplex;true;applyMyFunctionGeneric;(MyFunction,Object,Object);;Argument[1];Argument[0].Parameter[0];value;tb-generated
  // summary=p;TypeBasedComplex;true;applyMyFunctionGeneric;(MyFunction,Object,Object);;Argument[2];Argument[0].Parameter[1];value;tb-generated
  public <S1, S2, S3> S3 applyMyFunctionGeneric(MyFunction<S1, S2, S3> f, S1 x, S2 y) {
    return null;
  }
}
