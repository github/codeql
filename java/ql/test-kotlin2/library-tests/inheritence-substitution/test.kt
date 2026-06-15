package main

open class SimpleInvariant<E1> { }

open class NestedInvariant<E2> : SimpleInvariant<SimpleInvariant<E2>>() { }

class NestedCovariant<E3> : SimpleInvariant<SimpleInvariant<out E3>>() { }

class NestedContravariant<E4> : SimpleInvariant<SimpleInvariant<in E4>>() { }

class DoubleInherit<E5> : NestedInvariant<E5>() { }

fun user(
  p1: SimpleInvariant<String>,
  p2: SimpleInvariant<out String>,
  p3: SimpleInvariant<in String>,
  p4: SimpleInvariant<*>,
  p5: NestedInvariant<String>,
  p6: NestedInvariant<out String>,
  p7: NestedInvariant<in String>,
  p8: NestedInvariant<*>,
  p9: NestedCovariant<String>,
  p10: NestedCovariant<out String>,
  p11: NestedCovariant<in String>,
  p12: NestedCovariant<*>,
  p13: NestedContravariant<String>,
  p14: NestedContravariant<out String>,
  p15: NestedContravariant<in String>,
  p16: NestedContravariant<*>,
  p17: DoubleInherit<String>,
  p18: DoubleInherit<in String>,
  p19: DoubleInherit<out String>,
  p20: DoubleInherit<*>
) {

}