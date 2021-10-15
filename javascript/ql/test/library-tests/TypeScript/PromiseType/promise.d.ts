// Based on the .d.ts file from the 'promise' package (https://github.com/then/promise/blob/master/index.d.ts),
// which is licensed under the MIT license; see file promise-LICENSE.

export interface Thenable<T> {
  then<TResult1 = T, TResult2 = never>(onfulfilled?: ((value: T) => TResult1 | Thenable<TResult1>) | undefined | null, onrejected?: ((reason: any) => TResult2 | Thenable<TResult2>) | undefined | null): Thenable<TResult1 | TResult2>;
}

export interface ThenPromise<T> {
  then<TResult1 = T, TResult2 = never>(onfulfilled?: ((value: T) => TResult1 | Thenable<TResult1>) | undefined | null, onrejected?: ((reason: any) => TResult2 | Thenable<TResult2>) | undefined | null): ThenPromise<TResult1 | TResult2>;
  catch<TResult = never>(onrejected?: ((reason: any) => TResult | Thenable<TResult>) | undefined | null): ThenPromise<T | TResult>;
}
