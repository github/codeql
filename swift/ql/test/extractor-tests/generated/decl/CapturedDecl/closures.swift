func bar() -> String {
  return "Hello world!"
}

func foo() {
  let y = 123
  { [x = bar()] () in
     print(x)
     print(y) }()
}
