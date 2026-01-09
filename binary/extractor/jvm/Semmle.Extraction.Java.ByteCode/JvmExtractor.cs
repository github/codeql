using System.IO.Compression;
using IKVM.ByteCode;
using IKVM.ByteCode.Decoding;
using Semmle.Extraction.Java.ByteCode.Trap;

namespace Semmle.Extraction.Java.ByteCode;

/// <summary>
/// Main extractor - reads Java class files and writes TRAP files.
/// </summary>
public class JvmExtractor
{
    private readonly TrapWriter trap;
    private readonly Dictionary<string, int> classIds = new();
    private readonly Dictionary<string, int> methodIds = new();

    public JvmExtractor(TrapWriter trapWriter)
    {
        trap = trapWriter;
    }

    public void Extract(string inputPath)
    {
        if (inputPath.EndsWith(".jar", StringComparison.OrdinalIgnoreCase))
        {
            ExtractJar(inputPath);
        }
        else if (inputPath.EndsWith(".class", StringComparison.OrdinalIgnoreCase))
        {
            ExtractClassFile(inputPath);
        }
        else
        {
            throw new ArgumentException($"Unsupported file type: {inputPath}");
        }
    }

    private void ExtractJar(string jarPath)
    {
        Console.WriteLine($"Opening JAR: {jarPath}");
        using var archive = ZipFile.OpenRead(jarPath);

        foreach (var entry in archive.Entries)
        {
            if (!entry.FullName.EndsWith(".class", StringComparison.OrdinalIgnoreCase))
                continue;

            // Skip module-info and package-info
            if (entry.Name == "module-info.class" || entry.Name == "package-info.class")
                continue;

            Console.WriteLine($"  Extracting: {entry.FullName}");

            using var stream = entry.Open();
            using var ms = new MemoryStream();
            stream.CopyTo(ms);

            var classBytes = ms.ToArray();
            ExtractClassBytes(classBytes, entry.FullName);
        }
    }

    private void ExtractClassFile(string classPath)
    {
        Console.WriteLine($"Opening class file: {classPath}");
        using var classFile = ClassFile.Read(classPath);
        ExtractClass(classFile, classPath);
    }

    private void ExtractClassBytes(byte[] classBytes, string sourcePath)
    {
        try
        {
            using var classFile = ClassFile.Read(classBytes);
            ExtractClass(classFile, sourcePath);
        }
        catch (Exception ex)
        {
            Console.WriteLine($"  Warning: Failed to parse {sourcePath}: {ex.Message}");
        }
    }

    private void ExtractClass(ClassFile classFile, string sourcePath)
    {
        // Write file info
        var fileId = trap.GetId();
        trap.WriteTuple("files", fileId, sourcePath);

        // Get class name from constant pool - ClassConstant now has Name directly resolved
        var thisClassConstant = classFile.Constants.Get(classFile.This);
        var className = thisClassConstant.Name ?? "UnknownClass";

        // Extract type (class/interface/enum)
        var typeId = trap.GetId();
        var packageName = GetPackageName(className);
        var simpleName = GetSimpleName(className);

        // Normalize class name: replace / with .
        var normalizedClassName = className.Replace('/', '.');

        classIds[normalizedClassName] = typeId;
        trap.WriteTuple("types", typeId, normalizedClassName, packageName, simpleName);

        // Extract fields
        foreach (var field in classFile.Fields)
        {
            ExtractField(field, typeId, classFile);
        }

        // Extract methods
        foreach (var method in classFile.Methods)
        {
            ExtractMethod(method, typeId, classFile, normalizedClassName);
        }
    }

    private void ExtractField(Field field, int typeId, ClassFile classFile)
    {
        var fieldId = trap.GetId();
        var fieldNameUtf8 = classFile.Constants.Get(field.Name);
        var fieldName = fieldNameUtf8.Value;

        trap.WriteTuple("fields", fieldId, fieldName, typeId);
    }

    private void ExtractMethod(Method method, int typeId, ClassFile classFile, string className)
    {
        var methodId = trap.GetId();

        var methodNameUtf8 = classFile.Constants.Get(method.Name);
        var methodName = methodNameUtf8.Value;

        var descriptorUtf8 = classFile.Constants.Get(method.Descriptor);
        var descriptor = descriptorUtf8.Value;

        var signature = BuildMethodSignature(methodName, descriptor);
        var fullMethodName = $"{className}.{methodName}";
        methodIds[fullMethodName] = methodId;

        trap.WriteTuple("methods", methodId, methodName, signature, typeId);

        // Extract access flags as raw bitmask
        trap.WriteTuple("jvm_method_access_flags", methodId, (int)method.AccessFlags);

        // Check if this is a static method (for parameter indexing)
        bool isStatic = (method.AccessFlags & AccessFlag.Static) != 0;

        // Extract parameters from descriptor
        ExtractParameters(methodId, descriptor, isStatic);

        // Extract method body (Code attribute)
        foreach (var attr in method.Attributes)
        {
            var attrNameUtf8 = classFile.Constants.Get(attr.Name);
            var attrName = attrNameUtf8.Value;

            if (attrName == "Code")
            {
                ExtractCode(attr, methodId, classFile, isStatic);
                break;
            }
        }
    }

