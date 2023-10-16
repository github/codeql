func loop() {
  label1: for i in 1...5 {
    if i == 3 {
        break
    } else {
        continue
    }
  }
  var i = 0
  label2: while (i < 12) {
    i = i + 1
  }

  i = 0
  label3: repeat {
    i = i + 1
  } while (i < 12)

  do {
    try failure(11)
  } catch {
    print("error")
  }

  do {
    try failure(11)
  } catch AnError.failed {
    print("AnError.failed")
  } catch {
    print("error")
  }
}

enum AnError: Error {
  case failed
}

func failure(_ x: Int) throws {
  guard x != 0 else {
    throw AnError.failed
  }
}

defer {
  print("done")
}

do {
  print("doing")
}

let index = 42
switch index {
   case 1:
      print("1")
      fallthrough
   case 5, 10:
      print("5, 10")
      break
   default:
      print("default")
}

let x: Int? = 4
if case let xx? = x {
}
if case .some(_) = x {
}

let numbers = [1, 2, 3]
for number in numbers where number % 2 == 0 {
}

struct HasModifyAccessorDecl {
  var x : Int
  var hasModify : Int {
    _modify {
      yield &x
    }

    get {
      return 0
    }
  }
}

if #available(macOS 155, *) {
  print(155)
}

if #unavailable(macOS 42) {
  print(42)
}
