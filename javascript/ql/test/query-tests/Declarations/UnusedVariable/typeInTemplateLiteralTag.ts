import { SomeInterface } from 'somwhere1';
import { AnotherInterface } from 'somwhere2';
import { foo } from 'somewhere3';

let x = "world";

console.log(foo<SomeInterface>`Hello world`);
console.log(foo<AnotherInterface>`Hello ${x}`);
