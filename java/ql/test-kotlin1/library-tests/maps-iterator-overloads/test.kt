fun getIter(m: MutableMap<String, Int>): MutableIterator<MutableMap.MutableEntry<String, Int>> = m.iterator()

fun getIter2(m: Map<String, Int>): Iterator<Map.Entry<String, Int>> = m.iterator()
