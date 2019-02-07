// Based on the .d.ts file from the '@types/q' package (https://github.com/DefinitelyTyped/DefinitelyTyped/blob/master/types/q/index.d.ts)
// which is licensed under the MIT license; see file DefinitelyTyped-LICENSE.
// Type definitions for Q 1.5
// Project: https://github.com/kriskowal/q
// Definitions by: Barrie Nemetchek <https://github.com/bnemetchek>
//                 Andrew Gaspar <https://github.com/AndrewGaspar>
//                 John Reilly <https://github.com/johnnyreilly>
//                 Michel Boudreau <https://github.com/mboudreau>
//                 TeamworkGuy2 <https://github.com/TeamworkGuy2>
// Definitions: https://github.com/DefinitelyTyped/DefinitelyTyped
// TypeScript Version: 2.3

export = Q;

declare namespace Q {
  export type IWhenable<T> = PromiseLike<T> | T;
  export type IPromise<T> = PromiseLike<T>;

  export interface Deferred<T> {
    promise: Promise<T>;
    resolve(value?: IWhenable<T>): void;
  }

  export interface Promise<T> {
    then<U>(onFulfill?: ((value: T) => IWhenable<U>) | null, onReject?: ((error: any) => IWhenable<U>) | null, onProgress?: ((progress: any) => any) | null): Promise<U>;
  }
}
