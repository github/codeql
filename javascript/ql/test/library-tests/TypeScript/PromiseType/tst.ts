import * as Q from "q";
import { Thenable, IThenable } from "./es6-promise";
import * as promise from "./promise";

interface MyPromise<T = any> {
  then(callback: (x: T) => any): MyPromise<T>;
}

let p1: MyPromise<string>;
let p2: MyPromise;
let p3: Promise<string>;
let p4: Q.IPromise<string>;
let p5: PromiseLike<string>;
let p6: Thenable<string>;
let p7: IThenable<string>;
let p8: promise.ThenPromise<string>;
let p9: JQueryPromise<string>;
let p10: JQueryGenericPromise<string>;
let p11: JQueryDeferred<string>;

interface NotPromise<T> {
  then(x: T): T;
}
interface WrongName<T> {
  then(callback: (x:T) => any): WrongName<T>;
}
interface StringPromise {
  then(callback: (x: string) => any): StringPromise;
}
let notPromise1: NotPromise<string>;
let notPromise2: WrongName<string>;
let notPromise3: StringPromise;
let notPromise4: Q.Deferred<string>; // different API - lacks 'then' method

