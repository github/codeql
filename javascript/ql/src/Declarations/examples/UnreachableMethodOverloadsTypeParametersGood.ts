interface Foo {
    create(a: string): Array<any>;
    create<T>(a: string): Array<T>;
}