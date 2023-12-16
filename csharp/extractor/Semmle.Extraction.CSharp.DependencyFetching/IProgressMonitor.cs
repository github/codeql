using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    public interface IProgressMonitor
    {
        void Log(Severity severity, string message);
    }
}
