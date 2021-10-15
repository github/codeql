type B = boolean;

var b: B;

type ValueOrArray<T> = T | Array<ValueOrArray<T>>;

var c: ValueOrArray<number>;

type Json =
    | string
    | number
    | boolean
    | null
    | { [property: string]: Json }
    | Json[];

var json: Json;

type VirtualNode =
    | string
    | [string, { [key: string]: any }, ...VirtualNode[]];

const myNode: VirtualNode =
    ["div", { id: "parent" },
        ["div", { id: "first-child" }, "I'm the first child"],
        ["div", { id: "second-child" }, "I'm the second child"]
    ];
