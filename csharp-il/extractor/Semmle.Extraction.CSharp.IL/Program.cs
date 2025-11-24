using Semmle.Extraction.CSharp.IL.Trap;

namespace Semmle.Extraction.CSharp.IL;

class Program {
  static void Main(string[] args) {
    if (args.Length == 0) {
      Console.WriteLine(
          "Usage: Semmle.Extraction.CSharp.IL <path-to-dll> [output.trap]");
      return;
    }

    var dllPath = args[0];

    if (!File.Exists(dllPath)) {
      Console.WriteLine($"Error: File not found: {dllPath}");
      return;
    }

    var outputPath =
        args.Length > 1 ? args[1] : Path.ChangeExtension(dllPath, ".trap");

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
