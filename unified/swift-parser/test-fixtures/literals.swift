let values = (42, 0xff, 0b1010, 1_000, 1.25, 2e-3, true, false, nil)
let strings = ("", "hello", "one\ntwo\r", "\(values.0)!", #"raw \ text"#)
let array = [1, 2, 3,]
let dictionary = ["one": 1, "two": 2]
let emptyDictionary = [:]
let result = -values.0 + 2 * 3
let cast = result as? Double
let check = result is Int
