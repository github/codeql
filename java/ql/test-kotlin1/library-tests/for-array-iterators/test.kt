fun test(x: Array<String>, y: Array<*>, z: IntArray): Int {

  var ret = 0

  for (el in x) { ret += 1 }
  for (el in y) { ret += 1 }
  for (el in z) { ret += 1 }

  return ret 

}
