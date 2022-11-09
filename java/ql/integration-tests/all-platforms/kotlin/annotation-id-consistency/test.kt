import kotlin.reflect.KClass

annotation class Ann1(val x: Int, val y: Ann2) { }

annotation class Ann2(val z: String, val w: KClass<*>, val v: IntArray, val u: Array<Ann3>, val t: Array<KClass<*>>) { }

annotation class Ann3(val a: Int) { }

annotation class GenericAnnotation<T : Any>(val x: KClass<T>, val y: Array<KClass<T>>) { }

@Ann1(1, Ann2("Hello", String::class, intArrayOf(1, 2, 3), arrayOf(Ann3(1), Ann3(2)), arrayOf(String::class, Int::class)))
@GenericAnnotation<String>(String::class, arrayOf(String::class, String::class))
class Annotated { }
