package p;

import java.util.List;
import java.util.function.Function;

public class TypeBasedComplex<T> {

    public void addMany(List<T> xs) {
        throw null;
    }

    public List<T> getMany() {
        throw null;
    }

    public Integer apply(Function<T, Integer> f) {
        throw null;
    }

    public <T1, T2> T2 apply2(T1 x, Function<T1, T2> f) {
        throw null;
    }

    public TypeBasedComplex<T> flatMap(Function<T, List<T>> f) {
        throw null;
    }

    public <S> TypeBasedComplex<S> flatMap2(Function<T, List<S>> f) {
        throw null;
    }

    public <S> S map(Function<T, S> f) {
        throw null;
    }

    public <S> TypeBasedComplex<S> mapComplex(Function<T, S> f) {
        throw null;
    }

    public TypeBasedComplex<T> returnComplex(Function<T, TypeBasedComplex<T>> f) {
        throw null;
    }

    public void set(Integer x, Function<Integer, T> f) {
        throw null;
    }
}