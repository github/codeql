// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Razor
        {
            namespace TagHelpers
            {
                // Generated from `Microsoft.AspNetCore.Razor.TagHelpers.DefaultTagHelperContent` in `Microsoft.AspNetCore.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class DefaultTagHelperContent : Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContent
                {
                    public override Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContent Append(string unencoded) => throw null;
                    public override Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContent AppendHtml(string encoded) => throw null;
                    public override Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContent AppendHtml(Microsoft.AspNetCore.Html.IHtmlContent htmlContent) => throw null;
                    public override Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContent Clear() => throw null;
                    public override void CopyTo(Microsoft.AspNetCore.Html.IHtmlContentBuilder destination) => throw null;
                    public DefaultTagHelperContent() => throw null;
                    public override string GetContent(System.Text.Encodings.Web.HtmlEncoder encoder) => throw null;
                    public override string GetContent() => throw null;
                    public override bool IsEmptyOrWhiteSpace { get => throw null; }
                    public override bool IsModified { get => throw null; }
                    public override void MoveTo(Microsoft.AspNetCore.Html.IHtmlContentBuilder destination) => throw null;
                    public override void Reinitialize() => throw null;
                    public override void WriteTo(System.IO.TextWriter writer, System.Text.Encodings.Web.HtmlEncoder encoder) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeNameAttribute` in `Microsoft.AspNetCore.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class HtmlAttributeNameAttribute : System.Attribute
                {
                    public string DictionaryAttributePrefix { get => throw null; set => throw null; }
                    public bool DictionaryAttributePrefixSet { get => throw null; }
                    public HtmlAttributeNameAttribute(string name) => throw null;
                    public HtmlAttributeNameAttribute() => throw null;
                    public string Name { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeNotBoundAttribute` in `Microsoft.AspNetCore.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class HtmlAttributeNotBoundAttribute : System.Attribute
                {
                    public HtmlAttributeNotBoundAttribute() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle` in `Microsoft.AspNetCore.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public enum HtmlAttributeValueStyle
                {
                    DoubleQuotes,
                    Minimized,
                    NoQuotes,
                    SingleQuotes,
                }

                // Generated from `Microsoft.AspNetCore.Razor.TagHelpers.HtmlTargetElementAttribute` in `Microsoft.AspNetCore.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class HtmlTargetElementAttribute : System.Attribute
                {
                    public string Attributes { get => throw null; set => throw null; }
                    public const string ElementCatchAllTarget = default;
                    public HtmlTargetElementAttribute(string tag) => throw null;
                    public HtmlTargetElementAttribute() => throw null;
                    public string ParentTag { get => throw null; set => throw null; }
                    public string Tag { get => throw null; }
                    public Microsoft.AspNetCore.Razor.TagHelpers.TagStructure TagStructure { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Razor.TagHelpers.ITagHelper` in `Microsoft.AspNetCore.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface ITagHelper : Microsoft.AspNetCore.Razor.TagHelpers.ITagHelperComponent
                {
                }

                // Generated from `Microsoft.AspNetCore.Razor.TagHelpers.ITagHelperComponent` in `Microsoft.AspNetCore.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface ITagHelperComponent
                {
                    void Init(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context);
                    int Order { get; }
                    System.Threading.Tasks.Task ProcessAsync(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output);
                }

                // Generated from `Microsoft.AspNetCore.Razor.TagHelpers.NullHtmlEncoder` in `Microsoft.AspNetCore.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class NullHtmlEncoder : System.Text.Encodings.Web.HtmlEncoder
                {
                    public static Microsoft.AspNetCore.Razor.TagHelpers.NullHtmlEncoder Default { get => throw null; }
                    public override void Encode(System.IO.TextWriter output, string value, int startIndex, int characterCount) => throw null;
                    public override void Encode(System.IO.TextWriter output, System.Char[] value, int startIndex, int characterCount) => throw null;
                    public override string Encode(string value) => throw null;
                    unsafe public override int FindFirstCharacterToEncode(System.Char* text, int textLength) => throw null;
                    public override int MaxOutputCharactersPerInputCharacter { get => throw null; }
                    unsafe public override bool TryEncodeUnicodeScalar(int unicodeScalar, System.Char* buffer, int bufferLength, out int numberOfCharactersWritten) => throw null;
                    public override bool WillEncode(int unicodeScalar) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Razor.TagHelpers.OutputElementHintAttribute` in `Microsoft.AspNetCore.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class OutputElementHintAttribute : System.Attribute
                {
                    public string OutputElement { get => throw null; }
                    public OutputElementHintAttribute(string outputElement) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Razor.TagHelpers.ReadOnlyTagHelperAttributeList` in `Microsoft.AspNetCore.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class ReadOnlyTagHelperAttributeList : System.Collections.ObjectModel.ReadOnlyCollection<Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute>
                {
                    public bool ContainsName(string name) => throw null;
                    public int IndexOfName(string name) => throw null;
                    public Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute this[string name] { get => throw null; }
                    protected static bool NameEquals(string name, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute attribute) => throw null;
                    public ReadOnlyTagHelperAttributeList(System.Collections.Generic.IList<Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute> attributes) : base(default(System.Collections.Generic.IList<Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute>)) => throw null;
                    protected ReadOnlyTagHelperAttributeList() : base(default(System.Collections.Generic.IList<Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute>)) => throw null;
                    public bool TryGetAttribute(string name, out Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute attribute) => throw null;
                    public bool TryGetAttributes(string name, out System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute> attributes) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Razor.TagHelpers.RestrictChildrenAttribute` in `Microsoft.AspNetCore.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RestrictChildrenAttribute : System.Attribute
                {
                    public System.Collections.Generic.IEnumerable<string> ChildTags { get => throw null; }
                    public RestrictChildrenAttribute(string childTag, params string[] childTags) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Razor.TagHelpers.TagHelper` in `Microsoft.AspNetCore.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class TagHelper : Microsoft.AspNetCore.Razor.TagHelpers.ITagHelperComponent, Microsoft.AspNetCore.Razor.TagHelpers.ITagHelper
                {
                    public virtual void Init(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context) => throw null;
                    public virtual int Order { get => throw null; }
                    public virtual void Process(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output) => throw null;
                    public virtual System.Threading.Tasks.Task ProcessAsync(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output) => throw null;
                    protected TagHelper() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute` in `Microsoft.AspNetCore.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class TagHelperAttribute : Microsoft.AspNetCore.Html.IHtmlContentContainer, Microsoft.AspNetCore.Html.IHtmlContent
                {
                    public void CopyTo(Microsoft.AspNetCore.Html.IHtmlContentBuilder destination) => throw null;
                    public override bool Equals(object obj) => throw null;
                    public bool Equals(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute other) => throw null;
                    public override int GetHashCode() => throw null;
                    public void MoveTo(Microsoft.AspNetCore.Html.IHtmlContentBuilder destination) => throw null;
                    public string Name { get => throw null; }
                    public TagHelperAttribute(string name, object value, Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle valueStyle) => throw null;
                    public TagHelperAttribute(string name, object value) => throw null;
                    public TagHelperAttribute(string name) => throw null;
                    public object Value { get => throw null; }
                    public Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle ValueStyle { get => throw null; }
                    public void WriteTo(System.IO.TextWriter writer, System.Text.Encodings.Web.HtmlEncoder encoder) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttributeList` in `Microsoft.AspNetCore.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class TagHelperAttributeList : Microsoft.AspNetCore.Razor.TagHelpers.ReadOnlyTagHelperAttributeList, System.Collections.IEnumerable, System.Collections.Generic.IList<Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute>, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute>, System.Collections.Generic.ICollection<Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute>
                {
                    public void Add(string name, object value) => throw null;
                    public void Add(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute attribute) => throw null;
                    public void Clear() => throw null;
                    public void Insert(int index, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute attribute) => throw null;
                    bool System.Collections.Generic.ICollection<Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute>.IsReadOnly { get => throw null; }
                    public Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute this[int index] { get => throw null; set => throw null; }
                    public bool Remove(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute attribute) => throw null;
                    public bool RemoveAll(string name) => throw null;
                    public void RemoveAt(int index) => throw null;
                    public void SetAttribute(string name, object value) => throw null;
                    public void SetAttribute(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute attribute) => throw null;
                    public TagHelperAttributeList(System.Collections.Generic.List<Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute> attributes) => throw null;
                    public TagHelperAttributeList(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute> attributes) => throw null;
                    public TagHelperAttributeList() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Razor.TagHelpers.TagHelperComponent` in `Microsoft.AspNetCore.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class TagHelperComponent : Microsoft.AspNetCore.Razor.TagHelpers.ITagHelperComponent
                {
                    public virtual void Init(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context) => throw null;
                    public virtual int Order { get => throw null; }
                    public virtual void Process(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output) => throw null;
                    public virtual System.Threading.Tasks.Task ProcessAsync(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output) => throw null;
                    protected TagHelperComponent() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContent` in `Microsoft.AspNetCore.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class TagHelperContent : Microsoft.AspNetCore.Html.IHtmlContentContainer, Microsoft.AspNetCore.Html.IHtmlContentBuilder, Microsoft.AspNetCore.Html.IHtmlContent
                {
                    public abstract Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContent Append(string unencoded);
                    Microsoft.AspNetCore.Html.IHtmlContentBuilder Microsoft.AspNetCore.Html.IHtmlContentBuilder.Append(string unencoded) => throw null;
                    public Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContent AppendFormat(string format, params object[] args) => throw null;
                    public Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContent AppendFormat(System.IFormatProvider provider, string format, params object[] args) => throw null;
                    public abstract Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContent AppendHtml(string encoded);
                    public abstract Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContent AppendHtml(Microsoft.AspNetCore.Html.IHtmlContent htmlContent);
                    Microsoft.AspNetCore.Html.IHtmlContentBuilder Microsoft.AspNetCore.Html.IHtmlContentBuilder.AppendHtml(string encoded) => throw null;
                    Microsoft.AspNetCore.Html.IHtmlContentBuilder Microsoft.AspNetCore.Html.IHtmlContentBuilder.AppendHtml(Microsoft.AspNetCore.Html.IHtmlContent content) => throw null;
                    public abstract Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContent Clear();
                    Microsoft.AspNetCore.Html.IHtmlContentBuilder Microsoft.AspNetCore.Html.IHtmlContentBuilder.Clear() => throw null;
                    public abstract void CopyTo(Microsoft.AspNetCore.Html.IHtmlContentBuilder destination);
                    public abstract string GetContent(System.Text.Encodings.Web.HtmlEncoder encoder);
                    public abstract string GetContent();
                    public abstract bool IsEmptyOrWhiteSpace { get; }
                    public abstract bool IsModified { get; }
                    public abstract void MoveTo(Microsoft.AspNetCore.Html.IHtmlContentBuilder destination);
                    public abstract void Reinitialize();
                    public Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContent SetContent(string unencoded) => throw null;
                    public Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContent SetHtmlContent(string encoded) => throw null;
                    public Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContent SetHtmlContent(Microsoft.AspNetCore.Html.IHtmlContent htmlContent) => throw null;
                    protected TagHelperContent() => throw null;
                    public abstract void WriteTo(System.IO.TextWriter writer, System.Text.Encodings.Web.HtmlEncoder encoder);
                }

                // Generated from `Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext` in `Microsoft.AspNetCore.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class TagHelperContext
                {
                    public Microsoft.AspNetCore.Razor.TagHelpers.ReadOnlyTagHelperAttributeList AllAttributes { get => throw null; }
                    public System.Collections.Generic.IDictionary<object, object> Items { get => throw null; }
                    public void Reinitialize(string tagName, System.Collections.Generic.IDictionary<object, object> items, string uniqueId) => throw null;
                    public void Reinitialize(System.Collections.Generic.IDictionary<object, object> items, string uniqueId) => throw null;
                    public TagHelperContext(string tagName, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttributeList allAttributes, System.Collections.Generic.IDictionary<object, object> items, string uniqueId) => throw null;
                    public TagHelperContext(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttributeList allAttributes, System.Collections.Generic.IDictionary<object, object> items, string uniqueId) => throw null;
                    public string TagName { get => throw null; }
                    public string UniqueId { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput` in `Microsoft.AspNetCore.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class TagHelperOutput : Microsoft.AspNetCore.Html.IHtmlContentContainer, Microsoft.AspNetCore.Html.IHtmlContent
                {
                    public Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttributeList Attributes { get => throw null; }
                    public Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContent Content { get => throw null; set => throw null; }
                    void Microsoft.AspNetCore.Html.IHtmlContentContainer.CopyTo(Microsoft.AspNetCore.Html.IHtmlContentBuilder destination) => throw null;
                    public System.Threading.Tasks.Task<Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContent> GetChildContentAsync(bool useCachedResult, System.Text.Encodings.Web.HtmlEncoder encoder) => throw null;
                    public System.Threading.Tasks.Task<Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContent> GetChildContentAsync(bool useCachedResult) => throw null;
                    public System.Threading.Tasks.Task<Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContent> GetChildContentAsync(System.Text.Encodings.Web.HtmlEncoder encoder) => throw null;
                    public System.Threading.Tasks.Task<Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContent> GetChildContentAsync() => throw null;
                    public bool IsContentModified { get => throw null; }
                    void Microsoft.AspNetCore.Html.IHtmlContentContainer.MoveTo(Microsoft.AspNetCore.Html.IHtmlContentBuilder destination) => throw null;
                    public Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContent PostContent { get => throw null; }
                    public Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContent PostElement { get => throw null; }
                    public Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContent PreContent { get => throw null; }
                    public Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContent PreElement { get => throw null; }
                    public void Reinitialize(string tagName, Microsoft.AspNetCore.Razor.TagHelpers.TagMode tagMode) => throw null;
                    public void SuppressOutput() => throw null;
                    public TagHelperOutput(string tagName, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttributeList attributes, System.Func<bool, System.Text.Encodings.Web.HtmlEncoder, System.Threading.Tasks.Task<Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContent>> getChildContentAsync) => throw null;
                    public Microsoft.AspNetCore.Razor.TagHelpers.TagMode TagMode { get => throw null; set => throw null; }
                    public string TagName { get => throw null; set => throw null; }
                    public void WriteTo(System.IO.TextWriter writer, System.Text.Encodings.Web.HtmlEncoder encoder) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Razor.TagHelpers.TagMode` in `Microsoft.AspNetCore.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public enum TagMode
                {
                    SelfClosing,
                    StartTagAndEndTag,
                    StartTagOnly,
                }

                // Generated from `Microsoft.AspNetCore.Razor.TagHelpers.TagStructure` in `Microsoft.AspNetCore.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public enum TagStructure
                {
                    NormalOrSelfClosing,
                    Unspecified,
                    WithoutEndTag,
                }

            }
        }
    }
}
