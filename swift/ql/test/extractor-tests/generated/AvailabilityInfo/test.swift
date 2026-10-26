if #available(macOS 142, *) {
  print(1)
}

if #unavailable(iOS 10, watchOS 10, macOS 10) {
  print(2)
}

