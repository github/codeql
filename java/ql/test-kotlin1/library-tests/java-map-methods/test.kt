fun test(m: Map<Int, Int>) = m.getOrDefault(1, 2)

fun test2(s: String) = s.length

fun remove(l: MutableList<Int>) {
    l.remove(5)
}

fun fn1(s: String) = s.plus(other = "")
fun fn2(s: String) = s + ""

fun fn1(i: Int) = i.minus(10)
fun fn2(i: Int) = i - 10

fun special(n: Number, m: Map<String, String>, s: String, l: MutableList<Int>) {
    s[1]
    s.get(1)
    n.toDouble()
    n.toByte()
    n.toChar()
    n.toFloat()
    n.toInt()
    n.toShort()
    m.keys
    m.values
    m.entries
    l.removeAt(1)
    m.entries.first().key
    m.entries.first().value
}

// Diagnostic Matches: % Couldn't find a Java equivalent function to kotlin.Number.toChar in java.lang.Number %
