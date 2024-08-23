namespace Semmle.Extraction.PowerShell
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