    private void ExtractParameters(int methodId, string descriptor, bool isStatic)
    {
        // Parse method descriptor like "(Ljava/lang/String;I)V"
        // Parameters are between ( and )

        if (!descriptor.StartsWith("("))
            return;

        int closeParenIdx = descriptor.IndexOf(')');
        if (closeParenIdx < 0)
            return;

        var paramPart = descriptor.Substring(1, closeParenIdx - 1);

        // For instance methods, slot 0 is 'this'
        int paramIndex = isStatic ? 0 : 1;
        int slotIndex = isStatic ? 0 : 1;

        if (!isStatic)
        {
            // Add implicit 'this' parameter
            var thisParamId = trap.GetId();
            trap.WriteTuple("jvm_parameter", thisParamId, methodId, 0, "#this", "Lthis;");
        }

        int i = 0;
        while (i < paramPart.Length)
        {
            var paramId = trap.GetId();
            string paramDescriptor;

            char c = paramPart[i];
            switch (c)
            {
                case 'B': // byte
                case 'C': // char
                case 'F': // float
                case 'I': // int
                case 'S': // short
                case 'Z': // boolean
                    paramDescriptor = c.ToString();
                    trap.WriteTuple("jvm_parameter", paramId, methodId, slotIndex, $"#arg{paramIndex}", paramDescriptor);
                    paramIndex++;
                    slotIndex++;
                    i++;
                    break;

                case 'D': // double (2 slots)
                case 'J': // long (2 slots)
                    paramDescriptor = c.ToString();
                    trap.WriteTuple("jvm_parameter", paramId, methodId, slotIndex, $"#arg{paramIndex}", paramDescriptor);
                    paramIndex++;
                    slotIndex += 2; // doubles and longs take 2 slots
                    i++;
                    break;

                case 'L': // object reference
                    int semiIdx = paramPart.IndexOf(';', i);
                    if (semiIdx >= 0)
                    {
                        paramDescriptor = paramPart.Substring(i, semiIdx - i + 1);
                        trap.WriteTuple("jvm_parameter", paramId, methodId, slotIndex, $"#arg{paramIndex}", paramDescriptor);
                        paramIndex++;
                        slotIndex++;
                        i = semiIdx + 1;
                    }
                    else
                    {
                        i++;
                    }
                    break;

                case '[': // array
                    int arrayStart = i;
                    // Skip array dimensions
                    while (i < paramPart.Length && paramPart[i] == '[')
                        i++;
                    // Get base type
                    if (i < paramPart.Length)
                    {
                        if (paramPart[i] == 'L')
                        {
                            int arrSemiIdx = paramPart.IndexOf(';', i);
                            if (arrSemiIdx >= 0)
                            {
                                paramDescriptor = paramPart.Substring(arrayStart, arrSemiIdx - arrayStart + 1);
                                i = arrSemiIdx + 1;
                            }
                            else
                            {
                                paramDescriptor = paramPart.Substring(arrayStart);
                                i = paramPart.Length;
                            }
                        }
                        else
                        {
                            paramDescriptor = paramPart.Substring(arrayStart, i - arrayStart + 1);
                            i++;
                        }
                        trap.WriteTuple("jvm_parameter", paramId, methodId, slotIndex, $"#arg{paramIndex}", paramDescriptor);
                        paramIndex++;
                        slotIndex++;
                    }
                    break;

                default:
                    i++;
                    break;
            }
        }
    }

    private void ExtractCode(IKVM.ByteCode.Decoding.Attribute attr, int methodId, ClassFile classFile, bool isStatic)
    {
        // The Code attribute contains bytecode - need to use ClassFormatReader
        var reader = new ClassFormatReader(attr.Data);
        if (!CodeAttribute.TryRead(ref reader, out var codeAttr))
            return;

        // First pass: collect all instructions with their IDs and offsets
        var decoder = new CodeDecoder(codeAttr.Code);
        var instructions = new List<(Instruction instr, int id, int index)>();
        var offsetToId = new Dictionary<int, int>();
        var offsetToIndex = new Dictionary<int, int>();
        int instrIndex = 0;

        while (decoder.TryReadNext(out var instr))
        {
            var instrId = trap.GetId();
            instructions.Add((instr, instrId, instrIndex));
            offsetToId[instr.Offset] = instrId;
            offsetToIndex[instr.Offset] = instrIndex;
            instrIndex++;
        }

        // Write basic instruction info
        foreach (var (instr, instrId, index) in instructions)
        {
            var opcode = (int)instr.OpCode;
            var offset = instr.Offset;

            trap.WriteTuple("jvm_instruction", instrId, offset, opcode);
            trap.WriteTuple("jvm_instruction_method", instrId, methodId);
            trap.WriteTuple("jvm_instruction_parent", instrId, index, methodId);

            // Extract instruction-specific operands
            ExtractInstructionOperands(instr, instrId, offset, classFile);
        }

        // Collect exception handler offsets for stack state computation
        var handlerOffsets = codeAttr.ExceptionTable.Select(h => (int)h.HandlerOffset).ToList();
        
        // Compute and write stack state using abstract interpretation
        ComputeStackState(instructions, offsetToId, offsetToIndex, handlerOffsets);

        // Extract exception handlers
        foreach (var handler in codeAttr.ExceptionTable)
        {
            var handlerId = trap.GetId();
            string catchType = "";
            
            if (!handler.CatchType.IsNil)
            {
                var catchClassConst = classFile.Constants.Get(handler.CatchType);
                catchType = catchClassConst.Name?.Replace('/', '.') ?? "";
            }

            trap.WriteTuple("jvm_exception_handler", handlerId, methodId, 
                handler.StartOffset, handler.EndOffset, handler.HandlerOffset, catchType);
        }
    }

