public static void WriteToDirectory(IArchiveEntry entry,
                                    string destDirectory,
                                    ExtractionOptions options){
  string file = Path.GetFileName(entry.Key);
  string destFileName = Path.GetFullPath(Path.Combine(destDirecory, entry.Key));
  string fullDestDirPath = Path.GetFullPath(destDirectory + Path.DirectorySeparatorChar);
  if (!destFileName.StartsWith(fullDestDirPath)) {
    throw new ExtractionException("Entry is outside of the target dir: " + destFileName);
  }
  entry.WriteToFile(destFileName, options);
}