public class Test {

  internal val internalVal = 1

  // Would clash with the internal val's getter without name mangling and provoke a database inconsistency:
  fun getInternalVal() = internalVal

  internal var internalVar = 2

  internal fun internalFun() = 3

}

// Diagnostic Matches: Incomplete annotation: @kotlin.Metadata(%)
// Diagnostic Matches: Unknown location for kotlin.Metadata