    /// <summary>
    /// Computes stack state at each instruction using abstract interpretation.
    /// This is a forward dataflow analysis that tracks:
    /// 1. Stack height at each instruction
    /// 2. Which instruction produced each stack slot value
    /// </summary>
    private void ComputeStackState(
        List<(Instruction instr, int id, int index)> instructions,
        Dictionary<int, int> offsetToId,
        Dictionary<int, int> offsetToIndex,
        IEnumerable<int> exceptionHandlerOffsets)
    {
        if (instructions.Count == 0)
            return;

        int n = instructions.Count;
        
        // Stack state: for each instruction, track the stack as a list of producer IDs
        // stackState[i] = list of instruction IDs that produced each stack slot (index 0 = bottom)
        var stackState = new List<int>?[n];
        var visited = new bool[n];
        
        // Worklist for dataflow analysis
        var worklist = new Queue<int>();
        
        // Initialize: first instruction starts with empty stack
        stackState[0] = new List<int>();
        worklist.Enqueue(0);
        
        // Also initialize exception handler entries - they start with exception on stack
        foreach (var handlerOffset in exceptionHandlerOffsets)
        {
            if (offsetToIndex.TryGetValue(handlerOffset, out int handlerIndex))
            {
                // Exception handlers start with the exception object on the stack
                // Use a synthetic ID (-handlerIndex-1) to represent the exception
                stackState[handlerIndex] = new List<int> { -(handlerIndex + 1) };
                worklist.Enqueue(handlerIndex);
            }
        }

        // Forward dataflow analysis
        while (worklist.Count > 0)
        {
            int idx = worklist.Dequeue();
            if (visited[idx])
                continue;
            
            var currentStack = stackState[idx];
            if (currentStack == null)
                continue;
                
            visited[idx] = true;
            
            var (instr, instrId, _) = instructions[idx];
            
            // Write stack height for this instruction
            trap.WriteTuple("jvm_stack_height", instrId, currentStack.Count);
            
            // Write stack slot mappings (slot 0 = top of stack)
            for (int slot = 0; slot < currentStack.Count; slot++)
            {
                int producerId = currentStack[currentStack.Count - 1 - slot]; // Reverse: top is last in list
                // Only write positive producer IDs (skip synthetic exception IDs for now)
                if (producerId >= 0)
                {
                    trap.WriteTuple("jvm_stack_slot", instrId, slot, producerId);
                }
            }
            
            // Compute stack state after this instruction executes
            var newStack = ApplyStackEffect(instr, instrId, currentStack);
            
            // Propagate to successors
            var successors = GetSuccessors(instr, idx, instructions.Count, offsetToIndex);
            foreach (int succIdx in successors)
            {
                if (stackState[succIdx] == null)
                {
                    stackState[succIdx] = new List<int>(newStack);
                    worklist.Enqueue(succIdx);
                }
                else if (!visited[succIdx])
                {
                    // Merge stack states at control flow join points
                    // For simplicity, we assume stacks have same height (JVM verifier guarantees this)
                    worklist.Enqueue(succIdx);
                }
            }
        }
    }

    /// <summary>
    /// Applies the stack effect of an instruction, returning the new stack state.
    /// </summary>
    private List<int> ApplyStackEffect(Instruction instr, int instrId, List<int> stack)
    {
        var newStack = new List<int>(stack);
        
        // Get stack effect (pops, pushes) for each opcode
        int pops = GetStackPops(instr);
        int pushes = GetStackPushes(instr);
        
        // Pop operands
        for (int i = 0; i < pops && newStack.Count > 0; i++)
        {
            newStack.RemoveAt(newStack.Count - 1);
        }
        
        // Push results - the current instruction is the producer
        for (int i = 0; i < pushes; i++)
        {
            newStack.Add(instrId);
        }
        
        return newStack;
    }

    /// <summary>
    /// Gets the successor instruction indices for control flow.
    /// </summary>
    private List<int> GetSuccessors(Instruction instr, int currentIdx, int totalCount, Dictionary<int, int> offsetToIndex)
    {
        var successors = new List<int>();
        
        // Check if this is a terminal instruction
        if (IsTerminalInstruction(instr.OpCode))
        {
            // return, athrow, ret - no successors
            return successors;
        }
        
        // Check for branch targets
        int? branchTarget = GetBranchTarget(instr);
        if (branchTarget.HasValue && offsetToIndex.TryGetValue(branchTarget.Value, out int targetIdx))
        {
            successors.Add(targetIdx);
        }
        
        // Check for switch targets
        var switchTargets = GetSwitchTargets(instr);
        foreach (int target in switchTargets)
        {
            if (offsetToIndex.TryGetValue(target, out int switchTargetIdx))
            {
                successors.Add(switchTargetIdx);
            }
        }
        
        // Fall-through to next instruction (unless unconditional jump or terminal)
        if (!IsUnconditionalJump(instr.OpCode) && currentIdx + 1 < totalCount)
        {
            successors.Add(currentIdx + 1);
        }
        
        return successors;
    }

    private bool IsTerminalInstruction(OpCode opcode)
    {
        return opcode == OpCode.Return || opcode == OpCode.Ireturn || opcode == OpCode.Lreturn ||
               opcode == OpCode.Freturn || opcode == OpCode.Dreturn || opcode == OpCode.Areturn ||
               opcode == OpCode.Athrow || opcode == OpCode.Ret;
    }

    private bool IsUnconditionalJump(OpCode opcode)
    {
        return opcode == OpCode.Goto || opcode == OpCode.GotoW || 
               opcode == OpCode.Jsr || opcode == OpCode.JsrW;
    }

    private int? GetBranchTarget(Instruction instr)
    {
        int offset = instr.Offset;
        return instr.OpCode switch
        {
            OpCode.Ifeq => offset + instr.AsIfeq().Target,
            OpCode.Ifne => offset + instr.AsIfne().Target,
            OpCode.Iflt => offset + instr.AsIflt().Target,
            OpCode.Ifge => offset + instr.AsIfge().Target,
            OpCode.Ifgt => offset + instr.AsIfgt().Target,
            OpCode.Ifle => offset + instr.AsIfle().Target,
            OpCode.IfIcmpeq => offset + instr.AsIfIcmpeq().Target,
            OpCode.IfIcmpne => offset + instr.AsIfIcmpne().Target,
            OpCode.IfIcmplt => offset + instr.AsIfIcmplt().Target,
            OpCode.IfIcmpge => offset + instr.AsIfIcmpge().Target,
            OpCode.IfIcmpgt => offset + instr.AsIfIcmpgt().Target,
            OpCode.IfIcmple => offset + instr.AsIfIcmple().Target,
            OpCode.IfAcmpeq => offset + instr.AsIfAcmpeq().Target,
            OpCode.IfAcmpne => offset + instr.AsIfAcmpne().Target,
            OpCode.IfNull => offset + instr.AsIfNull().Target,
            OpCode.IfNonNull => offset + instr.AsIfNonNull().Target,
            OpCode.Goto => offset + instr.AsGoto().Target,
            OpCode.GotoW => offset + instr.AsGotoW().Target,
            OpCode.Jsr => offset + instr.AsJsr().Target,
            OpCode.JsrW => offset + instr.AsJsrW().Target,
            _ => null
        };
    }

