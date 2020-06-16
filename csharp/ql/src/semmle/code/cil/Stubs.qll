/**
 * Provides classes and predicates for identifying stub code.
 */

import CIL

/**
 * The average number of instructions per method,
 * below which an assembly is probably a stub.
 */
private float stubInstructionThreshold() { result = 5.1 }

cached
private module Cached {
  /**
   * A simple heuristic for determining whether an assembly is a
   * reference assembly where the method bodies have dummy implementations.
   * Look at the average number of instructions per method.
   */
  cached
  predicate assemblyIsStubImpl(Assembly asm) {
    exists(int totalInstructions, int totalImplementations |
      totalInstructions = count(Instruction i | i.getImplementation().getLocation() = asm) and
      totalImplementations =
        count(MethodImplementation i | i.getImplementation().getLocation() = asm) and
      totalInstructions.(float) / totalImplementations.(float) < stubInstructionThreshold()
    )
  }

  cached
  predicate bestImplementation(MethodImplementation mi) {
    not assemblyIsStubImpl(mi.getLocation()) and
    not exists(MethodImplementation better | mi.getMethod() = better.getMethod() |
      mi.getNumberOfInstructions() < better.getNumberOfInstructions()
      or
      mi.getNumberOfInstructions() = better.getNumberOfInstructions() and
      mi.getLocation().getFile().toString() > better.getLocation().getFile().toString()
    ) and
    exists(mi.getAnInstruction())
  }
}

private import Cached

predicate assemblyIsStub = assemblyIsStubImpl/1;

/**
 * A method implementation that is the "best" one for a particular method,
 * if there are several potential implementations to choose between, and
 * excludes implementations that are probably from stub/reference assemblies.
 */
class BestImplementation extends MethodImplementation {
  BestImplementation() { bestImplementation(this) }
}
