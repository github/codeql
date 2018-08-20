public static void WriteToDirectory(IArchiveEntry entry,
                                    string destDirectory,
                                    ExtractionOptions options){
  string file = Path.GetFileName(entry.Key);
  string destFileName = Path.Combine(destDirectory, file);
  entry.WriteToFile(destFileName, options);
}