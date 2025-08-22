import kotlin.reflect.KClass
import java.time.DayOfWeek

annotation class Ann1(val x: Int, val y: Ann2, val z: DayOfWeek) { }

annotation class Ann2(val z: String, val w: KClass<*>, val v: IntArray, val u: Array<Ann3>, val t: Array<KClass<*>>) { }

annotation class Ann3(val a: Int) { }

annotation class GenericAnnotation<T : Any>(val x: KClass<T>, val y: Array<KClass<T>>) { }

@Repeatable
annotation class VarargAnnotation(vararg val x: Int) { }

annotation class AnnWithDefaults(val x: Int = 1, val y: String = "hello", val z: DayOfWeek = DayOfWeek.TUESDAY, val w: Array<Ann3> = [Ann3(1)]) { }

@Ann1(1, Ann2("Hello", String::class, intArrayOf(1, 2, 3), arrayOf(Ann3(1), Ann3(2)), arrayOf(String::class, Int::class)), DayOfWeek.MONDAY)
@GenericAnnotation<String>(String::class, arrayOf(String::class, String::class))
@VarargAnnotation
@VarargAnnotation(1)
@VarargAnnotation(1, 2)
@VarargAnnotation(*[1, 2, 3])
@VarargAnnotation(*intArrayOf(1, 2, 3))
@AnnWithDefaults
class Annotated { }

@Ann1(1, Ann2("Hello", String::class, intArrayOf(1, 2, 3), arrayOf(Ann3(1), Ann3(2)), arrayOf(String::class, Int::class)), DayOfWeek.MONDAY)
@GenericAnnotation<String>(String::class, arrayOf(String::class, String::class))
@VarargAnnotation
@VarargAnnotation(1)
@VarargAnnotation(1, 2)
@VarargAnnotation(*[1, 2, 3])
@VarargAnnotation(*intArrayOf(1, 2, 3))
@AnnWithDefaults
class AnnotatedUsedByKotlin { }

@java.lang.Deprecated
class HasJavaDeprecatedAnnotationUsedByJava

@kotlin.Deprecated("Kotlin deprecation message 1")
class HasKotlinDeprecatedAnnotationUsedByJava

@java.lang.Deprecated
class HasJavaDeprecatedAnnotationUsedByKotlin

@kotlin.Deprecated("Kotlin deprecation message 2")
class HasKotlinDeprecatedAnnotationUsedByKotlin
