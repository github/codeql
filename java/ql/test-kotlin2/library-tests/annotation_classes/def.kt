@file:Annot0k

import kotlin.reflect.KClass

@Target(AnnotationTarget.CLASS,
    AnnotationTarget.ANNOTATION_CLASS,
    AnnotationTarget.TYPE_PARAMETER,
    AnnotationTarget.PROPERTY,
    AnnotationTarget.FIELD,
    AnnotationTarget.LOCAL_VARIABLE,    // TODO
    AnnotationTarget.VALUE_PARAMETER,
    AnnotationTarget.CONSTRUCTOR,
    AnnotationTarget.FUNCTION,
    AnnotationTarget.PROPERTY_GETTER,
    AnnotationTarget.PROPERTY_SETTER,
    AnnotationTarget.TYPE,              // TODO
    //AnnotationTarget.EXPRESSION,      // TODO
    AnnotationTarget.FILE,              // TODO
    AnnotationTarget.TYPEALIAS          // TODO
)
annotation class Annot0k(@get:JvmName("a") val abc: Int = 0)

@Annot0k
annotation class Annot1k(
    val a: Int = 2,
    val b: String = "ab",
    val c: KClass<*> = X::class,
    val d: Y = Y.A,
    val e: Array<Y> = [Y.A, Y.B],
    val f: Annot0k = Annot0k(1)
)

class X {}
enum class Y {
    A,B,C
}

@Annot0k(abc = 1)
@Annot1k(d = Y.B, e = arrayOf(Y.C, Y.A))
class Z {
    @Annot0k
    constructor(){}
}

@Annot0k
fun <@Annot0k T> fn(@Annot0k a: Annot0k) {
    println(a.abc)

    @Annot0k
    var x = 10
}

@Annot0k
@get:Annot0k
@set:Annot0k
@field:Annot0k
var p: @Annot0k Int = 5

fun @receiver:Annot0k String.myExtension() { }

@Annot0k
typealias AAA = Z
