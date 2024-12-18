import kotlin.time.Duration
import kotlin.time.ExperimentalTime
import kotlin.time.TimedValue

class Test {
    fun <T> taint(t: T) = t
    fun sink(a: Any) {}

    @OptIn(ExperimentalTime::class)
    fun test(b: ByteArray,
             f: kotlin.io.FileTreeWalk,
             c1: CharArray,
             c2: CharArray,
             c3: CharArray,) {

        sink(taint(b).copyOf())                     // $ hasTaintFlow
        sink(taint(f).maxDepth(1))                  // $ hasTaintFlow

        val sb = StringBuilder()
        sink(sb.insertRange(0, taint(c1), 0, 0))    // $ hasTaintFlow
        sink(sb)                                    // $ hasTaintFlow

        sink(taint(c2) + c3)                        // $ hasTaintFlow

        val p = Pair(taint("a"), "")
        sink(p)                                     // $ hasTaintFlow=a
        sink(p.component1())                        // $ hasTaintFlow=a
        sink(p.second)

        sink(taint("b").capitalize())                   // $ hasTaintFlow=b
        sink(taint("c").replaceFirstChar { _ -> 'x' })  // $ hasTaintFlow=c

        val t = Triple("", taint("d"), "")
        sink(t)                                     // $ hasTaintFlow=d
        sink(t.component1())
        sink(t.second)                              // $ hasTaintFlow=d

        val p1 = taint("e") to ""
        sink(p1)                                    // $ hasTaintFlow=e
        sink(p1.component1())                       // $ hasTaintFlow=e
        sink(p1.second)

        val l = p.toList()
        sink(l)                                     // $ hasTaintFlow=a
        sink(l[0])                                  // $ hasTaintFlow=a
        for (s in l) {
            sink(s)                                 // $ hasTaintFlow=a
        }

        val tv = TimedValue(taint("f"), Duration.parse(""))
        sink(tv)                                    // $ hasTaintFlow=f
        sink(tv.component1())                       // $ hasTaintFlow=f
        sink(tv.duration)

        val mg0 = MatchGroup(taint("g"), IntRange(0, 10))
        sink(mg0)                                   // $ hasTaintFlow=g
        sink(mg0.value)                             // $ hasTaintFlow=g
        sink(mg0.component2())

        val iv = IndexedValue<String>(5, taint("h"))
        sink(iv)                                    // $ hasTaintFlow=h
        sink(iv.index)
        sink(iv.component2())                       // $ hasTaintFlow=h

        val strings = arrayOf("", taint("i"))
        sink(strings.withIndex())                   // $ hasTaintFlow=i
        sink(strings.withIndex().toList())          // $ hasTaintFlow=i
        sink(strings.withIndex().toList()[0].value) // $ hasTaintFlow=i
        sink(strings.withIndex().toList()[0].index)
        for (x in strings.withIndex()) {
            sink(x.value)                           // $ hasTaintFlow=i
            sink(x.index)
        }
    }
}