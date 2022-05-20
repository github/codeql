// OK: `SomeInterface` is used in an `implements` clause
import SomeInterface from 'somewhere';

class SomeClass implements SomeInterface {
}
new SomeClass();

import SomethingElse from 'somewhere'; // OK: SomethingElse is used in a type

type T = `Now for ${SomethingElse}`;
