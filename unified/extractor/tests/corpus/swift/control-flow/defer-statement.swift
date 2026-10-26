func withCleanup() {
  defer { print("cleanup") }
  print("work")
}
