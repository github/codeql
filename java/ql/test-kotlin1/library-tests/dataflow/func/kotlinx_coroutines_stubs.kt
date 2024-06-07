/**
 * Stubs for `kotlinx.coroutines`
 */

@file:JvmName("BuildersKt") // Required for `async`

package kotlinx.coroutines

public interface CoroutineScope
public interface CoroutineContext
public enum class CoroutineStart { DEFAULT }
public interface Job
public interface Deferred<out T> : Job {
    public suspend fun await(): T
}

public object GlobalScope : CoroutineScope

public fun CoroutineScope.launch(
    context: CoroutineContext = null!!,
    start: CoroutineStart = CoroutineStart.DEFAULT,
    block: suspend CoroutineScope.() -> Unit
): Job {
    return null!!
}

public fun <T> CoroutineScope.async(
    context: CoroutineContext = null!!,
    start: CoroutineStart = CoroutineStart.DEFAULT,
    block: suspend CoroutineScope.() -> T
): Deferred<T> {
    return null!!
}

// Diagnostic Matches: % Couldn't get owner of KDoc. The comment is extracted without an owner.  ...while extracting a file (kotlinx_coroutines_stubs.kt) at %kotlinx_coroutines_stubs.kt:1:1:36:0%
