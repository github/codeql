
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
            constVal
    }
}

const val constVal = 15
