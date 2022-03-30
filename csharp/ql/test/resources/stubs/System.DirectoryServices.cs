
namespace System.DirectoryServices.Protocols
{
    public class SearchRequest
    {
        public SearchRequest() { }
        public SearchRequest(string distinguishedName, string ldapFilter, SearchScope searchScope, params string[] attributelist) { }
        public SearchRequest(string distinguishedName, System.Xml.XmlDocument filter, SearchScope searchScope, params string[] attributeList) { }
        public object Filter { get; set; }
    }

    public enum SearchScope { Base, OneLevel, Subtree }
}

namespace System.DirectoryServices
{
    public class DirectorySearcher
    {
        public DirectorySearcher() { }
        public DirectorySearcher(string filter) { }
        public string Filter { get; set; }
    }

    public class DirectoryEntry
    {
        public DirectoryEntry() { }
        public DirectoryEntry(string path) { }
        public string Path { get; set; }
    }
}
