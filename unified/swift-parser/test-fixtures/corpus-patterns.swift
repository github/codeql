if let (first, second) = pair { print(first, second) }
switch value {
case .success(let (first, second)): print(first, second)
case let (first?, second?): print(first, second)
default: break
}
do { try work() } catch CocoaError.fileWriteNoPermission where isDirectory { print(error) }
func typePatterns(_ value: (Int, Any)) {
    guard case let (x, is String) = value else { return }
    if case let (x, Self) = value { use(x) }
}
