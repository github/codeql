// Based on the .d.ts file from the '@types/es6-promise' package (https://github.com/stefanpenner/es6-promise/blob/master/es6-promise.d.ts),
// licensed under the MIT license; see file es6-promise-LICENSE.

export interface Thenable <R> {
  then <U> (onFulfilled?: (value: R) => U | Thenable<U>, onRejected?: (error: any) => U | Thenable<U>): Thenable<U>;
  then <U> (onFulfilled?: (value: R) => U | Thenable<U>, onRejected?: (error: any) => void): Thenable<U>;
}

export type IThenable<T> = Thenable<T>;