    private List<int> GetSwitchTargets(Instruction instr)
    {
        var targets = new List<int>();
        int offset = instr.Offset;
        
        if (instr.OpCode == OpCode.TableSwitch)
        {
            var ts = instr.AsTableSwitch();
            targets.Add(offset + ts.DefaultTarget);
            foreach (var caseTarget in ts.Cases)
            {
                targets.Add(offset + caseTarget);
            }
        }
        else if (instr.OpCode == OpCode.LookupSwitch)
        {
            var ls = instr.AsLookupSwitch();
            targets.Add(offset + ls.DefaultTarget);
            foreach (var caseEntry in ls.Cases)
            {
                targets.Add(offset + caseEntry.Target);
            }
        }
        
        return targets;
    }

    /// <summary>
    /// Returns the number of stack slots popped by an instruction.
    /// </summary>
    private int GetStackPops(Instruction instr)
    {
        return instr.OpCode switch
        {
            // No pops
            OpCode.Nop or OpCode.AconstNull or 
            OpCode.IconstM1 or OpCode.Iconst0 or OpCode.Iconst1 or OpCode.Iconst2 or 
            OpCode.Iconst3 or OpCode.Iconst4 or OpCode.Iconst5 or
            OpCode.Lconst0 or OpCode.Lconst1 or
            OpCode.Fconst0 or OpCode.Fconst1 or OpCode.Fconst2 or
            OpCode.Dconst0 or OpCode.Dconst1 or
            OpCode.Bipush or OpCode.Sipush or OpCode.Ldc or OpCode.LdcW or OpCode.Ldc2W or
            OpCode.Iload or OpCode.Lload or OpCode.Fload or OpCode.Dload or OpCode.Aload or
            OpCode.Iload0 or OpCode.Iload1 or OpCode.Iload2 or OpCode.Iload3 or
            OpCode.Lload0 or OpCode.Lload1 or OpCode.Lload2 or OpCode.Lload3 or
            OpCode.Fload0 or OpCode.Fload1 or OpCode.Fload2 or OpCode.Fload3 or
            OpCode.Dload0 or OpCode.Dload1 or OpCode.Dload2 or OpCode.Dload3 or
            OpCode.Aload0 or OpCode.Aload1 or OpCode.Aload2 or OpCode.Aload3 or
            OpCode.New or OpCode.Goto or OpCode.GotoW or OpCode.Jsr or OpCode.JsrW or
            OpCode.GetStatic => 0,

            // Pop 1
            OpCode.Istore or OpCode.Fstore or OpCode.Astore or
            OpCode.Istore0 or OpCode.Istore1 or OpCode.Istore2 or OpCode.Istore3 or
            OpCode.Fstore0 or OpCode.Fstore1 or OpCode.Fstore2 or OpCode.Fstore3 or
            OpCode.Astore0 or OpCode.Astore1 or OpCode.Astore2 or OpCode.Astore3 or
            OpCode.Pop or OpCode.Dup or
            OpCode.Ifeq or OpCode.Ifne or OpCode.Iflt or OpCode.Ifge or OpCode.Ifgt or OpCode.Ifle or
            OpCode.IfNull or OpCode.IfNonNull or
            OpCode.TableSwitch or OpCode.LookupSwitch or
            OpCode.Ireturn or OpCode.Freturn or OpCode.Areturn or
            OpCode.Athrow or
            OpCode.Ineg or OpCode.Fneg or
            OpCode.I2l or OpCode.I2f or OpCode.I2d or OpCode.I2b or OpCode.I2c or OpCode.I2s or
            OpCode.F2i or OpCode.F2l or OpCode.F2d or
            OpCode.Newarray or OpCode.Anewarray or OpCode.Arraylength or
            OpCode.Checkcast or OpCode.InstanceOf or
            OpCode.GetField or OpCode.PutStatic => 1,

            // Pop 2 (or 1 long/double)
            OpCode.Lstore or OpCode.Dstore or
            OpCode.Lstore0 or OpCode.Lstore1 or OpCode.Lstore2 or OpCode.Lstore3 or
            OpCode.Dstore0 or OpCode.Dstore1 or OpCode.Dstore2 or OpCode.Dstore3 or
            OpCode.Pop2 or OpCode.Dup2 or OpCode.DupX1 or
            OpCode.Iadd or OpCode.Isub or OpCode.Imul or OpCode.Idiv or OpCode.Irem or
            OpCode.Fadd or OpCode.Fsub or OpCode.Fmul or OpCode.Fdiv or OpCode.Frem or
            OpCode.Ishl or OpCode.Ishr or OpCode.Iushr or OpCode.Iand or OpCode.Ior or OpCode.Ixor or
            OpCode.IfIcmpeq or OpCode.IfIcmpne or OpCode.IfIcmplt or OpCode.IfIcmpge or 
            OpCode.IfIcmpgt or OpCode.IfIcmple or
            OpCode.IfAcmpeq or OpCode.IfAcmpne or
            OpCode.Lreturn or OpCode.Dreturn or
            OpCode.Lneg or OpCode.Dneg or
            OpCode.L2i or OpCode.L2f or OpCode.L2d or
            OpCode.D2i or OpCode.D2l or OpCode.D2f or
            OpCode.Iaload or OpCode.Faload or OpCode.Aaload or OpCode.Baload or 
            OpCode.Caload or OpCode.Saload or
            OpCode.Fcmpl or OpCode.Fcmpg or
            OpCode.PutField or OpCode.Swap => 2,

            // Pop 3
            OpCode.Iastore or OpCode.Fastore or OpCode.Aastore or OpCode.Bastore or 
            OpCode.Castore or OpCode.Sastore or
            OpCode.DupX2 or OpCode.Dup2X1 => 3,

            // Pop 4 (or 2 long/double)
            OpCode.Ladd or OpCode.Lsub or OpCode.Lmul or OpCode.Ldiv or OpCode.Lrem or
            OpCode.Dadd or OpCode.Dsub or OpCode.Dmul or OpCode.Ddiv or OpCode.Drem or
            OpCode.Lshl or OpCode.Lshr or OpCode.Lushr or OpCode.Land or OpCode.Lor or OpCode.Lxor or
            OpCode.Laload or OpCode.Daload or
            OpCode.Lcmp or OpCode.Dcmpl or OpCode.Dcmpg or
            OpCode.Dup2X2 => 4,

            // Pop 5
            OpCode.Lastore or OpCode.Dastore => 5,
            
            // Variable pops - invoke instructions
            OpCode.InvokeVirtual or OpCode.InvokeSpecial or OpCode.InvokeStatic or 
            OpCode.InvokeInterface or OpCode.InvokeDynamic => GetInvokeStackPops(instr),
            
            // Multianewarray pops dimensions + nothing pushed extra
            OpCode.Multianewarray => instr.AsMultianewarray().Dimensions,
            
            // Return with no value
            OpCode.Return => 0,
            
            // iinc doesn't affect stack
            OpCode.Iinc => 0,
            
            // Wide prefix - depends on actual instruction
            OpCode.Wide => 0,
            
            // Ret pops nothing
            OpCode.Ret => 0,
            
            _ => 0
        };
    }

