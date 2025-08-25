import kotlinx.coroutines.*

suspend fun fn() {
    GlobalScope.launch {
        val x: Deferred<String> = async { Helper.taint() }
        Helper.sink(x.await())                                  // TODO: not found
    }
}
