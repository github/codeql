public class HasFields {

  companion object {
  
    const val constField = "taint"

    lateinit var lateinitField: String

    @JvmField val jvmFieldAnnotatedField = "taint"

  }

  fun doLateInit() {
    lateinitField = "taint"
  }

}
