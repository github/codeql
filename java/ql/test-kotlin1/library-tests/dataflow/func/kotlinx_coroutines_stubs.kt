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
