import extlib.*
import java.util.*

fun test() {

  // Pending better varargs support, avoiding listOf and mutableListOf
  val stringList = ArrayList<String>()
  val objectList = ArrayList<Any>()
  val stringStringList = ArrayList<ArrayList<String>>()

  val lib = Lib()
  lib.testParameterTypes(
    'a',
    1,
    2,
    3,
    4,
    5.0f,
    6.0,
    true,
    Lib(),
    GenericTest<String>(),
    BoundedGenericTest<String>(),
    ComplexBoundedGenericTest<CharSequence, String>(),
    intArrayOf(1),
    arrayOf(1),
    arrayOf(intArrayOf(1)),
    arrayOf(arrayOf(1)),
    arrayOf(stringList),
    stringList,
    objectList,
    stringStringList,
    objectList)

  val returnedList = lib.returnErasureTest()
  lib.paramErasureTest<Int>(listOf("Hello"))

  // Check trap labelling consistency for methods that instantiate a generic type
  // with its own generic parameters -- for example, class MyList<T> { void addAll(MyList<T> l) { } },
  // which has the trap labelling oddity of looking like plain MyList, not MyList<T>, even though
  // this is a generic instantiation.
  val takesSelfTest = GenericTest<String>()
  takesSelfTest.takesSelfMethod(takesSelfTest)

}
