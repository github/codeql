package p;

public class TypeBasedSimple<T> {
    public TypeBasedSimple(T t) {
    }

    public T get() {
        return null;
    }

    public T get(Object o) {
        return null;
    }

    public T id(T x) {
        return null;
    }

    public <S> S id2(S x) {
        return null;
    }

    public void set(T x) {
    }

    public void set(int x, T y) {
    }

    public <S> void set2(S x) { // No summary as S is unrelated to T
    }
}