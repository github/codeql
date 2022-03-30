declare module "test" {
  declare type Foo = {|
  |};

  declare type Bar = {|
    baz: () => Promise<?Foo>
  |};
}
