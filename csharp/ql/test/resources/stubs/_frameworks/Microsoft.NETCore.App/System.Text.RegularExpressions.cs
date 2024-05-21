// This file contains auto-generated code.
// Generated from `System.Text.RegularExpressions, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Text
    {
        namespace RegularExpressions
        {
            public class Capture
            {
                public int Index { get => throw null; }
                public int Length { get => throw null; }
                public override string ToString() => throw null;
                public string Value { get => throw null; }
                public System.ReadOnlySpan<char> ValueSpan { get => throw null; }
            }
            public class CaptureCollection : System.Collections.Generic.ICollection<System.Text.RegularExpressions.Capture>, System.Collections.ICollection, System.Collections.Generic.IEnumerable<System.Text.RegularExpressions.Capture>, System.Collections.IEnumerable, System.Collections.Generic.IList<System.Text.RegularExpressions.Capture>, System.Collections.IList, System.Collections.Generic.IReadOnlyCollection<System.Text.RegularExpressions.Capture>, System.Collections.Generic.IReadOnlyList<System.Text.RegularExpressions.Capture>
            {
                void System.Collections.Generic.ICollection<System.Text.RegularExpressions.Capture>.Add(System.Text.RegularExpressions.Capture item) => throw null;
                int System.Collections.IList.Add(object value) => throw null;
                void System.Collections.Generic.ICollection<System.Text.RegularExpressions.Capture>.Clear() => throw null;
                void System.Collections.IList.Clear() => throw null;
                bool System.Collections.Generic.ICollection<System.Text.RegularExpressions.Capture>.Contains(System.Text.RegularExpressions.Capture item) => throw null;
                bool System.Collections.IList.Contains(object value) => throw null;
                public void CopyTo(System.Array array, int arrayIndex) => throw null;
                public void CopyTo(System.Text.RegularExpressions.Capture[] array, int arrayIndex) => throw null;
                public int Count { get => throw null; }
                public System.Collections.IEnumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Text.RegularExpressions.Capture> System.Collections.Generic.IEnumerable<System.Text.RegularExpressions.Capture>.GetEnumerator() => throw null;
                int System.Collections.Generic.IList<System.Text.RegularExpressions.Capture>.IndexOf(System.Text.RegularExpressions.Capture item) => throw null;
                int System.Collections.IList.IndexOf(object value) => throw null;
                void System.Collections.Generic.IList<System.Text.RegularExpressions.Capture>.Insert(int index, System.Text.RegularExpressions.Capture item) => throw null;
                void System.Collections.IList.Insert(int index, object value) => throw null;
                bool System.Collections.IList.IsFixedSize { get => throw null; }
                public bool IsReadOnly { get => throw null; }
                public bool IsSynchronized { get => throw null; }
                System.Text.RegularExpressions.Capture System.Collections.Generic.IList<System.Text.RegularExpressions.Capture>.this[int index] { get => throw null; set { } }
                object System.Collections.IList.this[int index] { get => throw null; set { } }
                bool System.Collections.Generic.ICollection<System.Text.RegularExpressions.Capture>.Remove(System.Text.RegularExpressions.Capture item) => throw null;
                void System.Collections.IList.Remove(object value) => throw null;
                void System.Collections.Generic.IList<System.Text.RegularExpressions.Capture>.RemoveAt(int index) => throw null;
                void System.Collections.IList.RemoveAt(int index) => throw null;
                public object SyncRoot { get => throw null; }
                public System.Text.RegularExpressions.Capture this[int i] { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)64, AllowMultiple = false, Inherited = false)]
            public sealed class GeneratedRegexAttribute : System.Attribute
            {
                public GeneratedRegexAttribute(string pattern) => throw null;
                public GeneratedRegexAttribute(string pattern, System.Text.RegularExpressions.RegexOptions options) => throw null;
                public GeneratedRegexAttribute(string pattern, System.Text.RegularExpressions.RegexOptions options, string cultureName) => throw null;
                public GeneratedRegexAttribute(string pattern, System.Text.RegularExpressions.RegexOptions options, int matchTimeoutMilliseconds) => throw null;
                public GeneratedRegexAttribute(string pattern, System.Text.RegularExpressions.RegexOptions options, int matchTimeoutMilliseconds, string cultureName) => throw null;
                public string CultureName { get => throw null; }
                public int MatchTimeoutMilliseconds { get => throw null; }
                public System.Text.RegularExpressions.RegexOptions Options { get => throw null; }
                public string Pattern { get => throw null; }
            }
            public class Group : System.Text.RegularExpressions.Capture
            {
                public System.Text.RegularExpressions.CaptureCollection Captures { get => throw null; }
                public string Name { get => throw null; }
                public bool Success { get => throw null; }
                public static System.Text.RegularExpressions.Group Synchronized(System.Text.RegularExpressions.Group inner) => throw null;
            }
            public class GroupCollection : System.Collections.Generic.ICollection<System.Text.RegularExpressions.Group>, System.Collections.ICollection, System.Collections.Generic.IEnumerable<System.Text.RegularExpressions.Group>, System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, System.Text.RegularExpressions.Group>>, System.Collections.Generic.IList<System.Text.RegularExpressions.Group>, System.Collections.IList, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<string, System.Text.RegularExpressions.Group>>, System.Collections.Generic.IReadOnlyCollection<System.Text.RegularExpressions.Group>, System.Collections.Generic.IReadOnlyDictionary<string, System.Text.RegularExpressions.Group>, System.Collections.Generic.IReadOnlyList<System.Text.RegularExpressions.Group>
            {
                void System.Collections.Generic.ICollection<System.Text.RegularExpressions.Group>.Add(System.Text.RegularExpressions.Group item) => throw null;
                int System.Collections.IList.Add(object value) => throw null;
                void System.Collections.Generic.ICollection<System.Text.RegularExpressions.Group>.Clear() => throw null;
                void System.Collections.IList.Clear() => throw null;
                bool System.Collections.Generic.ICollection<System.Text.RegularExpressions.Group>.Contains(System.Text.RegularExpressions.Group item) => throw null;
                bool System.Collections.IList.Contains(object value) => throw null;
                public bool ContainsKey(string key) => throw null;
                public void CopyTo(System.Array array, int arrayIndex) => throw null;
                public void CopyTo(System.Text.RegularExpressions.Group[] array, int arrayIndex) => throw null;
                public int Count { get => throw null; }
                public System.Collections.IEnumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, System.Text.RegularExpressions.Group>> System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, System.Text.RegularExpressions.Group>>.GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Text.RegularExpressions.Group> System.Collections.Generic.IEnumerable<System.Text.RegularExpressions.Group>.GetEnumerator() => throw null;
                int System.Collections.Generic.IList<System.Text.RegularExpressions.Group>.IndexOf(System.Text.RegularExpressions.Group item) => throw null;
                int System.Collections.IList.IndexOf(object value) => throw null;
                void System.Collections.Generic.IList<System.Text.RegularExpressions.Group>.Insert(int index, System.Text.RegularExpressions.Group item) => throw null;
                void System.Collections.IList.Insert(int index, object value) => throw null;
                bool System.Collections.IList.IsFixedSize { get => throw null; }
                public bool IsReadOnly { get => throw null; }
                public bool IsSynchronized { get => throw null; }
                System.Text.RegularExpressions.Group System.Collections.Generic.IList<System.Text.RegularExpressions.Group>.this[int index] { get => throw null; set { } }
                object System.Collections.IList.this[int index] { get => throw null; set { } }
                public System.Collections.Generic.IEnumerable<string> Keys { get => throw null; }
                bool System.Collections.Generic.ICollection<System.Text.RegularExpressions.Group>.Remove(System.Text.RegularExpressions.Group item) => throw null;
                void System.Collections.IList.Remove(object value) => throw null;
                void System.Collections.Generic.IList<System.Text.RegularExpressions.Group>.RemoveAt(int index) => throw null;
                void System.Collections.IList.RemoveAt(int index) => throw null;
                public object SyncRoot { get => throw null; }
                public System.Text.RegularExpressions.Group this[int groupnum] { get => throw null; }
                public System.Text.RegularExpressions.Group this[string groupname] { get => throw null; }
                public bool TryGetValue(string key, out System.Text.RegularExpressions.Group value) => throw null;
                public System.Collections.Generic.IEnumerable<System.Text.RegularExpressions.Group> Values { get => throw null; }
            }
            public class Match : System.Text.RegularExpressions.Group
            {
                public static System.Text.RegularExpressions.Match Empty { get => throw null; }
                public virtual System.Text.RegularExpressions.GroupCollection Groups { get => throw null; }
                public System.Text.RegularExpressions.Match NextMatch() => throw null;
                public virtual string Result(string replacement) => throw null;
                public static System.Text.RegularExpressions.Match Synchronized(System.Text.RegularExpressions.Match inner) => throw null;
            }
            public class MatchCollection : System.Collections.Generic.ICollection<System.Text.RegularExpressions.Match>, System.Collections.ICollection, System.Collections.Generic.IEnumerable<System.Text.RegularExpressions.Match>, System.Collections.IEnumerable, System.Collections.Generic.IList<System.Text.RegularExpressions.Match>, System.Collections.IList, System.Collections.Generic.IReadOnlyCollection<System.Text.RegularExpressions.Match>, System.Collections.Generic.IReadOnlyList<System.Text.RegularExpressions.Match>
            {
                void System.Collections.Generic.ICollection<System.Text.RegularExpressions.Match>.Add(System.Text.RegularExpressions.Match item) => throw null;
                int System.Collections.IList.Add(object value) => throw null;
                void System.Collections.Generic.ICollection<System.Text.RegularExpressions.Match>.Clear() => throw null;
                void System.Collections.IList.Clear() => throw null;
                bool System.Collections.Generic.ICollection<System.Text.RegularExpressions.Match>.Contains(System.Text.RegularExpressions.Match item) => throw null;
                bool System.Collections.IList.Contains(object value) => throw null;
                public void CopyTo(System.Array array, int arrayIndex) => throw null;
                public void CopyTo(System.Text.RegularExpressions.Match[] array, int arrayIndex) => throw null;
                public int Count { get => throw null; }
                public System.Collections.IEnumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Text.RegularExpressions.Match> System.Collections.Generic.IEnumerable<System.Text.RegularExpressions.Match>.GetEnumerator() => throw null;
                int System.Collections.Generic.IList<System.Text.RegularExpressions.Match>.IndexOf(System.Text.RegularExpressions.Match item) => throw null;
                int System.Collections.IList.IndexOf(object value) => throw null;
                void System.Collections.Generic.IList<System.Text.RegularExpressions.Match>.Insert(int index, System.Text.RegularExpressions.Match item) => throw null;
                void System.Collections.IList.Insert(int index, object value) => throw null;
                bool System.Collections.IList.IsFixedSize { get => throw null; }
                public bool IsReadOnly { get => throw null; }
                public bool IsSynchronized { get => throw null; }
                System.Text.RegularExpressions.Match System.Collections.Generic.IList<System.Text.RegularExpressions.Match>.this[int index] { get => throw null; set { } }
                object System.Collections.IList.this[int index] { get => throw null; set { } }
                bool System.Collections.Generic.ICollection<System.Text.RegularExpressions.Match>.Remove(System.Text.RegularExpressions.Match item) => throw null;
                void System.Collections.IList.Remove(object value) => throw null;
                void System.Collections.Generic.IList<System.Text.RegularExpressions.Match>.RemoveAt(int index) => throw null;
                void System.Collections.IList.RemoveAt(int index) => throw null;
                public object SyncRoot { get => throw null; }
                public virtual System.Text.RegularExpressions.Match this[int i] { get => throw null; }
            }
            public delegate string MatchEvaluator(System.Text.RegularExpressions.Match match);
            public class Regex : System.Runtime.Serialization.ISerializable
            {
                public static int CacheSize { get => throw null; set { } }
                protected System.Collections.Hashtable capnames;
                protected System.Collections.IDictionary CapNames { get => throw null; set { } }
                protected System.Collections.Hashtable caps;
                protected System.Collections.IDictionary Caps { get => throw null; set { } }
                protected int capsize;
                protected string[] capslist;
                public static void CompileToAssembly(System.Text.RegularExpressions.RegexCompilationInfo[] regexinfos, System.Reflection.AssemblyName assemblyname) => throw null;
                public static void CompileToAssembly(System.Text.RegularExpressions.RegexCompilationInfo[] regexinfos, System.Reflection.AssemblyName assemblyname, System.Reflection.Emit.CustomAttributeBuilder[] attributes) => throw null;
                public static void CompileToAssembly(System.Text.RegularExpressions.RegexCompilationInfo[] regexinfos, System.Reflection.AssemblyName assemblyname, System.Reflection.Emit.CustomAttributeBuilder[] attributes, string resourceFile) => throw null;
                public int Count(string input) => throw null;
                public int Count(System.ReadOnlySpan<char> input) => throw null;
                public int Count(System.ReadOnlySpan<char> input, int startat) => throw null;
                public static int Count(string input, string pattern) => throw null;
                public static int Count(string input, string pattern, System.Text.RegularExpressions.RegexOptions options) => throw null;
                public static int Count(string input, string pattern, System.Text.RegularExpressions.RegexOptions options, System.TimeSpan matchTimeout) => throw null;
                public static int Count(System.ReadOnlySpan<char> input, string pattern) => throw null;
                public static int Count(System.ReadOnlySpan<char> input, string pattern, System.Text.RegularExpressions.RegexOptions options) => throw null;
                public static int Count(System.ReadOnlySpan<char> input, string pattern, System.Text.RegularExpressions.RegexOptions options, System.TimeSpan matchTimeout) => throw null;
                protected Regex() => throw null;
                protected Regex(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public Regex(string pattern) => throw null;
                public Regex(string pattern, System.Text.RegularExpressions.RegexOptions options) => throw null;
                public Regex(string pattern, System.Text.RegularExpressions.RegexOptions options, System.TimeSpan matchTimeout) => throw null;
                public System.Text.RegularExpressions.Regex.ValueMatchEnumerator EnumerateMatches(System.ReadOnlySpan<char> input) => throw null;
                public System.Text.RegularExpressions.Regex.ValueMatchEnumerator EnumerateMatches(System.ReadOnlySpan<char> input, int startat) => throw null;
                public static System.Text.RegularExpressions.Regex.ValueMatchEnumerator EnumerateMatches(System.ReadOnlySpan<char> input, string pattern) => throw null;
                public static System.Text.RegularExpressions.Regex.ValueMatchEnumerator EnumerateMatches(System.ReadOnlySpan<char> input, string pattern, System.Text.RegularExpressions.RegexOptions options) => throw null;
                public static System.Text.RegularExpressions.Regex.ValueMatchEnumerator EnumerateMatches(System.ReadOnlySpan<char> input, string pattern, System.Text.RegularExpressions.RegexOptions options, System.TimeSpan matchTimeout) => throw null;
                public static string Escape(string str) => throw null;
                protected System.Text.RegularExpressions.RegexRunnerFactory factory;
                public string[] GetGroupNames() => throw null;
                public int[] GetGroupNumbers() => throw null;
                void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo si, System.Runtime.Serialization.StreamingContext context) => throw null;
                public string GroupNameFromNumber(int i) => throw null;
                public int GroupNumberFromName(string name) => throw null;
                public static readonly System.TimeSpan InfiniteMatchTimeout;
                protected void InitializeReferences() => throw null;
                protected System.TimeSpan internalMatchTimeout;
                public bool IsMatch(System.ReadOnlySpan<char> input) => throw null;
                public bool IsMatch(System.ReadOnlySpan<char> input, int startat) => throw null;
                public static bool IsMatch(System.ReadOnlySpan<char> input, string pattern) => throw null;
                public static bool IsMatch(System.ReadOnlySpan<char> input, string pattern, System.Text.RegularExpressions.RegexOptions options) => throw null;
                public static bool IsMatch(System.ReadOnlySpan<char> input, string pattern, System.Text.RegularExpressions.RegexOptions options, System.TimeSpan matchTimeout) => throw null;
                public bool IsMatch(string input) => throw null;
                public bool IsMatch(string input, int startat) => throw null;
                public static bool IsMatch(string input, string pattern) => throw null;
                public static bool IsMatch(string input, string pattern, System.Text.RegularExpressions.RegexOptions options) => throw null;
                public static bool IsMatch(string input, string pattern, System.Text.RegularExpressions.RegexOptions options, System.TimeSpan matchTimeout) => throw null;
                public System.Text.RegularExpressions.Match Match(string input) => throw null;
                public System.Text.RegularExpressions.Match Match(string input, int startat) => throw null;
                public System.Text.RegularExpressions.Match Match(string input, int beginning, int length) => throw null;
                public static System.Text.RegularExpressions.Match Match(string input, string pattern) => throw null;
                public static System.Text.RegularExpressions.Match Match(string input, string pattern, System.Text.RegularExpressions.RegexOptions options) => throw null;
                public static System.Text.RegularExpressions.Match Match(string input, string pattern, System.Text.RegularExpressions.RegexOptions options, System.TimeSpan matchTimeout) => throw null;
                public System.Text.RegularExpressions.MatchCollection Matches(string input) => throw null;
                public System.Text.RegularExpressions.MatchCollection Matches(string input, int startat) => throw null;
                public static System.Text.RegularExpressions.MatchCollection Matches(string input, string pattern) => throw null;
                public static System.Text.RegularExpressions.MatchCollection Matches(string input, string pattern, System.Text.RegularExpressions.RegexOptions options) => throw null;
                public static System.Text.RegularExpressions.MatchCollection Matches(string input, string pattern, System.Text.RegularExpressions.RegexOptions options, System.TimeSpan matchTimeout) => throw null;
                public System.TimeSpan MatchTimeout { get => throw null; }
                public System.Text.RegularExpressions.RegexOptions Options { get => throw null; }
                protected string pattern;
                public string Replace(string input, string replacement) => throw null;
                public string Replace(string input, string replacement, int count) => throw null;
                public string Replace(string input, string replacement, int count, int startat) => throw null;
                public static string Replace(string input, string pattern, string replacement) => throw null;
                public static string Replace(string input, string pattern, string replacement, System.Text.RegularExpressions.RegexOptions options) => throw null;
                public static string Replace(string input, string pattern, string replacement, System.Text.RegularExpressions.RegexOptions options, System.TimeSpan matchTimeout) => throw null;
                public static string Replace(string input, string pattern, System.Text.RegularExpressions.MatchEvaluator evaluator) => throw null;
                public static string Replace(string input, string pattern, System.Text.RegularExpressions.MatchEvaluator evaluator, System.Text.RegularExpressions.RegexOptions options) => throw null;
                public static string Replace(string input, string pattern, System.Text.RegularExpressions.MatchEvaluator evaluator, System.Text.RegularExpressions.RegexOptions options, System.TimeSpan matchTimeout) => throw null;
                public string Replace(string input, System.Text.RegularExpressions.MatchEvaluator evaluator) => throw null;
                public string Replace(string input, System.Text.RegularExpressions.MatchEvaluator evaluator, int count) => throw null;
                public string Replace(string input, System.Text.RegularExpressions.MatchEvaluator evaluator, int count, int startat) => throw null;
                public bool RightToLeft { get => throw null; }
                protected System.Text.RegularExpressions.RegexOptions roptions;
                public string[] Split(string input) => throw null;
                public string[] Split(string input, int count) => throw null;
                public string[] Split(string input, int count, int startat) => throw null;
                public static string[] Split(string input, string pattern) => throw null;
                public static string[] Split(string input, string pattern, System.Text.RegularExpressions.RegexOptions options) => throw null;
                public static string[] Split(string input, string pattern, System.Text.RegularExpressions.RegexOptions options, System.TimeSpan matchTimeout) => throw null;
                public override string ToString() => throw null;
                public static string Unescape(string str) => throw null;
                protected bool UseOptionC() => throw null;
                protected bool UseOptionR() => throw null;
                protected static void ValidateMatchTimeout(System.TimeSpan matchTimeout) => throw null;
                public struct ValueMatchEnumerator
                {
                    public System.Text.RegularExpressions.ValueMatch Current { get => throw null; }
                    public System.Text.RegularExpressions.Regex.ValueMatchEnumerator GetEnumerator() => throw null;
                    public bool MoveNext() => throw null;
                }
            }
            public class RegexCompilationInfo
            {
                public RegexCompilationInfo(string pattern, System.Text.RegularExpressions.RegexOptions options, string name, string fullnamespace, bool ispublic) => throw null;
                public RegexCompilationInfo(string pattern, System.Text.RegularExpressions.RegexOptions options, string name, string fullnamespace, bool ispublic, System.TimeSpan matchTimeout) => throw null;
                public bool IsPublic { get => throw null; set { } }
                public System.TimeSpan MatchTimeout { get => throw null; set { } }
                public string Name { get => throw null; set { } }
                public string Namespace { get => throw null; set { } }
                public System.Text.RegularExpressions.RegexOptions Options { get => throw null; set { } }
                public string Pattern { get => throw null; set { } }
            }
            public class RegexMatchTimeoutException : System.TimeoutException, System.Runtime.Serialization.ISerializable
            {
                public RegexMatchTimeoutException() => throw null;
                protected RegexMatchTimeoutException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public RegexMatchTimeoutException(string message) => throw null;
                public RegexMatchTimeoutException(string message, System.Exception inner) => throw null;
                public RegexMatchTimeoutException(string regexInput, string regexPattern, System.TimeSpan matchTimeout) => throw null;
                void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public string Input { get => throw null; }
                public System.TimeSpan MatchTimeout { get => throw null; }
                public string Pattern { get => throw null; }
            }
            [System.Flags]
            public enum RegexOptions
            {
                None = 0,
                IgnoreCase = 1,
                Multiline = 2,
                ExplicitCapture = 4,
                Compiled = 8,
                Singleline = 16,
                IgnorePatternWhitespace = 32,
                RightToLeft = 64,
                ECMAScript = 256,
                CultureInvariant = 512,
                NonBacktracking = 1024,
            }
            public enum RegexParseError
            {
                Unknown = 0,
                AlternationHasTooManyConditions = 1,
                AlternationHasMalformedCondition = 2,
                InvalidUnicodePropertyEscape = 3,
                MalformedUnicodePropertyEscape = 4,
                UnrecognizedEscape = 5,
                UnrecognizedControlCharacter = 6,
                MissingControlCharacter = 7,
                InsufficientOrInvalidHexDigits = 8,
                QuantifierOrCaptureGroupOutOfRange = 9,
                UndefinedNamedReference = 10,
                UndefinedNumberedReference = 11,
                MalformedNamedReference = 12,
                UnescapedEndingBackslash = 13,
                UnterminatedComment = 14,
                InvalidGroupingConstruct = 15,
                AlternationHasNamedCapture = 16,
                AlternationHasComment = 17,
                AlternationHasMalformedReference = 18,
                AlternationHasUndefinedReference = 19,
                CaptureGroupNameInvalid = 20,
                CaptureGroupOfZero = 21,
                UnterminatedBracket = 22,
                ExclusionGroupNotLast = 23,
                ReversedCharacterRange = 24,
                ShorthandClassInCharacterRange = 25,
                InsufficientClosingParentheses = 26,
                ReversedQuantifierRange = 27,
                NestedQuantifiersNotParenthesized = 28,
                QuantifierAfterNothing = 29,
                InsufficientOpeningParentheses = 30,
                UnrecognizedUnicodeProperty = 31,
            }
            public sealed class RegexParseException : System.ArgumentException
            {
                public System.Text.RegularExpressions.RegexParseError Error { get => throw null; }
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public int Offset { get => throw null; }
            }
            public abstract class RegexRunner
            {
                protected void Capture(int capnum, int start, int end) => throw null;
                public static bool CharInClass(char ch, string charClass) => throw null;
                protected static bool CharInSet(char ch, string set, string category) => throw null;
                protected void CheckTimeout() => throw null;
                protected void Crawl(int i) => throw null;
                protected int Crawlpos() => throw null;
                protected RegexRunner() => throw null;
                protected void DoubleCrawl() => throw null;
                protected void DoubleStack() => throw null;
                protected void DoubleTrack() => throw null;
                protected void EnsureStorage() => throw null;
                protected virtual bool FindFirstChar() => throw null;
                protected virtual void Go() => throw null;
                protected virtual void InitTrackCount() => throw null;
                protected bool IsBoundary(int index, int startpos, int endpos) => throw null;
                protected bool IsECMABoundary(int index, int startpos, int endpos) => throw null;
                protected bool IsMatched(int cap) => throw null;
                protected int MatchIndex(int cap) => throw null;
                protected int MatchLength(int cap) => throw null;
                protected int Popcrawl() => throw null;
                protected int[] runcrawl;
                protected int runcrawlpos;
                protected System.Text.RegularExpressions.Match runmatch;
                protected System.Text.RegularExpressions.Regex runregex;
                protected int[] runstack;
                protected int runstackpos;
                protected string runtext;
                protected int runtextbeg;
                protected int runtextend;
                protected int runtextpos;
                protected int runtextstart;
                protected int[] runtrack;
                protected int runtrackcount;
                protected int runtrackpos;
                protected System.Text.RegularExpressions.Match Scan(System.Text.RegularExpressions.Regex regex, string text, int textbeg, int textend, int textstart, int prevlen, bool quick) => throw null;
                protected System.Text.RegularExpressions.Match Scan(System.Text.RegularExpressions.Regex regex, string text, int textbeg, int textend, int textstart, int prevlen, bool quick, System.TimeSpan timeout) => throw null;
                protected virtual void Scan(System.ReadOnlySpan<char> text) => throw null;
                protected void TransferCapture(int capnum, int uncapnum, int start, int end) => throw null;
                protected void Uncapture() => throw null;
            }
            public abstract class RegexRunnerFactory
            {
                protected abstract System.Text.RegularExpressions.RegexRunner CreateInstance();
                protected RegexRunnerFactory() => throw null;
            }
            public struct ValueMatch
            {
                public int Index { get => throw null; }
                public int Length { get => throw null; }
            }
        }
    }
}
