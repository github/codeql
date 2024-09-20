export class PublicClass {
    publicMethod() {}
}

class SemiInternalClass {
    method() {
        return new PublicClass();
    }
}

export function get() {
    return new SemiInternalClass();
}

export function getAnonymous() {
    return new (class {
        method() {
            return new PublicClass();
        }
    });
}
