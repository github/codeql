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

    var assembly = AssemblyDefinition.ReadAssembly(dllPath);

    // Write file info
    var fileId = trap.GetId();
    trap.WriteTuple("files", fileId, dllPath);

    // Write assembly info
    var assemblyId = trap.GetId();
    trap.WriteTuple("assemblies", assemblyId, fileId, assembly.Name.Name,
                    assembly.Name.Version.ToString());

    foreach (var module in assembly.Modules) {
      foreach (var type in module.Types) {
        // Skip compiler-generated types for now
        if (type.Name.Contains("<") || type.Name.StartsWith("<"))
          continue;

        ExtractType(type);
      }
    }

    var cilSourceArchiveDir = Environment.GetEnvironmentVariable(
        "CODEQL_EXTRACTOR_CIL_SOURCE_ARCHIVE_DIR");
    if (string.IsNullOrEmpty(cilSourceArchiveDir)) {
      throw new InvalidOperationException(
          "Environment variable CODEQL_EXTRACTOR_CIL_SOURCE_ARCHIVE_DIR is not set.");
    }
    var dllArchivePath =
        Path.Combine(cilSourceArchiveDir, dllPath.Replace(":", "_"));
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

    // Write type info
    trap.WriteTuple("types", typeId, type.FullName, type.Namespace, type.Name);

    foreach (var method in type.Methods) {
      // Skip some special methods
      if (method.IsConstructor && method.IsStatic)
        continue;

      ExtractMethod(method, typeId);
    }
  }

  private void ExtractMethod(MethodDefinition method, int typeId) {
    var methodId = trap.GetId();
    var methodKey = $"{method.DeclaringType.FullName}.{method.Name}";
    methodIds[methodKey] = methodId;

    // Write method info
    var signature = GetMethodSignature(method);
    trap.WriteTuple("methods", methodId, method.Name, signature, typeId);

    if (method.HasBody) {
      ExtractMethodBody(method, methodId);
    }
  }

  private void ExtractMethodBody(MethodDefinition method, int methodId) {
    var body = method.Body;

    // Write each IL instruction
    var index = 0;
    foreach (var instruction in body.Instructions) {
      var instrId = trap.GetId();

      // Basic instruction info
      trap.WriteTuple("il_instructions", instrId, (int)instruction.OpCode.Code,
                      instruction.OpCode.Name, instruction.Offset, methodId);

      // Parent relationship
      trap.WriteTuple("il_instruction_parent", instrId, index, methodId);

      // Handle operand based on type
      if (instruction.Operand is Instruction targetInstr) {
        // Branch target
        trap.WriteTuple("il_branch_target", instrId, targetInstr.Offset);
      } else if (instruction.Operand is MethodReference methodRef) {
        // Method call - we'll resolve this in a second pass
        var targetMethodName =
            $"{methodRef.DeclaringType.FullName}.{methodRef.Name}";
        trap.WriteTuple("il_call_target_unresolved", instrId, targetMethodName);
      } else if (instruction.Operand is string str) {
        trap.WriteTuple("il_operand_string", instrId, str);
      } else if (instruction.Operand is int i) {
        trap.WriteTuple("il_operand_int", instrId, i);
      } else if (instruction.Operand is long l) {
        trap.WriteTuple("il_operand_long", instrId, l);
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
