switch event {
case let .received(.some(value), timestamp):
  print(value, timestamp)
case Type.some(let value):
  print(value)
default:
  break
}