    /// <summary>
    /// Returns the number of stack slots pushed by an instruction.
    /// </summary>
    private int GetStackPushes(Instruction instr)
    {
        return instr.OpCode switch
        {
            // Push 0
            OpCode.Nop or
            OpCode.Istore or OpCode.Lstore or OpCode.Fstore or OpCode.Dstore or OpCode.Astore or
            OpCode.Istore0 or OpCode.Istore1 or OpCode.Istore2 or OpCode.Istore3 or
            OpCode.Lstore0 or OpCode.Lstore1 or OpCode.Lstore2 or OpCode.Lstore3 or
            OpCode.Fstore0 or OpCode.Fstore1 or OpCode.Fstore2 or OpCode.Fstore3 or
            OpCode.Dstore0 or OpCode.Dstore1 or OpCode.Dstore2 or OpCode.Dstore3 or
            OpCode.Astore0 or OpCode.Astore1 or OpCode.Astore2 or OpCode.Astore3 or
            OpCode.Iastore or OpCode.Lastore or OpCode.Fastore or OpCode.Dastore or 
            OpCode.Aastore or OpCode.Bastore or OpCode.Castore or OpCode.Sastore or
            OpCode.Pop or OpCode.Pop2 or
            OpCode.Ifeq or OpCode.Ifne or OpCode.Iflt or OpCode.Ifge or OpCode.Ifgt or OpCode.Ifle or
            OpCode.IfIcmpeq or OpCode.IfIcmpne or OpCode.IfIcmplt or OpCode.IfIcmpge or 
            OpCode.IfIcmpgt or OpCode.IfIcmple or
            OpCode.IfAcmpeq or OpCode.IfAcmpne or OpCode.IfNull or OpCode.IfNonNull or
            OpCode.Goto or OpCode.GotoW or
            OpCode.TableSwitch or OpCode.LookupSwitch or
            OpCode.Return or OpCode.Ireturn or OpCode.Lreturn or OpCode.Freturn or 
            OpCode.Dreturn or OpCode.Areturn or
            OpCode.Athrow or
            OpCode.PutStatic or OpCode.PutField or
            OpCode.Iinc or OpCode.Wide or OpCode.Ret => 0,

            // Push 1
            OpCode.AconstNull or
            OpCode.IconstM1 or OpCode.Iconst0 or OpCode.Iconst1 or OpCode.Iconst2 or 
            OpCode.Iconst3 or OpCode.Iconst4 or OpCode.Iconst5 or
            OpCode.Fconst0 or OpCode.Fconst1 or OpCode.Fconst2 or
            OpCode.Bipush or OpCode.Sipush or OpCode.Ldc or OpCode.LdcW or
            OpCode.Iload or OpCode.Fload or OpCode.Aload or
            OpCode.Iload0 or OpCode.Iload1 or OpCode.Iload2 or OpCode.Iload3 or
            OpCode.Fload0 or OpCode.Fload1 or OpCode.Fload2 or OpCode.Fload3 or
            OpCode.Aload0 or OpCode.Aload1 or OpCode.Aload2 or OpCode.Aload3 or
            OpCode.Iaload or OpCode.Faload or OpCode.Aaload or OpCode.Baload or 
            OpCode.Caload or OpCode.Saload or
            OpCode.Iadd or OpCode.Isub or OpCode.Imul or OpCode.Idiv or OpCode.Irem or
            OpCode.Fadd or OpCode.Fsub or OpCode.Fmul or OpCode.Fdiv or OpCode.Frem or
            OpCode.Ineg or OpCode.Fneg or
            OpCode.Ishl or OpCode.Ishr or OpCode.Iushr or OpCode.Iand or OpCode.Ior or OpCode.Ixor or
            OpCode.L2i or OpCode.D2i or OpCode.D2f or OpCode.F2i or
            OpCode.I2b or OpCode.I2c or OpCode.I2s or
            OpCode.Lcmp or OpCode.Fcmpl or OpCode.Fcmpg or OpCode.Dcmpl or OpCode.Dcmpg or
            OpCode.New or OpCode.Newarray or OpCode.Anewarray or OpCode.Multianewarray or
            OpCode.Arraylength or
            OpCode.Checkcast or OpCode.InstanceOf or
            OpCode.GetStatic or OpCode.GetField or
            OpCode.Jsr or OpCode.JsrW => 1,

            // Push 2 (dup pushes 1 extra, so net effect is +1 from original 1)
            OpCode.Lconst0 or OpCode.Lconst1 or
            OpCode.Dconst0 or OpCode.Dconst1 or
            OpCode.Ldc2W or
            OpCode.Lload or OpCode.Dload or
            OpCode.Lload0 or OpCode.Lload1 or OpCode.Lload2 or OpCode.Lload3 or
            OpCode.Dload0 or OpCode.Dload1 or OpCode.Dload2 or OpCode.Dload3 or
            OpCode.Laload or OpCode.Daload or
            OpCode.Ladd or OpCode.Lsub or OpCode.Lmul or OpCode.Ldiv or OpCode.Lrem or
            OpCode.Dadd or OpCode.Dsub or OpCode.Dmul or OpCode.Ddiv or OpCode.Drem or
            OpCode.Lneg or OpCode.Dneg or
            OpCode.Lshl or OpCode.Lshr or OpCode.Lushr or OpCode.Land or OpCode.Lor or OpCode.Lxor or
            OpCode.I2l or OpCode.I2d or OpCode.F2l or OpCode.F2d or OpCode.L2f or OpCode.L2d or
            OpCode.Dup or OpCode.Swap => 2,

            // Dup variants - complex, simplified here
            OpCode.DupX1 => 3,
            OpCode.DupX2 => 4,
            OpCode.Dup2 => 4,
            OpCode.Dup2X1 => 5,
            OpCode.Dup2X2 => 6,

            // Variable pushes - invoke instructions
            OpCode.InvokeVirtual or OpCode.InvokeSpecial or OpCode.InvokeStatic or 
            OpCode.InvokeInterface or OpCode.InvokeDynamic => GetInvokeStackPushes(instr),

            _ => 0
        };
    }

