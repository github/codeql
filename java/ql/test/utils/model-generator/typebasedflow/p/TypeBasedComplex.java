package p;

import java.util.List;
import java.util.function.Function;

public class TypeBasedComplex<T> {

    public void addMany(List<T> xs) {
    }

    public List<T> getMany() {
        return null;
    }

    public Integer apply(Function<T, Integer> f) {
        return null;
    }

    public <T1, T2> T2 apply2(T1 x, Function<T1, T2> f) {
        return null;
    }

    public TypeBasedComplex<T> flatMap(Function<T, List<T>> f) {
        return null;
    }

    public <S> TypeBasedComplex<S> flatMap2(Function<T, List<S>> f) {
        return null;
    }

    public <S> S map(Function<T, S> f) {
        return null;
    }

    public <S> TypeBasedComplex<S> mapComplex(Function<T, S> f) {
        return null;
    }

    public TypeBasedComplex<T> returnComplex(Function<T, TypeBasedComplex<T>> f) {
        return null;
    }

    public void set(Integer x, Function<Integer, T> f) {
    }

    public Integer applyMyFunction(MyFunction<T, Integer, T> f, Integer x) {
        return null;
    }

    public <S1, S2> S2 applyMyFunctionGeneric(MyFunction<T, S1, S2> f, S1 x) {
        return null;
    }

    public <S1, S2, S3> S3 applyMyFunctionGeneric(MyFunction<S1, S2, S3> f, S1 x, S2 y) {
        return null;
    }
}