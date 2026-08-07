switch event {
case let .received(.some(value), timestamp):
  print(value, timestamp)
default:
  break
}
