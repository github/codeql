import default
import semmle.code.csharp.ir.PrintIR
//import semmle.code.csharp.ir.implementation.raw.Instruction

//query predicate blockSuccessors(IRBlock pred, IRBlock succ) { succ = pred.getASuccessor() }
//
//query predicate instructions(IRFunction func, IRBlock block, Instruction instruction) {
//  func = block.getEnclosingIRFunction() and
//  instruction.getBlock() = block
//}
//
//from Instruction i, StoreInstruction si
//where i = si.getASuccessor()
//select i, si
//
//from Instruction i1, Instruction i2
//where i1 = i2.getASuccessor() and i1.getAST().fromSource()
//select "Instruction '" + i1 + "' successor to '" + i2 + "'"