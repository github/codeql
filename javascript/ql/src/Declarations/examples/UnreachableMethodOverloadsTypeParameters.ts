interface Foo {
    create<T>(a: string): MyObject<T>;
    create(a: string): MyObject<any>;
}