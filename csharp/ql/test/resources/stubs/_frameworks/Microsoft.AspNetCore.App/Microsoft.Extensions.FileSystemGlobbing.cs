// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.FileSystemGlobbing, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace FileSystemGlobbing
        {
            namespace Abstractions
            {
                public abstract class DirectoryInfoBase : Microsoft.Extensions.FileSystemGlobbing.Abstractions.FileSystemInfoBase
                {
                    protected DirectoryInfoBase() => throw null;
                    public abstract System.Collections.Generic.IEnumerable<Microsoft.Extensions.FileSystemGlobbing.Abstractions.FileSystemInfoBase> EnumerateFileSystemInfos();
                    public abstract Microsoft.Extensions.FileSystemGlobbing.Abstractions.DirectoryInfoBase GetDirectory(string path);
                    public abstract Microsoft.Extensions.FileSystemGlobbing.Abstractions.FileInfoBase GetFile(string path);
                }
                public class DirectoryInfoWrapper : Microsoft.Extensions.FileSystemGlobbing.Abstractions.DirectoryInfoBase
                {
                    public DirectoryInfoWrapper(System.IO.DirectoryInfo directoryInfo) => throw null;
                    public override System.Collections.Generic.IEnumerable<Microsoft.Extensions.FileSystemGlobbing.Abstractions.FileSystemInfoBase> EnumerateFileSystemInfos() => throw null;
                    public override string FullName { get => throw null; }
                    public override Microsoft.Extensions.FileSystemGlobbing.Abstractions.DirectoryInfoBase GetDirectory(string name) => throw null;
                    public override Microsoft.Extensions.FileSystemGlobbing.Abstractions.FileInfoBase GetFile(string name) => throw null;
                    public override string Name { get => throw null; }
                    public override Microsoft.Extensions.FileSystemGlobbing.Abstractions.DirectoryInfoBase ParentDirectory { get => throw null; }
                }
                public abstract class FileInfoBase : Microsoft.Extensions.FileSystemGlobbing.Abstractions.FileSystemInfoBase
                {
                    protected FileInfoBase() => throw null;
                }
                public class FileInfoWrapper : Microsoft.Extensions.FileSystemGlobbing.Abstractions.FileInfoBase
                {
                    public FileInfoWrapper(System.IO.FileInfo fileInfo) => throw null;
                    public override string FullName { get => throw null; }
                    public override string Name { get => throw null; }
                    public override Microsoft.Extensions.FileSystemGlobbing.Abstractions.DirectoryInfoBase ParentDirectory { get => throw null; }
                }
                public abstract class FileSystemInfoBase
                {
                    protected FileSystemInfoBase() => throw null;
                    public abstract string FullName { get; }
                    public abstract string Name { get; }
                    public abstract Microsoft.Extensions.FileSystemGlobbing.Abstractions.DirectoryInfoBase ParentDirectory { get; }
                }
            }
            public struct FilePatternMatch : System.IEquatable<Microsoft.Extensions.FileSystemGlobbing.FilePatternMatch>
            {
                public FilePatternMatch(string path, string stem) => throw null;
                public bool Equals(Microsoft.Extensions.FileSystemGlobbing.FilePatternMatch other) => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public string Path { get => throw null; }
                public string Stem { get => throw null; }
            }
            public class InMemoryDirectoryInfo : Microsoft.Extensions.FileSystemGlobbing.Abstractions.DirectoryInfoBase
            {
                public InMemoryDirectoryInfo(string rootDir, System.Collections.Generic.IEnumerable<string> files) => throw null;
                public override System.Collections.Generic.IEnumerable<Microsoft.Extensions.FileSystemGlobbing.Abstractions.FileSystemInfoBase> EnumerateFileSystemInfos() => throw null;
                public override string FullName { get => throw null; }
                public override Microsoft.Extensions.FileSystemGlobbing.Abstractions.DirectoryInfoBase GetDirectory(string path) => throw null;
                public override Microsoft.Extensions.FileSystemGlobbing.Abstractions.FileInfoBase GetFile(string path) => throw null;
                public override string Name { get => throw null; }
                public override Microsoft.Extensions.FileSystemGlobbing.Abstractions.DirectoryInfoBase ParentDirectory { get => throw null; }
            }
            namespace Internal
            {
                public interface ILinearPattern : Microsoft.Extensions.FileSystemGlobbing.Internal.IPattern
                {
                    System.Collections.Generic.IList<Microsoft.Extensions.FileSystemGlobbing.Internal.IPathSegment> Segments { get; }
                }
                public interface IPathSegment
                {
                    bool CanProduceStem { get; }
                    bool Match(string value);
                }
                public interface IPattern
                {
                    Microsoft.Extensions.FileSystemGlobbing.Internal.IPatternContext CreatePatternContextForExclude();
                    Microsoft.Extensions.FileSystemGlobbing.Internal.IPatternContext CreatePatternContextForInclude();
                }
                public interface IPatternContext
                {
                    void Declare(System.Action<Microsoft.Extensions.FileSystemGlobbing.Internal.IPathSegment, bool> onDeclare);
                    void PopDirectory();
                    void PushDirectory(Microsoft.Extensions.FileSystemGlobbing.Abstractions.DirectoryInfoBase directory);
                    bool Test(Microsoft.Extensions.FileSystemGlobbing.Abstractions.DirectoryInfoBase directory);
                    Microsoft.Extensions.FileSystemGlobbing.Internal.PatternTestResult Test(Microsoft.Extensions.FileSystemGlobbing.Abstractions.FileInfoBase file);
                }
                public interface IRaggedPattern : Microsoft.Extensions.FileSystemGlobbing.Internal.IPattern
                {
                    System.Collections.Generic.IList<System.Collections.Generic.IList<Microsoft.Extensions.FileSystemGlobbing.Internal.IPathSegment>> Contains { get; }
                    System.Collections.Generic.IList<Microsoft.Extensions.FileSystemGlobbing.Internal.IPathSegment> EndsWith { get; }
                    System.Collections.Generic.IList<Microsoft.Extensions.FileSystemGlobbing.Internal.IPathSegment> Segments { get; }
                    System.Collections.Generic.IList<Microsoft.Extensions.FileSystemGlobbing.Internal.IPathSegment> StartsWith { get; }
                }
                public class MatcherContext
                {
                    public MatcherContext(System.Collections.Generic.IEnumerable<Microsoft.Extensions.FileSystemGlobbing.Internal.IPattern> includePatterns, System.Collections.Generic.IEnumerable<Microsoft.Extensions.FileSystemGlobbing.Internal.IPattern> excludePatterns, Microsoft.Extensions.FileSystemGlobbing.Abstractions.DirectoryInfoBase directoryInfo, System.StringComparison comparison) => throw null;
                    public Microsoft.Extensions.FileSystemGlobbing.PatternMatchingResult Execute() => throw null;
                }
                namespace PathSegments
                {
                    public class CurrentPathSegment : Microsoft.Extensions.FileSystemGlobbing.Internal.IPathSegment
                    {
                        public bool CanProduceStem { get => throw null; }
                        public CurrentPathSegment() => throw null;
                        public bool Match(string value) => throw null;
                    }
                    public class LiteralPathSegment : Microsoft.Extensions.FileSystemGlobbing.Internal.IPathSegment
                    {
                        public bool CanProduceStem { get => throw null; }
                        public LiteralPathSegment(string value, System.StringComparison comparisonType) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public bool Match(string value) => throw null;
                        public string Value { get => throw null; }
                    }
                    public class ParentPathSegment : Microsoft.Extensions.FileSystemGlobbing.Internal.IPathSegment
                    {
                        public bool CanProduceStem { get => throw null; }
                        public ParentPathSegment() => throw null;
                        public bool Match(string value) => throw null;
                    }
                    public class RecursiveWildcardSegment : Microsoft.Extensions.FileSystemGlobbing.Internal.IPathSegment
                    {
                        public bool CanProduceStem { get => throw null; }
                        public RecursiveWildcardSegment() => throw null;
                        public bool Match(string value) => throw null;
                    }
                    public class WildcardPathSegment : Microsoft.Extensions.FileSystemGlobbing.Internal.IPathSegment
                    {
                        public string BeginsWith { get => throw null; }
                        public bool CanProduceStem { get => throw null; }
                        public System.Collections.Generic.List<string> Contains { get => throw null; }
                        public WildcardPathSegment(string beginsWith, System.Collections.Generic.List<string> contains, string endsWith, System.StringComparison comparisonType) => throw null;
                        public string EndsWith { get => throw null; }
                        public bool Match(string value) => throw null;
                        public static readonly Microsoft.Extensions.FileSystemGlobbing.Internal.PathSegments.WildcardPathSegment MatchAll;
                    }
                }
                namespace PatternContexts
                {
                    public abstract class PatternContext<TFrame> : Microsoft.Extensions.FileSystemGlobbing.Internal.IPatternContext where TFrame : struct
                    {
                        protected PatternContext() => throw null;
                        public virtual void Declare(System.Action<Microsoft.Extensions.FileSystemGlobbing.Internal.IPathSegment, bool> declare) => throw null;
                        protected TFrame Frame;
                        protected bool IsStackEmpty() => throw null;
                        public virtual void PopDirectory() => throw null;
                        protected void PushDataFrame(TFrame frame) => throw null;
                        public abstract void PushDirectory(Microsoft.Extensions.FileSystemGlobbing.Abstractions.DirectoryInfoBase directory);
                        public abstract bool Test(Microsoft.Extensions.FileSystemGlobbing.Abstractions.DirectoryInfoBase directory);
                        public abstract Microsoft.Extensions.FileSystemGlobbing.Internal.PatternTestResult Test(Microsoft.Extensions.FileSystemGlobbing.Abstractions.FileInfoBase file);
                    }
                    public abstract class PatternContextLinear : Microsoft.Extensions.FileSystemGlobbing.Internal.PatternContexts.PatternContext<Microsoft.Extensions.FileSystemGlobbing.Internal.PatternContexts.PatternContextLinear.FrameData>
                    {
                        protected string CalculateStem(Microsoft.Extensions.FileSystemGlobbing.Abstractions.FileInfoBase matchedFile) => throw null;
                        public PatternContextLinear(Microsoft.Extensions.FileSystemGlobbing.Internal.ILinearPattern pattern) => throw null;
                        public struct FrameData
                        {
                            public bool InStem;
                            public bool IsNotApplicable;
                            public int SegmentIndex;
                            public string Stem { get => throw null; }
                            public System.Collections.Generic.IList<string> StemItems { get => throw null; }
                        }
                        protected bool IsLastSegment() => throw null;
                        protected Microsoft.Extensions.FileSystemGlobbing.Internal.ILinearPattern Pattern { get => throw null; }
                        public override void PushDirectory(Microsoft.Extensions.FileSystemGlobbing.Abstractions.DirectoryInfoBase directory) => throw null;
                        public override Microsoft.Extensions.FileSystemGlobbing.Internal.PatternTestResult Test(Microsoft.Extensions.FileSystemGlobbing.Abstractions.FileInfoBase file) => throw null;
                        protected bool TestMatchingSegment(string value) => throw null;
                    }
                    public class PatternContextLinearExclude : Microsoft.Extensions.FileSystemGlobbing.Internal.PatternContexts.PatternContextLinear
                    {
                        public PatternContextLinearExclude(Microsoft.Extensions.FileSystemGlobbing.Internal.ILinearPattern pattern) : base(default(Microsoft.Extensions.FileSystemGlobbing.Internal.ILinearPattern)) => throw null;
                        public override bool Test(Microsoft.Extensions.FileSystemGlobbing.Abstractions.DirectoryInfoBase directory) => throw null;
                    }
                    public class PatternContextLinearInclude : Microsoft.Extensions.FileSystemGlobbing.Internal.PatternContexts.PatternContextLinear
                    {
                        public PatternContextLinearInclude(Microsoft.Extensions.FileSystemGlobbing.Internal.ILinearPattern pattern) : base(default(Microsoft.Extensions.FileSystemGlobbing.Internal.ILinearPattern)) => throw null;
                        public override void Declare(System.Action<Microsoft.Extensions.FileSystemGlobbing.Internal.IPathSegment, bool> onDeclare) => throw null;
                        public override bool Test(Microsoft.Extensions.FileSystemGlobbing.Abstractions.DirectoryInfoBase directory) => throw null;
                    }
                    public abstract class PatternContextRagged : Microsoft.Extensions.FileSystemGlobbing.Internal.PatternContexts.PatternContext<Microsoft.Extensions.FileSystemGlobbing.Internal.PatternContexts.PatternContextRagged.FrameData>
                    {
                        protected string CalculateStem(Microsoft.Extensions.FileSystemGlobbing.Abstractions.FileInfoBase matchedFile) => throw null;
                        public PatternContextRagged(Microsoft.Extensions.FileSystemGlobbing.Internal.IRaggedPattern pattern) => throw null;
                        public struct FrameData
                        {
                            public int BacktrackAvailable;
                            public bool InStem;
                            public bool IsNotApplicable;
                            public System.Collections.Generic.IList<Microsoft.Extensions.FileSystemGlobbing.Internal.IPathSegment> SegmentGroup;
                            public int SegmentGroupIndex;
                            public int SegmentIndex;
                            public string Stem { get => throw null; }
                            public System.Collections.Generic.IList<string> StemItems { get => throw null; }
                        }
                        protected bool IsEndingGroup() => throw null;
                        protected bool IsStartingGroup() => throw null;
                        protected Microsoft.Extensions.FileSystemGlobbing.Internal.IRaggedPattern Pattern { get => throw null; }
                        public override void PopDirectory() => throw null;
                        public override sealed void PushDirectory(Microsoft.Extensions.FileSystemGlobbing.Abstractions.DirectoryInfoBase directory) => throw null;
                        public override Microsoft.Extensions.FileSystemGlobbing.Internal.PatternTestResult Test(Microsoft.Extensions.FileSystemGlobbing.Abstractions.FileInfoBase file) => throw null;
                        protected bool TestMatchingGroup(Microsoft.Extensions.FileSystemGlobbing.Abstractions.FileSystemInfoBase value) => throw null;
                        protected bool TestMatchingSegment(string value) => throw null;
                    }
                    public class PatternContextRaggedExclude : Microsoft.Extensions.FileSystemGlobbing.Internal.PatternContexts.PatternContextRagged
                    {
                        public PatternContextRaggedExclude(Microsoft.Extensions.FileSystemGlobbing.Internal.IRaggedPattern pattern) : base(default(Microsoft.Extensions.FileSystemGlobbing.Internal.IRaggedPattern)) => throw null;
                        public override bool Test(Microsoft.Extensions.FileSystemGlobbing.Abstractions.DirectoryInfoBase directory) => throw null;
                    }
                    public class PatternContextRaggedInclude : Microsoft.Extensions.FileSystemGlobbing.Internal.PatternContexts.PatternContextRagged
                    {
                        public PatternContextRaggedInclude(Microsoft.Extensions.FileSystemGlobbing.Internal.IRaggedPattern pattern) : base(default(Microsoft.Extensions.FileSystemGlobbing.Internal.IRaggedPattern)) => throw null;
                        public override void Declare(System.Action<Microsoft.Extensions.FileSystemGlobbing.Internal.IPathSegment, bool> onDeclare) => throw null;
                        public override bool Test(Microsoft.Extensions.FileSystemGlobbing.Abstractions.DirectoryInfoBase directory) => throw null;
                    }
                }
                namespace Patterns
                {
                    public class PatternBuilder
                    {
                        public Microsoft.Extensions.FileSystemGlobbing.Internal.IPattern Build(string pattern) => throw null;
                        public System.StringComparison ComparisonType { get => throw null; }
                        public PatternBuilder() => throw null;
                        public PatternBuilder(System.StringComparison comparisonType) => throw null;
                    }
                }
                public struct PatternTestResult
                {
                    public static readonly Microsoft.Extensions.FileSystemGlobbing.Internal.PatternTestResult Failed;
                    public bool IsSuccessful { get => throw null; }
                    public string Stem { get => throw null; }
                    public static Microsoft.Extensions.FileSystemGlobbing.Internal.PatternTestResult Success(string stem) => throw null;
                }
            }
            public class Matcher
            {
                public virtual Microsoft.Extensions.FileSystemGlobbing.Matcher AddExclude(string pattern) => throw null;
                public virtual Microsoft.Extensions.FileSystemGlobbing.Matcher AddInclude(string pattern) => throw null;
                public Matcher() => throw null;
                public Matcher(System.StringComparison comparisonType) => throw null;
                public virtual Microsoft.Extensions.FileSystemGlobbing.PatternMatchingResult Execute(Microsoft.Extensions.FileSystemGlobbing.Abstractions.DirectoryInfoBase directoryInfo) => throw null;
            }
            public static partial class MatcherExtensions
            {
                public static void AddExcludePatterns(this Microsoft.Extensions.FileSystemGlobbing.Matcher matcher, params System.Collections.Generic.IEnumerable<string>[] excludePatternsGroups) => throw null;
                public static void AddIncludePatterns(this Microsoft.Extensions.FileSystemGlobbing.Matcher matcher, params System.Collections.Generic.IEnumerable<string>[] includePatternsGroups) => throw null;
                public static System.Collections.Generic.IEnumerable<string> GetResultsInFullPath(this Microsoft.Extensions.FileSystemGlobbing.Matcher matcher, string directoryPath) => throw null;
                public static Microsoft.Extensions.FileSystemGlobbing.PatternMatchingResult Match(this Microsoft.Extensions.FileSystemGlobbing.Matcher matcher, System.Collections.Generic.IEnumerable<string> files) => throw null;
                public static Microsoft.Extensions.FileSystemGlobbing.PatternMatchingResult Match(this Microsoft.Extensions.FileSystemGlobbing.Matcher matcher, string file) => throw null;
                public static Microsoft.Extensions.FileSystemGlobbing.PatternMatchingResult Match(this Microsoft.Extensions.FileSystemGlobbing.Matcher matcher, string rootDir, System.Collections.Generic.IEnumerable<string> files) => throw null;
                public static Microsoft.Extensions.FileSystemGlobbing.PatternMatchingResult Match(this Microsoft.Extensions.FileSystemGlobbing.Matcher matcher, string rootDir, string file) => throw null;
            }
            public class PatternMatchingResult
            {
                public PatternMatchingResult(System.Collections.Generic.IEnumerable<Microsoft.Extensions.FileSystemGlobbing.FilePatternMatch> files) => throw null;
                public PatternMatchingResult(System.Collections.Generic.IEnumerable<Microsoft.Extensions.FileSystemGlobbing.FilePatternMatch> files, bool hasMatches) => throw null;
                public System.Collections.Generic.IEnumerable<Microsoft.Extensions.FileSystemGlobbing.FilePatternMatch> Files { get => throw null; set { } }
                public bool HasMatches { get => throw null; }
            }
        }
    }
}
