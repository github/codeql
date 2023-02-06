class KotlinClass<T> {

  val T.kotlinVal: Int
    get() = 1

}

fun kotlinUser(kc: KotlinClass<String>) = with(kc) { "hello world".kotlinVal }
