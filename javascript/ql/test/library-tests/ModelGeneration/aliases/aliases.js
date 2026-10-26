export class AliasedClass {
    foo() { return this; }
}

export const Alias1 = AliasedClass;
export const Alias2 = AliasedClass;

export const Alias3 = { x: AliasedClass };
export const Alias4 = { x: Alias3 };
