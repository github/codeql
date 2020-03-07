@Component(Foo) // OK
class Foo {}

declare class Bar extends Baz {} // OK
declare class Baz {}

export type { I }; // OK - does not refer to the constant 'I'

const I = 45;

interface I {}
