package p;

@FunctionalInterface
public interface MyFunction<T1, T2, T3> {
    T3 apply(T1 x, T2 y);
}