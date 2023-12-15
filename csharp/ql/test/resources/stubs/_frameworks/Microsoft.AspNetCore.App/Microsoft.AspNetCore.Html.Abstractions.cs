// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Html.Abstractions, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Html
        {
            public class HtmlContentBuilder : Microsoft.AspNetCore.Html.IHtmlContent, Microsoft.AspNetCore.Html.IHtmlContentBuilder, Microsoft.AspNetCore.Html.IHtmlContentContainer
            {
                public Microsoft.AspNetCore.Html.IHtmlContentBuilder Append(string unencoded) => throw null;
                public Microsoft.AspNetCore.Html.IHtmlContentBuilder AppendHtml(Microsoft.AspNetCore.Html.IHtmlContent htmlContent) => throw null;
                public Microsoft.AspNetCore.Html.IHtmlContentBuilder AppendHtml(string encoded) => throw null;
                public Microsoft.AspNetCore.Html.IHtmlContentBuilder Clear() => throw null;
                public void CopyTo(Microsoft.AspNetCore.Html.IHtmlContentBuilder destination) => throw null;
                public int Count { get => throw null; }
                public HtmlContentBuilder() => throw null;
                public HtmlContentBuilder(int capacity) => throw null;
                public HtmlContentBuilder(System.Collections.Generic.IList<object> entries) => throw null;
                public void MoveTo(Microsoft.AspNetCore.Html.IHtmlContentBuilder destination) => throw null;
                public void WriteTo(System.IO.TextWriter writer, System.Text.Encodings.Web.HtmlEncoder encoder) => throw null;
            }
            public static partial class HtmlContentBuilderExtensions
            {
                public static Microsoft.AspNetCore.Html.IHtmlContentBuilder AppendFormat(this Microsoft.AspNetCore.Html.IHtmlContentBuilder builder, string format, params object[] args) => throw null;
                public static Microsoft.AspNetCore.Html.IHtmlContentBuilder AppendFormat(this Microsoft.AspNetCore.Html.IHtmlContentBuilder builder, System.IFormatProvider formatProvider, string format, params object[] args) => throw null;
                public static Microsoft.AspNetCore.Html.IHtmlContentBuilder AppendHtmlLine(this Microsoft.AspNetCore.Html.IHtmlContentBuilder builder, string encoded) => throw null;
                public static Microsoft.AspNetCore.Html.IHtmlContentBuilder AppendLine(this Microsoft.AspNetCore.Html.IHtmlContentBuilder builder) => throw null;
                public static Microsoft.AspNetCore.Html.IHtmlContentBuilder AppendLine(this Microsoft.AspNetCore.Html.IHtmlContentBuilder builder, string unencoded) => throw null;
                public static Microsoft.AspNetCore.Html.IHtmlContentBuilder AppendLine(this Microsoft.AspNetCore.Html.IHtmlContentBuilder builder, Microsoft.AspNetCore.Html.IHtmlContent content) => throw null;
                public static Microsoft.AspNetCore.Html.IHtmlContentBuilder SetContent(this Microsoft.AspNetCore.Html.IHtmlContentBuilder builder, string unencoded) => throw null;
                public static Microsoft.AspNetCore.Html.IHtmlContentBuilder SetHtmlContent(this Microsoft.AspNetCore.Html.IHtmlContentBuilder builder, Microsoft.AspNetCore.Html.IHtmlContent content) => throw null;
                public static Microsoft.AspNetCore.Html.IHtmlContentBuilder SetHtmlContent(this Microsoft.AspNetCore.Html.IHtmlContentBuilder builder, string encoded) => throw null;
            }
            public class HtmlFormattableString : Microsoft.AspNetCore.Html.IHtmlContent
            {
                public HtmlFormattableString(string format, params object[] args) => throw null;
                public HtmlFormattableString(System.IFormatProvider formatProvider, string format, params object[] args) => throw null;
                public void WriteTo(System.IO.TextWriter writer, System.Text.Encodings.Web.HtmlEncoder encoder) => throw null;
            }
            public class HtmlString : Microsoft.AspNetCore.Html.IHtmlContent
            {
                public HtmlString(string value) => throw null;
                public static readonly Microsoft.AspNetCore.Html.HtmlString Empty;
                public static readonly Microsoft.AspNetCore.Html.HtmlString NewLine;
                public override string ToString() => throw null;
                public string Value { get => throw null; }
                public void WriteTo(System.IO.TextWriter writer, System.Text.Encodings.Web.HtmlEncoder encoder) => throw null;
            }
            public interface IHtmlAsyncContent : Microsoft.AspNetCore.Html.IHtmlContent
            {
                System.Threading.Tasks.ValueTask WriteToAsync(System.IO.TextWriter writer);
            }
            public interface IHtmlContent
            {
                void WriteTo(System.IO.TextWriter writer, System.Text.Encodings.Web.HtmlEncoder encoder);
            }
            public interface IHtmlContentBuilder : Microsoft.AspNetCore.Html.IHtmlContent, Microsoft.AspNetCore.Html.IHtmlContentContainer
            {
                Microsoft.AspNetCore.Html.IHtmlContentBuilder Append(string unencoded);
                Microsoft.AspNetCore.Html.IHtmlContentBuilder AppendHtml(Microsoft.AspNetCore.Html.IHtmlContent content);
                Microsoft.AspNetCore.Html.IHtmlContentBuilder AppendHtml(string encoded);
                Microsoft.AspNetCore.Html.IHtmlContentBuilder Clear();
            }
            public interface IHtmlContentContainer : Microsoft.AspNetCore.Html.IHtmlContent
            {
                void CopyTo(Microsoft.AspNetCore.Html.IHtmlContentBuilder builder);
                void MoveTo(Microsoft.AspNetCore.Html.IHtmlContentBuilder builder);
            }
        }
    }
}
