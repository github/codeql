import kotlin.reflect.KClass

annotation class A(val c1: KClass<*>, val c2: KClass<out CharSequence>, val c3: KClass<String>, val c4: Array<KClass<*>>) { }
