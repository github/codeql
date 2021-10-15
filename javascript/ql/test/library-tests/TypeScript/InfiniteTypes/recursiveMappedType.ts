interface X {
    a: RecursiveMappedType<this> & X;
    b: boolean;
}

type RecursiveMappedType<V> = {
    [P in keyof V]?: X & RecursiveMappedType<V[P]>
}