    private int GetInvokeStackPops(Instruction instr)
    {
        // For invoke, we need to count parameters
        // This is already extracted, but we need to compute it here too
        // For simplicity, we'll use a helper that parses the descriptor
        return instr.OpCode switch
        {
            OpCode.InvokeStatic => CountInvokeArgs(instr, isStatic: true),
            _ => CountInvokeArgs(instr, isStatic: false) // includes 'this' reference
        };
    }

    private int CountInvokeArgs(Instruction instr, bool isStatic)
    {
        // We don't have easy access to the descriptor here during stack computation
        // For now, return a conservative estimate
        // The actual argument count is written to jvm_number_of_arguments
        // This is a limitation - we'd need to refactor to pass classFile through
        return isStatic ? 0 : 1; // At minimum, non-static calls pop 'this'
    }

    private int GetInvokeStackPushes(Instruction instr)
    {
        // Non-void methods push 1 (or 2 for long/double, but we simplify)
        // We don't know the return type here without the descriptor
        // For simplicity, assume 1 push if it returns something
        return 1; // Conservative - most methods return something
    }

    private void ExtractInstructionOperands(Instruction instr, int instrId, int offset, ClassFile classFile)
    {
        switch (instr.OpCode)
        {
            // Local variable loads/stores with explicit index
            case OpCode.Iload:
            case OpCode.Lload:
            case OpCode.Fload:
            case OpCode.Dload:
            case OpCode.Aload:
                var loadLocal = instr.OpCode switch
                {
                    OpCode.Iload => (ushort)instr.AsIload().Local,
                    OpCode.Lload => (ushort)instr.AsLload().Local,
                    OpCode.Fload => (ushort)instr.AsFload().Local,
                    OpCode.Dload => (ushort)instr.AsDload().Local,
                    OpCode.Aload => (ushort)instr.AsAload().Local,
                    _ => (ushort)0
                };
                trap.WriteTuple("jvm_operand_local_index", instrId, (int)loadLocal);
                break;

            case OpCode.Istore:
            case OpCode.Lstore:
            case OpCode.Fstore:
            case OpCode.Dstore:
            case OpCode.Astore:
                var storeLocal = instr.OpCode switch
                {
                    OpCode.Istore => (ushort)instr.AsIstore().Local,
                    OpCode.Lstore => (ushort)instr.AsLstore().Local,
                    OpCode.Fstore => (ushort)instr.AsFstore().Local,
                    OpCode.Dstore => (ushort)instr.AsDstore().Local,
                    OpCode.Astore => (ushort)instr.AsAstore().Local,
                    _ => (ushort)0
                };
                trap.WriteTuple("jvm_operand_local_index", instrId, (int)storeLocal);
                break;

            // Implicit local variable index (0-3)
            case OpCode.Iload0:
            case OpCode.Lload0:
            case OpCode.Fload0:
            case OpCode.Dload0:
            case OpCode.Aload0:
            case OpCode.Istore0:
            case OpCode.Lstore0:
            case OpCode.Fstore0:
            case OpCode.Dstore0:
            case OpCode.Astore0:
                trap.WriteTuple("jvm_operand_local_index", instrId, 0);
                break;

            case OpCode.Iload1:
            case OpCode.Lload1:
            case OpCode.Fload1:
            case OpCode.Dload1:
            case OpCode.Aload1:
            case OpCode.Istore1:
            case OpCode.Lstore1:
            case OpCode.Fstore1:
            case OpCode.Dstore1:
            case OpCode.Astore1:
                trap.WriteTuple("jvm_operand_local_index", instrId, 1);
                break;

            case OpCode.Iload2:
            case OpCode.Lload2:
            case OpCode.Fload2:
            case OpCode.Dload2:
            case OpCode.Aload2:
            case OpCode.Istore2:
            case OpCode.Lstore2:
            case OpCode.Fstore2:
            case OpCode.Dstore2:
            case OpCode.Astore2:
                trap.WriteTuple("jvm_operand_local_index", instrId, 2);
                break;

            case OpCode.Iload3:
            case OpCode.Lload3:
            case OpCode.Fload3:
            case OpCode.Dload3:
            case OpCode.Aload3:
            case OpCode.Istore3:
            case OpCode.Lstore3:
            case OpCode.Fstore3:
            case OpCode.Dstore3:
            case OpCode.Astore3:
                trap.WriteTuple("jvm_operand_local_index", instrId, 3);
                break;

            // Push constants
            case OpCode.Bipush:
                var bipush = instr.AsBipush();
                trap.WriteTuple("jvm_operand_byte", instrId, (int)bipush.Value);
                break;

            case OpCode.Sipush:
                var sipush = instr.AsSipush();
                trap.WriteTuple("jvm_operand_short", instrId, (int)sipush.Value);
                break;

            // Constant pool loads
            case OpCode.Ldc:
                var ldc = instr.AsLdc();
                trap.WriteTuple("jvm_operand_cp_index", instrId, ldc.Constant.Slot);
                break;

            case OpCode.LdcW:
                var ldcW = instr.AsLdcW();
                trap.WriteTuple("jvm_operand_cp_index", instrId, ldcW.Constant.Slot);
                break;

            case OpCode.Ldc2W:
                var ldc2W = instr.AsLdc2W();
                trap.WriteTuple("jvm_operand_cp_index", instrId, ldc2W.Constant.Slot);
                break;

            // iinc
            case OpCode.Iinc:
                var iinc = instr.AsIinc();
                trap.WriteTuple("jvm_operand_iinc", instrId, (int)iinc.Local, (int)iinc.Value);
                break;

            // Branches
            case OpCode.Ifeq:
            case OpCode.Ifne:
            case OpCode.Iflt:
            case OpCode.Ifge:
            case OpCode.Ifgt:
            case OpCode.Ifle:
            case OpCode.IfIcmpeq:
            case OpCode.IfIcmpne:
            case OpCode.IfIcmplt:
            case OpCode.IfIcmpge:
            case OpCode.IfIcmpgt:
            case OpCode.IfIcmple:
            case OpCode.IfAcmpeq:
            case OpCode.IfAcmpne:
            case OpCode.IfNull:
            case OpCode.IfNonNull:
            case OpCode.Goto:
            case OpCode.Jsr:
                int branchTarget = instr.OpCode switch
                {
                    OpCode.Ifeq => offset + instr.AsIfeq().Target,
                    OpCode.Ifne => offset + instr.AsIfne().Target,
                    OpCode.Iflt => offset + instr.AsIflt().Target,
                    OpCode.Ifge => offset + instr.AsIfge().Target,
                    OpCode.Ifgt => offset + instr.AsIfgt().Target,
                    OpCode.Ifle => offset + instr.AsIfle().Target,
                    OpCode.IfIcmpeq => offset + instr.AsIfIcmpeq().Target,
                    OpCode.IfIcmpne => offset + instr.AsIfIcmpne().Target,
                    OpCode.IfIcmplt => offset + instr.AsIfIcmplt().Target,
                    OpCode.IfIcmpge => offset + instr.AsIfIcmpge().Target,
                    OpCode.IfIcmpgt => offset + instr.AsIfIcmpgt().Target,
                    OpCode.IfIcmple => offset + instr.AsIfIcmple().Target,
                    OpCode.IfAcmpeq => offset + instr.AsIfAcmpeq().Target,
                    OpCode.IfAcmpne => offset + instr.AsIfAcmpne().Target,
                    OpCode.IfNull => offset + instr.AsIfNull().Target,
                    OpCode.IfNonNull => offset + instr.AsIfNonNull().Target,
                    OpCode.Goto => offset + instr.AsGoto().Target,
                    OpCode.Jsr => offset + instr.AsJsr().Target,
                    _ => 0
                };
                trap.WriteTuple("jvm_branch_target", instrId, branchTarget);
                break;

            case OpCode.GotoW:
                trap.WriteTuple("jvm_branch_target", instrId, offset + instr.AsGotoW().Target);
                break;

            case OpCode.JsrW:
                trap.WriteTuple("jvm_branch_target", instrId, offset + instr.AsJsrW().Target);
                break;

            // ret
            case OpCode.Ret:
                var ret = instr.AsRet();
                trap.WriteTuple("jvm_operand_local_index", instrId, (int)ret.Local);
                break;

            // Field access
            case OpCode.GetStatic:
            case OpCode.PutStatic:
            case OpCode.GetField:
            case OpCode.PutField:
                ExtractFieldRef(instr, instrId, classFile);
                break;

            // Method invocations
            case OpCode.InvokeVirtual:
            case OpCode.InvokeSpecial:
            case OpCode.InvokeStatic:
            case OpCode.InvokeInterface:
                ExtractMethodRef(instr, instrId, classFile);
                break;

            case OpCode.InvokeDynamic:
                // invokedynamic uses bootstrap methods - more complex
                var invDyn = instr.AsInvokeDynamic();
                trap.WriteTuple("jvm_operand_cp_index", instrId, invDyn.Method.Slot);
                break;

            // Type operations
            case OpCode.New:
                ExtractTypeRef(instr.AsNew().Constant, instrId, classFile);
                break;

            case OpCode.Anewarray:
                ExtractTypeRef(instr.AsAnewarray().Constant, instrId, classFile);
                break;

            case OpCode.Checkcast:
                ExtractTypeRef(instr.AsCheckcast().Type, instrId, classFile);
                break;

            case OpCode.InstanceOf:
                ExtractTypeRef(instr.AsInstanceOf().Type, instrId, classFile);
                break;

            case OpCode.Multianewarray:
                var multinew = instr.AsMultianewarray();
                ExtractTypeRef(multinew.Type, instrId, classFile);
                trap.WriteTuple("jvm_operand_byte", instrId, (int)multinew.Dimensions);
                break;

            // newarray (primitive arrays)
            case OpCode.Newarray:
                var newarray = instr.AsNewarray();
                trap.WriteTuple("jvm_operand_byte", instrId, (int)newarray.Value);
                break;

            // Switch instructions
            case OpCode.TableSwitch:
                ExtractTableSwitch(instr.AsTableSwitch(), instrId, offset);
                break;

            case OpCode.LookupSwitch:
                ExtractLookupSwitch(instr.AsLookupSwitch(), instrId, offset);
                break;

            // No operands for most other instructions
            default:
                break;
        }
    }

