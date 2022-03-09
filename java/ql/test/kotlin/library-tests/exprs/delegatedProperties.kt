import kotlin.properties.ReadWriteProperty
import kotlin.reflect.KProperty

class ClassProp1 {
    fun fn() {
        val prop1: Int by lazy {
            println("init")
            5
        }
        println(prop1)
        println(prop1)
    }
}

class Resource

class Owner {
    fun fn(map: Map<String, Any?>) {
        var varResource1: Int by ResourceDelegate()
        println(varResource1)
        varResource1 = 2

        val name: String by map

        fun resourceDelegate(): ReadWriteProperty<Any?, Int> = object : ReadWriteProperty<Any?, Int> {
            var curValue = 0
            override fun getValue(thisRef: Any?, property: KProperty<*>): Int = curValue
            override fun setValue(thisRef: Any?, property: KProperty<*>, value: Int) {
                curValue = value
            }
        }

        val readOnly: Int by resourceDelegate()  // ReadWriteProperty as val
        var readWrite: Int by resourceDelegate()
    }
}

class ResourceDelegate {
    operator fun getValue(thisRef: Owner?, property: KProperty<*>): Int {
        return 1
    }
    operator fun setValue(thisRef: Owner?, property: KProperty<*>, value: Int?) {
    }
}
