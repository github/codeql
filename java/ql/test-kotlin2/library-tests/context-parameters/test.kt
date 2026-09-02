// codeql-extractor-kotlin-options: -language-version 2.4 -Xcontext-parameters

class Logger {
    fun log(value: String) = value
}

context(logger: Logger)
fun logged(value: String) = logger.log(value)

context(logger: Logger)
var String.logged: String
    get() = logger.log(this)
    set(value) {
        logger.log(value)
    }

fun use(logger: Logger) = context(logger) {
    val value = logged("message").logged
    "target".logged = value
    value
}
