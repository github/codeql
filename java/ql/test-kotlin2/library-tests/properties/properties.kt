
abstract class properties(val constructorProp: Int, var mutableConstructorProp: Int, extractorArg: Int) {
    var modifiableInt = 1
    val immutableInt = 2
    val typedProp: Int = 3
    abstract val abstractTypeProp: Int
    val initialisedInInit: Int
    init {
        initialisedInInit = 4
    }
    val useConstructorArg = extractorArg
    val five: Int
            get() = 5
    val six
            get() = 6
    var getSet
            get() = modifiableInt
            set(v) { modifiableInt = v }
    val defaultGetter = 7
            get
    var varDefaultGetter = 8
            get
    var varDefaultSetter = 9
            set
    var varDefaultGetterSetter = 10
            get
            set
    var overrideGetter = 11
            get() = 12
    var overrideGetterUseField = 13
            get() = field + 1
    val useField = 14
            get() = field + 1
    lateinit var lateInitVar: String
    private val privateProp = 15
    protected val protectedProp = 16
    public val publicProp = 17
    internal val internalProp = 18
    fun useProps(): Int {
        return 0 +
            constructorProp +
            mutableConstructorProp +
            modifiableInt +
            immutableInt +
            typedProp +
            abstractTypeProp +
            initialisedInInit +
            useConstructorArg +
            five +
            six +
            getSet +
            defaultGetter +
            varDefaultGetter +
            varDefaultSetter +
            varDefaultGetterSetter +
            overrideGetter +
            overrideGetterUseField +
            useField +
            privateProp +
            protectedProp +
            publicProp +
            internalProp +
            constVal
    }
}

const val constVal = 15

class C<T> {
    val prop = 1
    fun fn() {
        val c = C<String>()
        println(c.prop)
    }
}


val Int.x : Int
    get() = 5
val Double.x : Int
    get() = 5

class A {
    private var data: Int = 0

    fun setData(p: Int) {
        data = p
    }
}

class B {
    private var data: Int = 5
        get() = 42

    fun setData(p: Int) {
        data = p
    }
}