    private void ExtractFieldRef(Instruction instr, int instrId, ClassFile classFile)
    {
        try
        {
            ConstantHandle handle = instr.OpCode switch
            {
                OpCode.GetStatic => instr.AsGetStatic().Field,
                OpCode.PutStatic => instr.AsPutStatic().Field,
                OpCode.GetField => instr.AsGetField().Field,
                OpCode.PutField => instr.AsPutField().Field,
                _ => default
            };

            if (handle.IsNil)
                return;

            // Convert to typed handle and get the resolved constant
            var fieldRef = classFile.Constants.Get(new FieldrefConstantHandle(handle.Slot));

            trap.WriteTuple("jvm_field_operand", instrId, 
                fieldRef.ClassName?.Replace('/', '.') ?? "",
                fieldRef.Name ?? "",
                fieldRef.Descriptor ?? "");
        }
        catch (Exception ex)
        {
            // Log but continue - malformed constant pool entries shouldn't stop extraction
            Console.Error.WriteLine($"    Warning: Failed to extract field reference: {ex.Message}");
        }
    }

    private void ExtractMethodRef(Instruction instr, int instrId, ClassFile classFile)
    {
        try
        {
            string className = "";
            string methodName = "";
            string descriptor = "";

            switch (instr.OpCode)
            {
                case OpCode.InvokeVirtual:
                    var virtHandle = instr.AsInvokeVirtual().Method;
                    var virtRef = classFile.Constants.Get(new MethodrefConstantHandle(virtHandle.Slot));
                    className = virtRef.ClassName?.Replace('/', '.') ?? "";
                    methodName = virtRef.Name ?? "";
                    descriptor = virtRef.Descriptor ?? "";
                    break;

                case OpCode.InvokeSpecial:
                    var specHandle = instr.AsInvokeSpecial().Method;
                    var specRef = classFile.Constants.Get(new MethodrefConstantHandle(specHandle.Slot));
                    className = specRef.ClassName?.Replace('/', '.') ?? "";
                    methodName = specRef.Name ?? "";
                    descriptor = specRef.Descriptor ?? "";
                    break;

                case OpCode.InvokeStatic:
                    var statHandle = instr.AsInvokeStatic().Method;
                    var statRef = classFile.Constants.Get(new MethodrefConstantHandle(statHandle.Slot));
                    className = statRef.ClassName?.Replace('/', '.') ?? "";
                    methodName = statRef.Name ?? "";
                    descriptor = statRef.Descriptor ?? "";
                    break;

                case OpCode.InvokeInterface:
                    var intfHandle = instr.AsInvokeInterface().Method;
                    var intfRef = classFile.Constants.Get(new InterfaceMethodrefConstantHandle(intfHandle.Slot));
                    className = intfRef.ClassName?.Replace('/', '.') ?? "";
                    methodName = intfRef.Name ?? "";
                    descriptor = intfRef.Descriptor ?? "";
                    break;
            }

            var fullTarget = $"{className}.{methodName}";
            trap.WriteTuple("jvm_call_target_unresolved", instrId, fullTarget);

            int paramCount = CountParameters(descriptor);
            trap.WriteTuple("jvm_number_of_arguments", instrId, paramCount);

            if (!IsVoidReturn(descriptor))
            {
                trap.WriteTuple("jvm_call_has_return_value", instrId);
            }
        }
        catch (Exception ex)
        {
            // Log but continue - malformed constant pool entries shouldn't stop extraction
            Console.Error.WriteLine($"    Warning: Failed to extract method reference: {ex.Message}");
        }
    }

