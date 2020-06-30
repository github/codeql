/**
 * Provides classes that describe the Intermediate Representation (IR) of the program.
 *
 * The IR is a representation of the semantics of the program, with very little dependence on the
 * syntax that was used to write the program. For example, in C++, the statements `i += 1;`, `i++`,
 * and `++i` all have the same semantic effect, but appear in the AST as three different types of
 * `Expr` node. In the IR, all three statements are broken down into a sequence of fundamental
 * operations similar to:
 *
 * ```
 * r1(int*) = VariableAddress[i]  // Compute the address of variable `i`
 * r2(int) = Load &:r1, m0  // Load the value of `i`
 * r3(int) = Constant[1]  // An integer constant with the value `1`
 * r4(int) = Add r2, r3  // Add `1` to the value of `i`
 * r5(int) = Store &r1, r4  // Store the new value back into the variable `i`
 * ```
 *
 * This allows IR-based analysis to focus on the fundamental operations, rather than having to be
 * concerned with the various ways of expressing those operations in source code.
 *
 * The key classes in the IR are:
 *
 * - `IRFunction` - Contains the IR for an entire function definition, including all of that
 *   function's `Instruction`s, `IRBlock`s, and `IRVariables`.
 * - `Instruction` - A single operation in the IR. An instruction specifies the operation to be
 *   performed, the operands that produce the inputs to that operation, and the type of the result
 *   of the operation. Control flows from an `Instruction` to one of a set of successor
 *   `Instruction`s.
 * - `Operand` - An input value of an `Instruction`. All inputs of an `Instruction` are explicitly
 *   represented as `Operand`s, even if the input was implicit in the source code. An `Operand` has
 *   a link to the `Instruction` that consumes its value (its "use") and a link to the `Instruction`
 *   that produces its value (its "definition").
 * - `IRVariable` - A variable accessed by the IR for a particular function. An `IRVariable` is
 *   created for each variable directly accessed by the function. In addition, `IRVariable`s are
 *   created to represent certain temporary storage locations that do not have explicitly declared
 *   variables in the source code, such as the return value of the function.
 * - `IRBlock` - A "basic block" in the control flow graph of a function. An `IRBlock` contains a
 *   sequence of instructions such that control flow can only enter the block at the first
 *   instruction, and can only leave the block from the last instruction.
 * - `IRType` - The type of a value accessed in the IR. Unlike the `Type` class in the AST, `IRType`
 *   is language-neutral. For example, in C++, `unsigned int`, `char32_t`, and `wchar_t` might all
 *   be represented as the `IRType` `uint4`, a four-byte unsigned integer.
 */

// Most queries should operate on the aliased SSA IR, so that's what we expose
// publicly as the "IR".
import implementation.aliased_ssa.IR
