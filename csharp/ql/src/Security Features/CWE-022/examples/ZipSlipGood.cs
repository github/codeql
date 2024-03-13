using System.IO;
using System.IO.Compression;

class Good
{
    public static void WriteToDirectory(ZipArchiveEntry entry,
                                        string destDirectory)
    {
        string destFileName = Path.GetFullPath(Path.Combine(destDirectory, entry.FullName));
        string fullDestDirPath = Path.GetFullPath(destDirectory + Path.DirectorySeparatorChar);
        if (!destFileName.StartsWith(fullDestDirPath)) {
            throw new System.InvalidOperationException("Entry is outside the target dir: " +
                                                                                 destFileName);
        }
        entry.ExtractToFile(destFileName);
    }
}
