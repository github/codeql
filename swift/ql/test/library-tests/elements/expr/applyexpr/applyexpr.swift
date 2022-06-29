
func foo(_ bar: () -> ()) {
  bar()
}

foo({ print("I am a lambda :wave:") })
