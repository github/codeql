abstract class C {
    abstract f(x: string);
    abstract f(x: number);
}

class D extends C {
    f(x: string);
    f(x: number);
    f(x: any) {}
}

interface I {
    interfaceMethod();
    x: number;
}
