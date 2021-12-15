class Base {
    baseField: number;
}

class Foo extends Base {
    constructor(public x: number, private y: string) {
        super();
    }

    z: string[];

    public m = (x: string) => {};
}
