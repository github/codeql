type Point = {
  x: int,
  y: int
}

class A<T> {
  x: T;
  m() : Point {}
}

function f() {
  switch(x) {
  case (42):
  }
}

@SomeDecorator
type MyPoint = Point

type T1 = {| bar: string |}

type T2 = (| "red" | "green" | "blue")
