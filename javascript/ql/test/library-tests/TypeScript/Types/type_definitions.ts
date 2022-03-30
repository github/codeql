import * as dummy from "./dummy";

interface I<S> {
  x: S;
}
let i: I<number>

class C<T> {
  x: T
}
let c: C<number>;

enum Color {
  red, green, blue
}
let color: Color;

enum EnumWithOneMember { member }
let e: EnumWithOneMember;

type Alias<T> = T[];
let aliasForNumberArray: Alias<number>;
