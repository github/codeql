using Semmle.Extraction.CSharp.IL.Trap;

namespace Semmle.Extraction.CSharp.IL;

class Program {
  private static readonly HashSet<string> allowedExtensions =
      new(StringComparer.OrdinalIgnoreCase) { ".dll", ".exe" };
  private static bool isAllowedExtension(string extension) =>
      allowedExtensions.Contains(extension);
  static void Main(string[] args) {
    // Write all args to FOO.txt
    if (args.Length == 0) {
      Console.WriteLine(
          "Usage: Semmle.Extraction.CSharp.IL <path-to-file-list>");
      return;
    }

    var trapDir =
        Environment.GetEnvironmentVariable("CODEQL_EXTRACTOR_CIL_TRAP_DIR") ??
        throw new InvalidOperationException(
            "Environment variable CODEQL_EXTRACTOR_CIL_TRAP_DIR is not set.");

    var listPath = args[0];
    if (!File.Exists(listPath)) {
      throw new FileNotFoundException(
          $"The specified list file does not exist: {listPath}");
    }
    var files = File.ReadAllLines(listPath);

    foreach (var dllPath in files) {
      if (!File.Exists(dllPath)) {
        Console.WriteLine($"Warning: File does not exist: {dllPath}");
        continue;
      }
      var extension = Path.GetExtension(dllPath);
      if (!isAllowedExtension(extension)) {
        continue;
      }
      var outputPath = Path.Combine(
          trapDir, Path.GetFileNameWithoutExtension(dllPath) + ".trap");

      Console.WriteLine($"Extracting: {dllPath}");
      Console.WriteLine($"Output: {outputPath}");
      Console.WriteLine(new string('=', 80));
      Console.WriteLine();

      try {
        using var trapWriter = new TrapWriter(outputPath);
        var extractor = new ILExtractor(trapWriter);

        extractor.Extract(dllPath);

        Console.WriteLine();
        Console.WriteLine(new string('=', 80));
        Console.WriteLine($"TRAP file written to: {outputPath}");
      } catch (Exception ex) {
        Console.WriteLine($"Error: {ex.Message}");
        Console.WriteLine(ex.StackTrace);
      }
    }
  }
}
