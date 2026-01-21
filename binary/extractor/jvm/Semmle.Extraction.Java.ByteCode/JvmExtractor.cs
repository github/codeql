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

        // Use CodeDecoder to iterate through instructions
        var decoder = new CodeDecoder(codeAttr.Code);
        int instrIndex = 0;

        while (decoder.TryReadNext(out var instr))
        {
            var instrId = trap.GetId();
            var opcode = (int)instr.OpCode;
            var offset = instr.Offset;

            trap.WriteTuple("jvm_instruction", instrId, offset, opcode);
            trap.WriteTuple("jvm_instruction_method", instrId, methodId);
            trap.WriteTuple("jvm_instruction_parent", instrId, instrIndex, methodId);

            // Extract instruction-specific operands
            ExtractInstructionOperands(instr, instrId, offset, classFile);

            instrIndex++;
        }

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
