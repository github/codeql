import kotlin.reflect.KClass

annotation class Ann1(val x: Int, val y: Ann2) { }

annotation class Ann2(val z: String, val w: KClass<*>, val v: IntArray, val u: Array<Ann3>) { }

annotation class Ann3(val a: Int) { }

@Ann1(1, Ann2("Hello", String::class, intArrayOf(1, 2, 3), arrayOf(Ann3(1), Ann3(2))))
class Annotated { }
