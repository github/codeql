using Semmle.Extraction.Java.ByteCode.Trap;

namespace Semmle.Extraction.Java.ByteCode;

class Program
{
    private static readonly HashSet<string> AllowedExtensions =
        new(StringComparer.OrdinalIgnoreCase) { ".class", ".jar" };

    static int Main(string[] args)
    {
        if (args.Length == 0)
        {
            Console.WriteLine("Usage: Semmle.Extraction.Java.ByteCode <file-or-list-path> [additional-files...]");
            Console.WriteLine("  If the argument is a .class or .jar file, extract it directly.");
            Console.WriteLine("  Otherwise, treat it as a file containing paths to .class or .jar files.");
            return 1;
        }

        var trapDir = Environment.GetEnvironmentVariable("CODEQL_EXTRACTOR_JVM_TRAP_DIR");
        if (string.IsNullOrEmpty(trapDir))
        {
            Console.Error.WriteLine("Error: CODEQL_EXTRACTOR_JVM_TRAP_DIR environment variable not set");
            return 1;
        }

        var sourceArchiveDir = Environment.GetEnvironmentVariable("CODEQL_EXTRACTOR_JVM_SOURCE_ARCHIVE_DIR");
        if (string.IsNullOrEmpty(sourceArchiveDir))
        {
            Console.Error.WriteLine("Error: CODEQL_EXTRACTOR_JVM_SOURCE_ARCHIVE_DIR environment variable not set");
            return 1;
        }

        var files = new List<string>();
        
        foreach (var arg in args)
        {
            var extension = Path.GetExtension(arg);
            if (AllowedExtensions.Contains(extension))
            {
                // Direct .class or .jar file
                files.Add(arg);
            }
            else if (File.Exists(arg))
            {
                // File list
                files.AddRange(File.ReadAllLines(arg)
                    .Where(line => !string.IsNullOrWhiteSpace(line)));
            }
            else
            {
                Console.Error.WriteLine($"Warning: Argument not found or unsupported: {arg}");
            }
        }

        Console.WriteLine($"Processing {files.Count} file(s)...");

        int successCount = 0;
        int errorCount = 0;

        // Use a single TRAP file for all extractions to ensure globally unique IDs
        // This prevents ID collisions when CodeQL imports multiple TRAP files
        var outputPath = Path.Combine(trapDir, "jvm-extraction.trap");
        
        using (var trapWriter = new TrapWriter(outputPath))
        {
            var extractor = new JvmExtractor(trapWriter);
            
            foreach (var filePath in files)
            {
                if (!File.Exists(filePath))
                {
                    Console.WriteLine($"Warning: File does not exist: {filePath}");
                    errorCount++;
                    continue;
                }

                var extension = Path.GetExtension(filePath);
                if (!AllowedExtensions.Contains(extension))
                {
                    Console.WriteLine($"Skipping unsupported file type: {filePath}");
                    continue;
                }

                Console.WriteLine($"Extracting: {filePath}");

                try
                {
                    extractor.Extract(filePath);

                    // Copy to source archive
                    ArchiveFile(filePath, sourceArchiveDir);

                    successCount++;
                }
                catch (Exception ex)
                {
                    Console.Error.WriteLine($"Error extracting {filePath}: {ex.Message}");
                    Console.Error.WriteLine(ex.StackTrace);
                    errorCount++;
                }
            }
        }
        
        Console.WriteLine($"  -> {outputPath}");
        Console.WriteLine($"\nExtraction complete: {successCount} succeeded, {errorCount} failed");
        return errorCount > 0 ? 1 : 0;
    }

    private static void ArchiveFile(string sourcePath, string archiveDir)
    {
        // Convert absolute path to relative for archive: strip leading / or drive letter
        var relativePath = sourcePath.TrimStart('/').Replace(":", "_");
        var archivePath = Path.Combine(archiveDir, relativePath);
        var dir = Path.GetDirectoryName(archivePath);

        if (!string.IsNullOrEmpty(dir) && !Directory.Exists(dir))
        {
            Directory.CreateDirectory(dir);
        }

        File.Copy(sourcePath, archivePath, true);
    }
}
