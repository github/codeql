function f(x: number, y?: string) {
    return (x, y?) => {};
}

class C {
    constructor(x: number, y?: string) {}

    method(x?: number, y?: string) {}
    noTypes(x?) {}
}

interface I {
    m(x?: number);
    field: (x?: number) => void;
    (x: number, y?: string): void;
}

function manyDefaults(x, y?, z?, w?) {}

declare function optionalDestructuring({x, y}?, [w]?);
