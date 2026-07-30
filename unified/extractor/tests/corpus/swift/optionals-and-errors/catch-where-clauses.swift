do {
  try foo()
} catch let e where isNetworkError(e), let f where isTimeout(f) {
  print("retry")
} catch {
  print("fallback")
}
