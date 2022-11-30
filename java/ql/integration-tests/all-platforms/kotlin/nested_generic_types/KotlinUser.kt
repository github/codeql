package testuser

import extlib.*

class User {

  fun test() {

    val a = OuterGeneric<Int>().InnerGeneric<String, Char>('a')
    val a2 = OuterGeneric<Int>().InnerGeneric('a', "hello world")
    val b = OuterGeneric<Int>().InnerNotGeneric()
    val b2 = OuterGeneric<String>().InnerNotGeneric()
    val c = OuterNotGeneric().InnerGeneric<String>()
    val d = OuterGeneric.InnerStaticGeneric('a', "hello world")
    val e = OuterManyParams(1, "hello").MiddleManyParams(1.0f, 1.0).InnerManyParams(1L, 1.toShort())

    val result1 = a.returnsecond(0, "hello")
    val result1a = a.returnsecond(0, "hello", 'a')
    val result2 = b.identity(5)
    val result2b = b2.identity("hello")
    val result3 = c.identity("world")
    val result4 = d.identity("goodbye")
    val result5 = e.returnSixth(1, "hello", 1.0f, 1.0, 1L, 1.toShort())

    val innerGetterTest = OuterGeneric<String>().getInnerNotGeneric()
    val innerGetterTest2 = OuterNotGeneric().getInnerGeneric()

    val tpv = TypeParamVisibility<String>()
    val visibleBecauseInner = tpv.getVisibleBecauseInner();
    val visibleBecauseInnerIndirect = tpv.getVisibleBecauseInnerIndirect()
    val notVisibleBecauseStatic = tpv.getNotVisibleBecauseStatic()
    val notVisibleBecauseStaticIndirect = tpv.getNotVisibleBecauseStaticIndirect()

  }

}
