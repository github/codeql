using System;
using System.IO;
using System.IO.Compression;

namespace ZipSlip
{
    class Program
    {

        public static void UnzipFileByFile(ZipArchive archive,
                                       string destDirectory)
        {
            foreach (var entry in archive.Entries)
            {
                string fullPath = Path.GetFullPath(entry.FullName);
                string fileName = Path.GetFileName(entry.FullName);
                string filename = entry.Name;
                string file = entry.FullName;
                if (!string.IsNullOrEmpty(file))
                {
                    // BAD
                    string destFileName = Path.Combine(destDirectory, file);
                    entry.ExtractToFile(destFileName, true);

                    // GOOD
                    string sanitizedFileName = Path.Combine(destDirectory, fileName);
                    entry.ExtractToFile(sanitizedFileName, true);

                    // BAD
                    string destFilePath = Path.Combine(destDirectory, fullPath);
                    entry.ExtractToFile(destFilePath, true);

                    // BAD: destFilePath isn't fully resolved, so may still contain ..
                    if (destFilePath.StartsWith(destDirectory))
                        entry.ExtractToFile(destFilePath, true);

                    // BAD
                    destFilePath = Path.GetFullPath(Path.Combine(destDirectory, fullPath));
                    entry.ExtractToFile(destFilePath, true);

                    // GOOD: a check for StartsWith against a fully resolved path
                    if (destFilePath.StartsWith(destDirectory))
                        entry.ExtractToFile(destFilePath, true);
                }
            }
        }

        private static int UnzipToStream(Stream zipStream, string installDir)
        {
            int returnCode = 0;
            try
            {
                // normalize InstallDir for use in check below
                var InstallDir = Path.GetFullPath(installDir + Path.DirectorySeparatorChar);

                using (ZipArchive archive = new ZipArchive(zipStream, ZipArchiveMode.Read))
                {
                    foreach (ZipArchiveEntry entry in archive.Entries)
                    {
                        // figure out where we are putting the file
                        String destFilePath = Path.Combine(InstallDir, entry.FullName);

                        Directory.CreateDirectory(Path.GetDirectoryName(destFilePath));

                        using (Stream archiveFileStream = entry.Open())
                        {
                            // BAD: writing to file stream
                            using (Stream tfsFileStream = new FileStream(destFilePath, FileMode.CreateNew, FileAccess.ReadWrite, FileShare.None))
                            {
                                Console.WriteLine(@"Writing ""{0}""", destFilePath);
                                archiveFileStream.CopyTo(tfsFileStream);
                            }

                            // BAD: can do it this way too
                            using (Stream tfsFileStream = File.Create(destFilePath))
                            {
                                Console.WriteLine(@"Writing ""{0}""", destFilePath);
                                archiveFileStream.CopyTo(tfsFileStream);
                            }

                            // BAD: creating stream using fileInfo
                            var fileInfo = new FileInfo(destFilePath);
                            using (FileStream fs = fileInfo.OpenWrite())
                            {
                                Console.WriteLine(@"Writing ""{0}""", destFilePath);
                                archiveFileStream.CopyTo(fs);
                            }

                            // BAD: creating stream using fileInfo
                            var fileInfo1 = new FileInfo(destFilePath);
                            using (FileStream fs = fileInfo1.Open(FileMode.Create))
                            {
                                Console.WriteLine(@"Writing ""{0}""", destFilePath);
                                archiveFileStream.CopyTo(fs);
                            }

                            // GOOD: Use substring to pick out single component
                            string fileName = destFilePath.Substring(destFilePath.LastIndexOf("\\"));
                            var fileInfo2 = new FileInfo(fileName);
                            using (FileStream fs = fileInfo2.Open(FileMode.Create))
                            {
                                Console.WriteLine(@"Writing ""{0}""", destFilePath);
                                archiveFileStream.CopyTo(fs);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error patching files: {0}", ex.ToString());
                returnCode = -1;
            }

            return returnCode;
        }

        static void Main(string[] args)
        {
            string zipFileName;
            zipFileName = args[0];

            string targetPath = args.Length == 2 ? args[1] : ".";

            using (FileStream file = new FileStream(zipFileName, FileMode.Open))
            {
                using (ZipArchive archive = new ZipArchive(file, ZipArchiveMode.Read))
                {
                    UnzipFileByFile(archive, targetPath);

                    // GOOD: the path is checked in this extension method
                    archive.ExtractToDirectory(targetPath);

                    UnzipToStream(file, targetPath);
                }
            }
        }
    }
}
