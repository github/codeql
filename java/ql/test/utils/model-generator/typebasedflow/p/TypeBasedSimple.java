package p;

public class TypeBasedSimple<T> {
    public TypeBasedSimple(T t) {
        throw null;
    }

    public T get() {
        throw null;
    }

    public T get(Object o) {
        return null;
    }

    public T id(T x) {
        throw null;
    }

    public <S> S id2(S x) {
        throw null;
    }

    public void set(T x) {
        throw null;
    }

    public void set(int x, T y) {
        throw null;
    }

    public <S> void set2(S x) { // No summary as S is unrelated to T
        throw null;
    }
}