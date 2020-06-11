import IRFunction
import Instruction
import IRBlock
import IRVariable
import Operand
private import internal.IRImports as Imports
import Imports::EdgeKind
import Imports::IRType
import Imports::MemoryAccessKind

private newtype TIRPropertyProvider = MkIRPropertyProvider()

/**
 * Class that provides additional properties to be dumped for IR instructions and blocks when using
 * the PrintIR module. Libraries that compute additional facts about IR elements can extend the
 * single instance of this class to specify the additional properties computed by the library.
 */
class IRPropertyProvider extends TIRPropertyProvider {
  string toString() { result = "IRPropertyProvider" }

  /**
   * Gets the value of the property named `key` for the specified instruction.
   */
  string getInstructionProperty(Instruction instruction, string key) { none() }

  /**
   * Gets the value of the property named `key` for the specified block.
   */
  string getBlockProperty(IRBlock block, string key) { none() }
}
