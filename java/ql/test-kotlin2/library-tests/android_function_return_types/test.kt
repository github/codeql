package java.util.concurrent

class ConcurrentHashMap<K,V> {
    fun keySet(): MutableSet<K> {
        return null!!
    }

    fun keySet(p: V): KeySetView<K,V>? {
        return null
    }

    class KeySetView<K,V> {
    }
}

class OtherConcurrentHashMap<K,V> {
    fun keySet(): MutableSet<K> {
        return null!!
    }

    fun keySet(p: V): KeySetView<K,V>? {
        return null
    }

    class KeySetView<K,V> {
    }
}
