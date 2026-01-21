using Mono.Cecil;
using Mono.Cecil.Cil;
using Semmle.Extraction.CSharp.IL.Trap;

namespace Semmle.Extraction.CSharp.IL;

/// <summary>
/// Main extractor - reads DLL and writes TRAP files.
/// </summary>
public class ILExtractor {
  private readonly TrapWriter trap;
  private readonly Dictionary<string, int> methodIds = new();
  private readonly Dictionary<string, int> typeIds = new();

  public ILExtractor(TrapWriter trapWriter) {
    trap = trapWriter;
  }

  public void Extract(string dllPath) {
    Console.WriteLine($"Extracting {dllPath}...");

    // Read and process the assembly in a scoped block so it's disposed before file copy
    using (var assembly = AssemblyDefinition.ReadAssembly(dllPath)) {
      // Write file info
      var fileId = trap.GetId();
      trap.WriteTuple("files", fileId, dllPath);

      // Write assembly info
      var assemblyId = trap.GetId();
      trap.WriteTuple("assemblies", assemblyId, fileId, assembly.Name.Name,
                      assembly.Name.Version.ToString());

      foreach (var module in assembly.Modules) {
        foreach (var type in module.Types) {
          ExtractType(type);
        }
      }
    }

    // Copy to source archive (after assembly is closed)
    var cilSourceArchiveDir = Environment.GetEnvironmentVariable(
        "CODEQL_EXTRACTOR_CIL_SOURCE_ARCHIVE_DIR");
    if (string.IsNullOrEmpty(cilSourceArchiveDir)) {
      throw new InvalidOperationException(
          "Environment variable CODEQL_EXTRACTOR_CIL_SOURCE_ARCHIVE_DIR is not set.");
    }
    // Convert absolute path to relative for archive: strip leading / or drive letter
    var relativeDllPath = dllPath.TrimStart('/').Replace(":", "_");
    var dllArchivePath = Path.Combine(cilSourceArchiveDir, relativeDllPath);
    // Ensure directory exists
    var archiveDir = Path.GetDirectoryName(dllArchivePath);
    if (!Directory.Exists(archiveDir)) {
      Directory.CreateDirectory(archiveDir!);
    }
    File.Copy(dllPath, dllArchivePath, true);
    Console.WriteLine($"Extraction complete!");
  }

  private void ExtractType(TypeDefinition type) {
    var typeId = trap.GetId();
    typeIds[type.FullName] = typeId;

    // For nested types, we need to construct proper namespace and name
    // Cecil uses '/' for nested types (e.g., "Outer/Inner") but the call targets use '.'
    // So we normalize to dot notation for consistency
    var fullName = type.FullName.Replace('/', '.');
    var typeName = type.Name;
    string typeNamespace;
    
    if (type.IsNested && type.DeclaringType != null) {
      // For nested types, the namespace is the parent type's full name
      typeNamespace = type.DeclaringType.FullName.Replace('/', '.');
    } else {
      typeNamespace = type.Namespace;
    }

    // Write type info
    trap.WriteTuple("types", typeId, fullName, typeNamespace, typeName);

    foreach (var method in type.Methods) {
      // Skip some special methods
      if (method.IsConstructor && method.IsStatic)
        continue;

      ExtractMethod(method, typeId);
    }

    // Extract fields
    foreach (var field in type.Fields) {
      var fieldId = trap.GetId();
      ExtractField(field, typeId);
    }

    // Extract nested types (includes compiler-generated state machines)
    if (type.HasNestedTypes) {
      foreach (var nestedType in type.NestedTypes) {
        ExtractType(nestedType);
      }
    }
  }

  private void ExtractMethod(MethodDefinition method, int typeId) {
    var methodId = trap.GetId();
    var methodKey = $"{method.DeclaringType.FullName}.{method.Name}";
    methodIds[methodKey] = methodId;

    // Write method info
    var signature = GetMethodSignature(method);
    trap.WriteTuple("methods", methodId, method.Name, signature, typeId);

    // Write access flags
    trap.WriteTuple("cil_method_access_flags", methodId, (int)method.Attributes);

    if (method.HasBody) {
      ExtractMethodBody(method, methodId);
    }

    // If it's an instance method we generate a 'this' parameter and
    // place it at index 0.
    int paramStartIndex = 0;
    if (!method.IsStatic)
    {
      var thisId = trap.GetId();
      trap.WriteTuple("il_parameter", thisId, methodId, 0, "#this");
      // We set the index for the actual parameters to start at 1
      // so that we don't get overlapping indices.
      paramStartIndex = 1;
    }

    for(int i = 0; i < method.Parameters.Count; i++) {
      var param = method.Parameters[i];
      var paramId = trap.GetId();
      trap.WriteTuple("il_parameter", paramId, methodId, i + paramStartIndex, param.Name);
    }
  }

