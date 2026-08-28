// codeql-extractor-kotlin-options: -language-version 2.4 -Xcontext-parameters

class Logger {
    fun log(value: String) = value
}

context(logger: Logger)
fun logged(value: String) = logger.log(value)

context(logger: Logger)
val String.logged: String
    get() = logger.log(this)

fun use(logger: Logger) = context(logger) {
    logged("message").logged
}
