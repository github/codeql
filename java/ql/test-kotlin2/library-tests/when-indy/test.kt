// codeql-extractor-kotlin-options: -language-version 2.4 -jvm-target 21 -Xwhen-expressions=indy

fun classify(value: Any): Int =
    when (value) {
        is String -> value.length
        is Int -> value
        else -> -1
    }