  private void ExtractField(FieldDefinition field, int typeId) {
    var fieldId = trap.GetId();
    trap.WriteTuple("fields", fieldId, field.Name, typeId);
  }

  private void ExtractMethodBody(MethodDefinition method, int methodId) {
    var body = method.Body;

    // Extract local variables
    if (body.HasVariables) {
      foreach (var variable in body.Variables) {
        var varId = trap.GetId();
        trap.WriteTuple("il_local_variable", varId, methodId, variable.Index, 
                        variable.VariableType.FullName);
      }
    }

    // Write each IL instruction
    var index = 0;
    foreach (var instruction in body.Instructions) {
      var instrId = trap.GetId();

      // Basic instruction info
      // This is super dumb: The instruction.OpCode returns a short instead of a ushort. So without the
      // cast the value for a clt instruction (which has Value 0xFE01) does not fit in a short (which
      // has max value 0x7FFF). So it underflows to a negative number.
      trap.WriteTuple("il_instruction", instrId, instruction.Offset,
                     (ushort)instruction.OpCode.Value);

      trap.WriteTuple("il_instruction_method", instrId,
                      methodId);

      trap.WriteTuple("instruction_string", instrId,
                      instruction.OpCode.Name);

      // Parent relationship
      trap.WriteTuple("il_instruction_parent", instrId, index, methodId);

      // Handle operand based on type
      if (instruction.Operand is Instruction targetInstr) {
        // Branch target
        trap.WriteTuple("il_branch_target", instrId, targetInstr.Offset);
      } else if (instruction.Operand is MethodReference methodRef) {
        // Method call - normalize nested type separators from '/' to '.'
        var declaringTypeName = methodRef.DeclaringType.FullName.Replace('/', '.');
        var targetMethodName = $"{declaringTypeName}.{methodRef.Name}";
        trap.WriteTuple("il_call_target_unresolved", instrId, targetMethodName);
        trap.WriteTuple("il_number_of_arguments", instrId, methodRef.Parameters.Count);
        if(methodRef.MethodReturnType.ReturnType.MetadataType is not Mono.Cecil.MetadataType.Void) {
          trap.WriteTuple("il_call_has_return_value", instrId);
        }
      } else if (instruction.Operand is VariableDefinition varDef) {
        // Local variable reference (ldloc, stloc, ldloca)
        trap.WriteTuple("il_operand_local_index", instrId, varDef.Index);
      } else if (instruction.Operand is FieldReference fieldRef) {
        var declaringTypeName = fieldRef.DeclaringType.FullName.Replace('/', '.');
        trap.WriteTuple("il_field_operand", instrId, declaringTypeName, fieldRef.Name);
      } else if (instruction.Operand is string str) {
        trap.WriteTuple("il_operand_string", instrId, str);
      } else if (instruction.Operand is sbyte sb) {
        trap.WriteTuple("il_operand_sbyte", instrId, sb);
      } else if (instruction.Operand is byte b) {
        trap.WriteTuple("il_operand_byte", instrId, b);
      } else if (instruction.Operand is int i) {
        trap.WriteTuple("il_operand_int", instrId, i);
      } else if (instruction.Operand is long l) {
        trap.WriteTuple("il_operand_long", instrId, l);
      } else if (instruction.Operand is float f) {
        trap.WriteTuple("il_operand_float", instrId, f);
      } else if (instruction.Operand is double d) {
        trap.WriteTuple("il_operand_double", instrId, d);
      }

      index++;
    }

    // Exception handlers
    if (body.HasExceptionHandlers) {
      foreach (var handler in body.ExceptionHandlers) {
        var handlerId = trap.GetId();
        trap.WriteTuple("il_exception_handler", handlerId, methodId,
                        handler.HandlerType.ToString(), handler.TryStart.Offset,
                        handler.TryEnd?.Offset ?? -1,
                        handler.HandlerStart?.Offset ?? -1,
                        handler.HandlerEnd?.Offset ?? -1);
      }
    }
  }

  private string GetMethodSignature(MethodDefinition method) {
    var parameters = string.Join(
        ", ",
        method.Parameters.Select(p => $"{p.ParameterType.Name} {p.Name}"));
    return $"{method.ReturnType.Name} {method.Name}({parameters})";
  }
}
