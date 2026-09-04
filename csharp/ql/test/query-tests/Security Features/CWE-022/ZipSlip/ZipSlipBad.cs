using System.IO;
using System.IO.Compression;

class Bad
{
    public static void WriteToDirectory(ZipArchiveEntry entry,
                                        string destDirectory)
    {
        string destFileName = Path.Combine(destDirectory, entry.FullName); // $ Alert=r9
        entry.ExtractToFile(destFileName); // $ Sink=r9
    }
}
