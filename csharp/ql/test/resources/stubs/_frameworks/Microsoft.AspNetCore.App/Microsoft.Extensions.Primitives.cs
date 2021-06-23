// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace Primitives
        {
            // Generated from `Microsoft.Extensions.Primitives.CancellationChangeToken` in `Microsoft.Extensions.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class CancellationChangeToken : Microsoft.Extensions.Primitives.IChangeToken
            {
                public bool ActiveChangeCallbacks { get => throw null; }
                public CancellationChangeToken(System.Threading.CancellationToken cancellationToken) => throw null;
                public bool HasChanged { get => throw null; }
                public System.IDisposable RegisterChangeCallback(System.Action<object> callback, object state) => throw null;
            }

            // Generated from `Microsoft.Extensions.Primitives.ChangeToken` in `Microsoft.Extensions.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ChangeToken
            {
                public static System.IDisposable OnChange<TState>(System.Func<Microsoft.Extensions.Primitives.IChangeToken> changeTokenProducer, System.Action<TState> changeTokenConsumer, TState state) => throw null;
                public static System.IDisposable OnChange(System.Func<Microsoft.Extensions.Primitives.IChangeToken> changeTokenProducer, System.Action changeTokenConsumer) => throw null;
            }

            // Generated from `Microsoft.Extensions.Primitives.CompositeChangeToken` in `Microsoft.Extensions.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class CompositeChangeToken : Microsoft.Extensions.Primitives.IChangeToken
            {
                public bool ActiveChangeCallbacks { get => throw null; }
                public System.Collections.Generic.IReadOnlyList<Microsoft.Extensions.Primitives.IChangeToken> ChangeTokens { get => throw null; }
                public CompositeChangeToken(System.Collections.Generic.IReadOnlyList<Microsoft.Extensions.Primitives.IChangeToken> changeTokens) => throw null;
                public bool HasChanged { get => throw null; }
                public System.IDisposable RegisterChangeCallback(System.Action<object> callback, object state) => throw null;
            }

            // Generated from `Microsoft.Extensions.Primitives.Extensions` in `Microsoft.Extensions.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class Extensions
            {
                public static System.Text.StringBuilder Append(this System.Text.StringBuilder builder, Microsoft.Extensions.Primitives.StringSegment segment) => throw null;
            }

            // Generated from `Microsoft.Extensions.Primitives.IChangeToken` in `Microsoft.Extensions.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IChangeToken
            {
                bool ActiveChangeCallbacks { get; }
                bool HasChanged { get; }
                System.IDisposable RegisterChangeCallback(System.Action<object> callback, object state);
            }

            // Generated from `Microsoft.Extensions.Primitives.StringSegment` in `Microsoft.Extensions.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public struct StringSegment : System.IEquatable<string>, System.IEquatable<Microsoft.Extensions.Primitives.StringSegment>
            {
                public static bool operator !=(Microsoft.Extensions.Primitives.StringSegment left, Microsoft.Extensions.Primitives.StringSegment right) => throw null;
                public static bool operator ==(Microsoft.Extensions.Primitives.StringSegment left, Microsoft.Extensions.Primitives.StringSegment right) => throw null;
                public System.ReadOnlyMemory<System.Char> AsMemory() => throw null;
                public System.ReadOnlySpan<System.Char> AsSpan() => throw null;
                public string Buffer { get => throw null; }
                public static int Compare(Microsoft.Extensions.Primitives.StringSegment a, Microsoft.Extensions.Primitives.StringSegment b, System.StringComparison comparisonType) => throw null;
                public static Microsoft.Extensions.Primitives.StringSegment Empty;
                public bool EndsWith(string text, System.StringComparison comparisonType) => throw null;
                public static bool Equals(Microsoft.Extensions.Primitives.StringSegment a, Microsoft.Extensions.Primitives.StringSegment b, System.StringComparison comparisonType) => throw null;
                public override bool Equals(object obj) => throw null;
                public bool Equals(string text, System.StringComparison comparisonType) => throw null;
                public bool Equals(string text) => throw null;
                public bool Equals(Microsoft.Extensions.Primitives.StringSegment other, System.StringComparison comparisonType) => throw null;
                public bool Equals(Microsoft.Extensions.Primitives.StringSegment other) => throw null;
                public override int GetHashCode() => throw null;
                public bool HasValue { get => throw null; }
                public int IndexOf(System.Char c, int start, int count) => throw null;
                public int IndexOf(System.Char c, int start) => throw null;
                public int IndexOf(System.Char c) => throw null;
                public int IndexOfAny(System.Char[] anyOf, int startIndex, int count) => throw null;
                public int IndexOfAny(System.Char[] anyOf, int startIndex) => throw null;
                public int IndexOfAny(System.Char[] anyOf) => throw null;
                public static bool IsNullOrEmpty(Microsoft.Extensions.Primitives.StringSegment value) => throw null;
                public System.Char this[int index] { get => throw null; }
                public int LastIndexOf(System.Char value) => throw null;
                public int Length { get => throw null; }
                public int Offset { get => throw null; }
                public Microsoft.Extensions.Primitives.StringTokenizer Split(System.Char[] chars) => throw null;
                public bool StartsWith(string text, System.StringComparison comparisonType) => throw null;
                public StringSegment(string buffer, int offset, int length) => throw null;
                public StringSegment(string buffer) => throw null;
                // Stub generator skipped constructor 
                public Microsoft.Extensions.Primitives.StringSegment Subsegment(int offset, int length) => throw null;
                public Microsoft.Extensions.Primitives.StringSegment Subsegment(int offset) => throw null;
                public string Substring(int offset, int length) => throw null;
                public string Substring(int offset) => throw null;
                public override string ToString() => throw null;
                public Microsoft.Extensions.Primitives.StringSegment Trim() => throw null;
                public Microsoft.Extensions.Primitives.StringSegment TrimEnd() => throw null;
                public Microsoft.Extensions.Primitives.StringSegment TrimStart() => throw null;
                public string Value { get => throw null; }
                public static implicit operator System.ReadOnlySpan<System.Char>(Microsoft.Extensions.Primitives.StringSegment segment) => throw null;
                public static implicit operator System.ReadOnlyMemory<System.Char>(Microsoft.Extensions.Primitives.StringSegment segment) => throw null;
                public static implicit operator Microsoft.Extensions.Primitives.StringSegment(string value) => throw null;
            }

            // Generated from `Microsoft.Extensions.Primitives.StringSegmentComparer` in `Microsoft.Extensions.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class StringSegmentComparer : System.Collections.Generic.IEqualityComparer<Microsoft.Extensions.Primitives.StringSegment>, System.Collections.Generic.IComparer<Microsoft.Extensions.Primitives.StringSegment>
            {
                public int Compare(Microsoft.Extensions.Primitives.StringSegment x, Microsoft.Extensions.Primitives.StringSegment y) => throw null;
                public bool Equals(Microsoft.Extensions.Primitives.StringSegment x, Microsoft.Extensions.Primitives.StringSegment y) => throw null;
                public int GetHashCode(Microsoft.Extensions.Primitives.StringSegment obj) => throw null;
                public static Microsoft.Extensions.Primitives.StringSegmentComparer Ordinal { get => throw null; }
                public static Microsoft.Extensions.Primitives.StringSegmentComparer OrdinalIgnoreCase { get => throw null; }
            }

            // Generated from `Microsoft.Extensions.Primitives.StringTokenizer` in `Microsoft.Extensions.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public struct StringTokenizer : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<Microsoft.Extensions.Primitives.StringSegment>
            {
                // Generated from `Microsoft.Extensions.Primitives.StringTokenizer+Enumerator` in `Microsoft.Extensions.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public struct Enumerator : System.IDisposable, System.Collections.IEnumerator, System.Collections.Generic.IEnumerator<Microsoft.Extensions.Primitives.StringSegment>
                {
                    public Microsoft.Extensions.Primitives.StringSegment Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    public void Dispose() => throw null;
                    public Enumerator(ref Microsoft.Extensions.Primitives.StringTokenizer tokenizer) => throw null;
                    // Stub generator skipped constructor 
                    public bool MoveNext() => throw null;
                    public void Reset() => throw null;
                }


                public Microsoft.Extensions.Primitives.StringTokenizer.Enumerator GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<Microsoft.Extensions.Primitives.StringSegment> System.Collections.Generic.IEnumerable<Microsoft.Extensions.Primitives.StringSegment>.GetEnumerator() => throw null;
                public StringTokenizer(string value, System.Char[] separators) => throw null;
                public StringTokenizer(Microsoft.Extensions.Primitives.StringSegment value, System.Char[] separators) => throw null;
                // Stub generator skipped constructor 
            }

            // Generated from `Microsoft.Extensions.Primitives.StringValues` in `Microsoft.Extensions.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public struct StringValues : System.IEquatable<string[]>, System.IEquatable<string>, System.IEquatable<Microsoft.Extensions.Primitives.StringValues>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyList<string>, System.Collections.Generic.IReadOnlyCollection<string>, System.Collections.Generic.IList<string>, System.Collections.Generic.IEnumerable<string>, System.Collections.Generic.ICollection<string>
            {
                public static bool operator !=(string[] left, Microsoft.Extensions.Primitives.StringValues right) => throw null;
                public static bool operator !=(string left, Microsoft.Extensions.Primitives.StringValues right) => throw null;
                public static bool operator !=(object left, Microsoft.Extensions.Primitives.StringValues right) => throw null;
                public static bool operator !=(Microsoft.Extensions.Primitives.StringValues left, string[] right) => throw null;
                public static bool operator !=(Microsoft.Extensions.Primitives.StringValues left, string right) => throw null;
                public static bool operator !=(Microsoft.Extensions.Primitives.StringValues left, object right) => throw null;
                public static bool operator !=(Microsoft.Extensions.Primitives.StringValues left, Microsoft.Extensions.Primitives.StringValues right) => throw null;
                public static bool operator ==(string[] left, Microsoft.Extensions.Primitives.StringValues right) => throw null;
                public static bool operator ==(string left, Microsoft.Extensions.Primitives.StringValues right) => throw null;
                public static bool operator ==(object left, Microsoft.Extensions.Primitives.StringValues right) => throw null;
                public static bool operator ==(Microsoft.Extensions.Primitives.StringValues left, string[] right) => throw null;
                public static bool operator ==(Microsoft.Extensions.Primitives.StringValues left, string right) => throw null;
                public static bool operator ==(Microsoft.Extensions.Primitives.StringValues left, object right) => throw null;
                public static bool operator ==(Microsoft.Extensions.Primitives.StringValues left, Microsoft.Extensions.Primitives.StringValues right) => throw null;
                void System.Collections.Generic.ICollection<string>.Add(string item) => throw null;
                void System.Collections.Generic.ICollection<string>.Clear() => throw null;
                public static Microsoft.Extensions.Primitives.StringValues Concat(string value, Microsoft.Extensions.Primitives.StringValues values) => throw null;
                public static Microsoft.Extensions.Primitives.StringValues Concat(Microsoft.Extensions.Primitives.StringValues values1, Microsoft.Extensions.Primitives.StringValues values2) => throw null;
                public static Microsoft.Extensions.Primitives.StringValues Concat(Microsoft.Extensions.Primitives.StringValues values, string value) => throw null;
                bool System.Collections.Generic.ICollection<string>.Contains(string item) => throw null;
                void System.Collections.Generic.ICollection<string>.CopyTo(string[] array, int arrayIndex) => throw null;
                public int Count { get => throw null; }
                public static Microsoft.Extensions.Primitives.StringValues Empty;
                // Generated from `Microsoft.Extensions.Primitives.StringValues+Enumerator` in `Microsoft.Extensions.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public struct Enumerator : System.IDisposable, System.Collections.IEnumerator, System.Collections.Generic.IEnumerator<string>
                {
                    public string Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    public void Dispose() => throw null;
                    public Enumerator(ref Microsoft.Extensions.Primitives.StringValues values) => throw null;
                    // Stub generator skipped constructor 
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }


                public static bool Equals(string[] left, Microsoft.Extensions.Primitives.StringValues right) => throw null;
                public static bool Equals(string left, Microsoft.Extensions.Primitives.StringValues right) => throw null;
                public static bool Equals(Microsoft.Extensions.Primitives.StringValues left, string[] right) => throw null;
                public static bool Equals(Microsoft.Extensions.Primitives.StringValues left, string right) => throw null;
                public static bool Equals(Microsoft.Extensions.Primitives.StringValues left, Microsoft.Extensions.Primitives.StringValues right) => throw null;
                public override bool Equals(object obj) => throw null;
                public bool Equals(string[] other) => throw null;
                public bool Equals(string other) => throw null;
                public bool Equals(Microsoft.Extensions.Primitives.StringValues other) => throw null;
                public Microsoft.Extensions.Primitives.StringValues.Enumerator GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<string> System.Collections.Generic.IEnumerable<string>.GetEnumerator() => throw null;
                public override int GetHashCode() => throw null;
                int System.Collections.Generic.IList<string>.IndexOf(string item) => throw null;
                void System.Collections.Generic.IList<string>.Insert(int index, string item) => throw null;
                public static bool IsNullOrEmpty(Microsoft.Extensions.Primitives.StringValues value) => throw null;
                bool System.Collections.Generic.ICollection<string>.IsReadOnly { get => throw null; }
                string System.Collections.Generic.IList<string>.this[int index] { get => throw null; set => throw null; }
                public string this[int index] { get => throw null; }
                bool System.Collections.Generic.ICollection<string>.Remove(string item) => throw null;
                void System.Collections.Generic.IList<string>.RemoveAt(int index) => throw null;
                public StringValues(string[] values) => throw null;
                public StringValues(string value) => throw null;
                // Stub generator skipped constructor 
                public string[] ToArray() => throw null;
                public override string ToString() => throw null;
                public static implicit operator string[](Microsoft.Extensions.Primitives.StringValues value) => throw null;
                public static implicit operator string(Microsoft.Extensions.Primitives.StringValues values) => throw null;
                public static implicit operator Microsoft.Extensions.Primitives.StringValues(string[] values) => throw null;
                public static implicit operator Microsoft.Extensions.Primitives.StringValues(string value) => throw null;
            }

        }
    }
}
