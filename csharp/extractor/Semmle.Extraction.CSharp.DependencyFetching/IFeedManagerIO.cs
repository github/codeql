
namespace Semmle.Extraction.CSharp.DependencyFetching
{
    public interface IFeedManagerIO
    {
        /// <summary>
        /// Gets the directory name of the specified path.
        /// </summary>
        string? GetDirectoryName(string path);

        /// <summary>
        /// Returns true if the feed is reachable within the specified timeout and try count.
        /// </summary>
        bool IsFeedReachable(string feed, int timeoutMilliSeconds, int tryCount);
    }
}
