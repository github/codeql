using Semmle.Pipeline.Tests;

string folder1Path = args[0];
string folder2Path = args[1];
string[] folder1Files = Directory.GetFiles(folder1Path);
string[] folder2Files = Directory.GetFiles(folder2Path);

int numinvalid = 0;
Console.WriteLine();

foreach (string file1 in folder1Files)
{
    string fileName1 = Path.GetFileName(file1);

    foreach (string file2 in folder2Files)
    {
        string fileName2 = Path.GetFileName(file2);

        if (fileName1 == fileName2)
        {
            string file1Sanitized = TrapSanitizer.SanitizeTrap(File.ReadAllLines(file1));
            string file2Sanitized = TrapSanitizer.SanitizeTrap(File.ReadAllLines(file2));

            if (!file1Sanitized.Equals(file2Sanitized))
            {
                Console.WriteLine("FAILED");
                Console.WriteLine($"${file1}");
                Console.WriteLine($"{file1}");
                numinvalid++;
            }
            else
            {
                Console.WriteLine("SUCCESS");
                Console.WriteLine($"{file1}");
                Console.WriteLine($"{file1}");
            }
            break;
        }
    }
}
Console.WriteLine();

if (numinvalid > 0)
{
    throw new Exception("Trap files do not match expected output. See above logs for details.");
}