package com.github.codeql

// Functions copied from stdlib/jdk7/src/kotlin/AutoCloseable.kt, which is not available within
// kotlinc,
// but allows the `.use` pattern to be applied to JDK7 AutoCloseables:

/**
 * Executes the given [block] function on this resource and then closes it down correctly whether an
 * exception is thrown or not.
 *
 * In case if the resource is being closed due to an exception occurred in [block], and the closing
 * also fails with an exception, the latter is added to the
 * [suppressed][java.lang.Throwable.addSuppressed] exceptions of the former.
 *
 * @param block a function to process this [AutoCloseable] resource.
 * @return the result of [block] function invoked on this resource.
 */
public inline fun <T : AutoCloseable?, R> T.useAC(block: (T) -> R): R {
    var exception: Throwable? = null
    try {
        return block(this)
    } catch (e: Throwable) {
        exception = e
        throw e
    } finally {
        this.closeFinallyAC(exception)
    }
}

/**
 * Closes this [AutoCloseable], suppressing possible exception or error thrown by
 * [AutoCloseable.close] function when it's being closed due to some other [cause] exception
 * occurred.
 *
 * The suppressed exception is added to the list of suppressed exceptions of [cause] exception.
 */
fun AutoCloseable?.closeFinallyAC(cause: Throwable?) =
    when {
        this == null -> {}
        cause == null -> close()
        else ->
            try {
                close()
            } catch (closeException: Throwable) {
                cause.addSuppressed(closeException)
            }
    }
