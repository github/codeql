namespace Semmle.Extraction.CSharp
{
    /// <summary>
    /// What action was performed when extracting a file.
    /// </summary>
    public enum AnalysisAction
    {
        Extracted,
        UpToDate,
        Excluded
    }
}