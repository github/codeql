import zpkg.A

class KotlinAnnotatedMethods {

  @A fun f(@A m: AnnotatedMethods): String = m.notNullAnnotated("hello") + m.nullableAnnotated("world")!!

}

class KotlinDelegate(c: AnnotatedMethods) : AnnotatedInterface by c { }
