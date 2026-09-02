do {
  try foo()
} catch MyError.someError(let msg) {
  print(msg)
}
