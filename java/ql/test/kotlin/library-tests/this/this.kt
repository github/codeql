
class Outer {
    inner class Inner {
        fun someFun() {
            val x1: Inner = this
            val x2: Inner = this@Inner
            val x3: Outer = this@Outer

            val labelledExtensionFun = someLabelledExtensionFun@ fun ExtensionClass.() {
                val x4: ExtensionClass = this
                val x5: ExtensionClass = this@someLabelledExtensionFun
            }

            val unLabelledExtensionFun = fun ExtensionClass.() {
                val x6: ExtensionClass = this
            }

            val someLambda = { i: Int ->
                val x7: Inner = this
            }
        }

        fun ExtensionClass.extensionFun() {
            val x1: ExtensionClass = this
            val x2: Inner = this@Inner
            val x3: Outer = this@Outer
            val x4: ExtensionClass = this@extensionFun
        }

        fun innerCaller() {
            topLevelFun()
            outerFun()
            innerFun()
            topLevelOuterFun()
            topLevelInnerFun()
            outerInnerFun()
            topLevelOuterInnerFun()
            this.innerFun()
            this.topLevelInnerFun()
            this.outerInnerFun()
            this.topLevelOuterInnerFun()
        }

        fun innerFun() {}
        fun topLevelInnerFun() {}
        fun outerInnerFun() {}
        fun topLevelOuterInnerFun() {}
    }
    fun outerFun() {}
    fun topLevelOuterFun() {}
    fun outerInnerFun() {}
    fun topLevelOuterInnerFun() {}
}
fun topLevelFun() {}
fun topLevelOuterFun() {}
fun topLevelInnerFun() {}
fun topLevelOuterInnerFun() {}

class ExtensionClass {
}
