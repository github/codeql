
// --- stubs ---

// --- tests ---

func source(_ label: String) -> Int { return 0 }
func sink(arg: Any) {}

// ---

func testSet(ix: Int) {
  let goodSet = Set([1, 2, 3])
  sink(arg: goodSet)
  sink(arg: goodSet.randomElement()!)
  sink(arg: goodSet.min()!)
  sink(arg: goodSet.max()!)
  sink(arg: goodSet.firstIndex(of: 1)!)
  sink(arg: goodSet[goodSet.firstIndex(of: 1)!])
  sink(arg: goodSet.first!)
  for elem in goodSet {
    sink(arg: elem)
  }

  let taintedSet = Set([1, 2, source("t1")])
  sink(arg: taintedSet) // $ tainted=t1
  sink(arg: taintedSet.randomElement()!) // $ tainted=t1
  sink(arg: taintedSet.min()!) // $ tainted=t1
  sink(arg: taintedSet.max()!) // $ tainted=t1
  sink(arg: taintedSet.firstIndex(of: source("t2"))!)
  sink(arg: taintedSet[taintedSet.firstIndex(of: source("t3"))!]) // $ tainted=t1
  sink(arg: taintedSet.first!) // $ MISSING: tainted=t1
  for elem in taintedSet {
    sink(arg: elem) // $ tainted=t1
  }
  for (ix, elem) in taintedSet.enumerated() {
    sink(arg: ix)
    sink(arg: elem) // $ tainted=t1
  }
  taintedSet.forEach {
    elem in
    sink(arg: elem) // $ tainted=t1
  }

  var set1 = Set<Int>()
  set1.insert(1)
  sink(arg: set1.randomElement()!)
  set1.insert(source("t4"))
  sink(arg: set1.randomElement()!) // $ tainted=t4
  set1.insert(2)
  sink(arg: set1.randomElement()!) // $ tainted=t4
  set1.removeAll()
  sink(arg: set1.randomElement()!) // $ SPURIOUS: tainted=t4

  var set2 = Set<Int>()
  set2.update(with: source("t5"))
  sink(arg: set2.randomElement()!) // $ tainted=t5

  var set3 = Set([source("t6")])
  sink(arg: set3.randomElement()!) // $ tainted=t6
  let (inserted, previous) = set3.insert(source("t7"))
  sink(arg: inserted)
  sink(arg: previous) // $ tainted=t7
  let previous2 = set3.update(with: source("t8"))
  sink(arg: previous2!) // $ tainted=t8
  let previous3 = set3.remove(source("t9"))
  sink(arg: previous3!) // $ tainted=t9
  let previous4 = set3.removeFirst()
  sink(arg: previous4) // $ tainted=t6 tainted=t7 tainted=t8
  let previous5 = set3.remove(at: set3.firstIndex(of: source("t10"))!)
  sink(arg: previous5) // $ tainted=t6 tainted=t7 tainted=t8

  sink(arg: goodSet.union(goodSet).randomElement()!)
  sink(arg: goodSet.union(taintedSet).randomElement()!) // $ tainted=t1
  sink(arg: taintedSet.union(goodSet).randomElement()!) // $ tainted=t1
  sink(arg: taintedSet.union(taintedSet).randomElement()!) // $ tainted=t1

  var set4 = Set<Int>()
  set4.formUnion(goodSet)
  sink(arg: set4.randomElement()!)
  set4.formUnion(taintedSet)
  sink(arg: set4.randomElement()!) // $ tainted=t1
  set4.formUnion(goodSet)
  sink(arg: set4.randomElement()!) // $ tainted=t1

  sink(arg: goodSet.intersection(goodSet).randomElement()!)
  sink(arg: goodSet.intersection(taintedSet).randomElement()!)
  sink(arg: taintedSet.intersection(goodSet).randomElement()!) // $ SPURIOUS: tainted=t1
  sink(arg: taintedSet.intersection(taintedSet).randomElement()!) // $ tainted=t1

  sink(arg: goodSet.symmetricDifference(goodSet).randomElement()!)
  sink(arg: goodSet.symmetricDifference(taintedSet).randomElement()!) // $ tainted=t1
  sink(arg: taintedSet.symmetricDifference(goodSet).randomElement()!) // $ tainted=t1
  sink(arg: taintedSet.symmetricDifference(taintedSet).randomElement()!) // $ tainted=t1

  sink(arg: goodSet.subtracting(goodSet).randomElement()!)
  sink(arg: goodSet.subtracting(taintedSet).randomElement()!)
  sink(arg: taintedSet.subtracting(goodSet).randomElement()!) // $ tainted=t1
  sink(arg: taintedSet.subtracting(taintedSet).randomElement()!) // $ tainted=t1

  sink(arg: taintedSet.sorted().randomElement()!) // $ tainted=t1
  sink(arg: taintedSet.shuffled().randomElement()!) // $ tainted=t1

  sink(arg: taintedSet.lazy[taintedSet.firstIndex(of: source("t11"))!]) // $ MISSING: tainted=t1

  var it = taintedSet.makeIterator()
  sink(arg: it.next()!) // $ tainted=t1
}