    private void ExtractTypeRef(ConstantHandle constHandle, int instrId, ClassFile classFile)
    {
        try
        {
            if (constHandle.IsNil)
                return;
                
            var classConst = classFile.Constants.Get(new ClassConstantHandle(constHandle.Slot));
            trap.WriteTuple("jvm_type_operand", instrId, classConst.Name?.Replace('/', '.') ?? "");
        }
        catch (Exception ex)
        {
            // Log but continue - malformed constant pool entries shouldn't stop extraction
            Console.Error.WriteLine($"    Warning: Failed to extract type reference: {ex.Message}");
        }
    }

    private void ExtractTableSwitch(TableSwitchInstruction ts, int instrId, int baseOffset)
    {
        trap.WriteTuple("jvm_switch_default", instrId, baseOffset + ts.DefaultTarget);

        int low = ts.Low;
        int caseIdx = 0;

        foreach (var caseEntry in ts.Cases)
        {
            int matchValue = low + caseIdx;
            trap.WriteTuple("jvm_switch_case", instrId, caseIdx, matchValue, baseOffset + caseEntry);
            caseIdx++;
        }
    }

    private void ExtractLookupSwitch(LookupSwitchInstruction ls, int instrId, int baseOffset)
    {
        trap.WriteTuple("jvm_switch_default", instrId, baseOffset + ls.DefaultTarget);

        int caseIdx = 0;
        foreach (var caseEntry in ls.Cases)
        {
            trap.WriteTuple("jvm_switch_case", instrId, caseIdx, caseEntry.Key, baseOffset + caseEntry.Target);
            caseIdx++;
        }
    }

    private static string GetPackageName(string className)
    {
        var lastSlash = className.LastIndexOf('/');
        return lastSlash >= 0 ? className.Substring(0, lastSlash).Replace('/', '.') : "";
    }

    private static string GetSimpleName(string className)
    {
        var lastSlash = className.LastIndexOf('/');
        return lastSlash >= 0 ? className.Substring(lastSlash + 1) : className;
    }

    private static string BuildMethodSignature(string name, string descriptor)
    {
        return $"{name}{descriptor}";
    }

    private static int CountParameters(string descriptor)
    {
        if (!descriptor.StartsWith("("))
            return 0;

        int closeParenIdx = descriptor.IndexOf(')');
        if (closeParenIdx < 0)
            return 0;

        var paramPart = descriptor.Substring(1, closeParenIdx - 1);

        int count = 0;
        int i = 0;
        while (i < paramPart.Length)
        {
            char c = paramPart[i];
            switch (c)
            {
                case 'B':
                case 'C':
                case 'D':
                case 'F':
                case 'I':
                case 'J':
                case 'S':
                case 'Z':
                    count++;
                    i++;
                    break;
                case 'L':
                    count++;
                    int semiIdx = paramPart.IndexOf(';', i);
                    i = semiIdx >= 0 ? semiIdx + 1 : paramPart.Length;
                    break;
                case '[':
                    // Skip array dimensions
                    while (i < paramPart.Length && paramPart[i] == '[')
                        i++;
                    // The base type
                    if (i < paramPart.Length)
                    {
                        if (paramPart[i] == 'L')
                        {
                            int arrSemiIdx = paramPart.IndexOf(';', i);
                            i = arrSemiIdx >= 0 ? arrSemiIdx + 1 : paramPart.Length;
                        }
                        else
                        {
                            i++;
                        }
                    }
                    count++;
                    break;
                default:
                    i++;
                    break;
            }
        }

        return count;
    }

    private static bool IsVoidReturn(string descriptor)
    {
        return descriptor.EndsWith(")V");
    }
}
