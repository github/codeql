public class A {

  @JvmOverloads
  fun <T> genericFunctionWithOverloads(x: T? = null, y: List<T>? = null, z: T? = null): T? = z

}

// Diagnostic Matches: Incomplete annotation: @kotlin.Metadata(%)
// Diagnostic Matches: Unknown location for kotlin.Metadata
// Diagnostic Matches: Completion failure for type: kotlin.jvm.JvmOverloads
// Diagnostic Matches: Completion failure for type: org.jetbrains.annotations.Nullable
// Diagnostic Matches: Unknown location for kotlin.jvm.JvmOverloads
// Diagnostic Matches: Unknown location for org.jetbrains.annotations.Nullable
