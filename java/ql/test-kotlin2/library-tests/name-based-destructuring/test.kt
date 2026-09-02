// codeql-extractor-kotlin-options: -XXLanguage:+FullValueClasses -XXLanguage:+NameBasedDestructuring -XXLanguage:+EnableNameBasedDestructuringShortForm

value class Money(val amount: Int, val currency: String)

fun source(): String = ""

fun sink(value: String) {}

fun test(money: Money) {
    val (currency) = money
    sink(currency)
}

fun flow() = test(Money(0, source()))
