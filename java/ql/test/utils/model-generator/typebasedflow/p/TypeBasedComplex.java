package p;

import java.util.List;
import java.util.function.Function;

public class TypeBasedComplex<T> {

    // MaD=p;TypeBasedComplex;true;addMany;(List);;Argument[0].Element;Argument[-1].SyntheticField[ArgType0];value;generated
    public void addMany(List<T> xs) {
    }

    // MaD=p;TypeBasedComplex;true;getMany;();;Argument[-1].SyntheticField[ArgType0];ReturnValue.Element;value;generated
    public List<T> getMany() {
        return null;
    }

    // MaD=p;TypeBasedComplex;true;apply;(Function);;Argument[-1].SyntheticField[ArgType0];Argument[0].Parameter[0];value;generated
    public Integer apply(Function<T, Integer> f) {
        return null;
    }

    // A method that doesn't mention `T` in its type signature.
    // This is for testing that we don't generate a summary that involves the
    // implicit field for `T`.
    // MaD=p;TypeBasedComplex;true;apply2;(Object,Function);;Argument[0];Argument[1].Parameter[0];value;generated
    // MaD=p;TypeBasedComplex;true;apply2;(Object,Function);;Argument[1].ReturnValue;ReturnValue;value;generated
    public <T1, T2> T2 apply2(T1 x, Function<T1, T2> f) {
        return null;
    }

    // MaD=p;TypeBasedComplex;true;flatMap;(Function);;Argument[-1].SyntheticField[ArgType0];Argument[0].Parameter[0];value;generated
    // MaD=p;TypeBasedComplex;true;flatMap;(Function);;Argument[-1].SyntheticField[ArgType0];ReturnValue.SyntheticField[ArgType0];value;generated
    // MaD=p;TypeBasedComplex;true;flatMap;(Function);;Argument[0].ReturnValue.Element;Argument[-1].SyntheticField[ArgType0];value;generated
    // MaD=p;TypeBasedComplex;true;flatMap;(Function);;Argument[0].ReturnValue.Element;Argument[0].Parameter[0];value;generated
    // MaD=p;TypeBasedComplex;true;flatMap;(Function);;Argument[0].ReturnValue.Element;ReturnValue.SyntheticField[ArgType0];value;generated
    public TypeBasedComplex<T> flatMap(Function<T, List<T>> f) {
        return null;
    }

    // MaD=p;TypeBasedComplex;true;flatMap2;(Function);;Argument[-1].SyntheticField[ArgType0];Argument[0].Parameter[0];value;generated
    // MaD=p;TypeBasedComplex;true;flatMap2;(Function);;Argument[0].ReturnValue.Element;ReturnValue.SyntheticField[ArgType0];value;generated
    public <S> TypeBasedComplex<S> flatMap2(Function<T, List<S>> f) {
        return null;
    }

    // MaD=p;TypeBasedComplex;true;map;(Function);;Argument[-1].SyntheticField[ArgType0];Argument[0].Parameter[0];value;generated
    // MaD=p;TypeBasedComplex;true;map;(Function);;Argument[0].ReturnValue;ReturnValue;value;generated
    public <S> S map(Function<T, S> f) {
        return null;
    }

    // MaD=p;TypeBasedComplex;true;mapComplex;(Function);;Argument[-1].SyntheticField[ArgType0];Argument[0].Parameter[0];value;generated
    // MaD=p;TypeBasedComplex;true;mapComplex;(Function);;Argument[0].ReturnValue;ReturnValue.SyntheticField[ArgType0];value;generated
    public <S> TypeBasedComplex<S> mapComplex(Function<T, S> f) {
        return null;
    }

    // MaD=p;TypeBasedComplex;true;returnComplex;(Function);;Argument[-1].SyntheticField[ArgType0];Argument[0].Parameter[0];value;generated
    // MaD=p;TypeBasedComplex;true;returnComplex;(Function);;Argument[-1].SyntheticField[ArgType0];ReturnValue.SyntheticField[ArgType0];value;generated
    // MaD=p;TypeBasedComplex;true;returnComplex;(Function);;Argument[0].ReturnValue.SyntheticField[ArgType0];Argument[-1].SyntheticField[ArgType0];value;generated
    // MaD=p;TypeBasedComplex;true;returnComplex;(Function);;Argument[0].ReturnValue.SyntheticField[ArgType0];Argument[0].Parameter[0];value;generated
    // MaD=p;TypeBasedComplex;true;returnComplex;(Function);;Argument[0].ReturnValue.SyntheticField[ArgType0];ReturnValue.SyntheticField[ArgType0];value;generated
    public TypeBasedComplex<T> returnComplex(Function<T, TypeBasedComplex<T>> f) {
        return null;
    }

    // MaD=p;TypeBasedComplex;true;set;(Integer,Function);;Argument[1].ReturnValue;Argument[-1].SyntheticField[ArgType0];value;generated
    public void set(Integer x, Function<Integer, T> f) {
    }

    // MaD=p;TypeBasedComplex;true;applyMyFunction;(MyFunction,Integer);;Argument[-1].SyntheticField[ArgType0];Argument[0].Parameter[0];value;generated
    // MaD=p;TypeBasedComplex;true;applyMyFunction;(MyFunction,Integer);;Argument[0].ReturnValue;Argument[-1].SyntheticField[ArgType0];value;generated
    // MaD=p;TypeBasedComplex;true;applyMyFunction;(MyFunction,Integer);;Argument[0].ReturnValue;Argument[0].Parameter[0];value;generated
    public Integer applyMyFunction(MyFunction<T, Integer, T> f, Integer x) {
        return null;
    }

    // MaD=p;TypeBasedComplex;true;applyMyFunctionGeneric;(MyFunction,Object);;Argument[-1].SyntheticField[ArgType0];Argument[0].Parameter[0];value;generated
    // MaD=p;TypeBasedComplex;true;applyMyFunctionGeneric;(MyFunction,Object);;Argument[0].ReturnValue;ReturnValue;value;generated
    // MaD=p;TypeBasedComplex;true;applyMyFunctionGeneric;(MyFunction,Object);;Argument[1];Argument[0].Parameter[1];value;generated
    public <S1, S2> S2 applyMyFunctionGeneric(MyFunction<T, S1, S2> f, S1 x) {
        return null;
    }

    // MaD=p;TypeBasedComplex;true;applyMyFunctionGeneric;(MyFunction,Object,Object);;Argument[0].ReturnValue;ReturnValue;value;generated
    // MaD=p;TypeBasedComplex;true;applyMyFunctionGeneric;(MyFunction,Object,Object);;Argument[1];Argument[0].Parameter[0];value;generated
    // MaD=p;TypeBasedComplex;true;applyMyFunctionGeneric;(MyFunction,Object,Object);;Argument[2];Argument[0].Parameter[1];value;generated
    public <S1, S2, S3> S3 applyMyFunctionGeneric(MyFunction<S1, S2, S3> f, S1 x, S2 y) {
        return null;
    }
}