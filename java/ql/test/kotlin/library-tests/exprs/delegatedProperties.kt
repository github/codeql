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

        println(varResource0)
        varResource0 = 3

        val varResource2: Int by DelegateProvider()
    }

    var varResource0: Int by ResourceDelegate()
}

class ResourceDelegate {
    operator fun getValue(thisRef: Owner?, property: KProperty<*>): Int {
        return 1
    }
    operator fun setValue(thisRef: Owner?, property: KProperty<*>, value: Int?) {
    }
}

class DelegateProvider {
    operator fun provideDelegate(thisRef: Owner?, prop: KProperty<*>): ResourceDelegate {
        // ... some logic
        return ResourceDelegate()
    }
}

var topLevelInt: Int = 0

class ClassWithDelegate(val anotherClassInt: Int)
open class Base(val baseClassInt: Int)

class MyClass(var memberInt: Int, val anotherClassInstance: ClassWithDelegate) : Base(memberInt) {
    var delegatedToMember1: Int by this::memberInt
    var delegatedToMember2: Int by MyClass::memberInt

    var delegatedToExtMember1: Int by this::extDelegated
    var delegatedToExtMember2: Int by MyClass::extDelegated

    val delegatedToBaseClass1: Int by this::baseClassInt
    val delegatedToBaseClass2: Int by Base::baseClassInt

    val delegatedToAnotherClass1: Int by anotherClassInstance::anotherClassInt

    var delegatedToTopLevel: Int by ::topLevelInt

    val max: Int by Integer::MAX_VALUE

    fun fn(){
        var delegatedToMember3: Int by this::memberInt
        fn()
    }
}

var MyClass.extDelegated: Int by ::topLevelInt
