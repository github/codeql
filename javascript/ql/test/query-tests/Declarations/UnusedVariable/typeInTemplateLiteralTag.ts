import { SomeInterface } from 'somwhere1'; // OK
import { AnotherInterface } from 'somwhere2'; // OK
import { foo } from 'somewhere3'; // OK

let x = "world";

console.log(foo<SomeInterface>`Hello world`);
console.log(foo<AnotherInterface>`Hello ${x}`);
