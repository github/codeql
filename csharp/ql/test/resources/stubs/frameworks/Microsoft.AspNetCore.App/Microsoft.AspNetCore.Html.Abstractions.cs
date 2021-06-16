// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Html
        {
            // Generated from `Microsoft.AspNetCore.Html.HtmlContentBuilder` in `Microsoft.AspNetCore.Html.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HtmlContentBuilder : Microsoft.AspNetCore.Html.IHtmlContentContainer, Microsoft.AspNetCore.Html.IHtmlContentBuilder, Microsoft.AspNetCore.Html.IHtmlContent
            {
                public Microsoft.AspNetCore.Html.IHtmlContentBuilder Append(string unencoded) => throw null;
                public Microsoft.AspNetCore.Html.IHtmlContentBuilder AppendHtml(string encoded) => throw null;
                public Microsoft.AspNetCore.Html.IHtmlContentBuilder AppendHtml(Microsoft.AspNetCore.Html.IHtmlContent htmlContent) => throw null;
                public Microsoft.AspNetCore.Html.IHtmlContentBuilder Clear() => throw null;
                public void CopyTo(Microsoft.AspNetCore.Html.IHtmlContentBuilder destination) => throw null;
                public int Count { get => throw null; }
                public HtmlContentBuilder(int capacity) => throw null;
                public HtmlContentBuilder(System.Collections.Generic.IList<object> entries) => throw null;
                public HtmlContentBuilder() => throw null;
                public void MoveTo(Microsoft.AspNetCore.Html.IHtmlContentBuilder destination) => throw null;
                public void WriteTo(System.IO.TextWriter writer, System.Text.Encodings.Web.HtmlEncoder encoder) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Html.HtmlContentBuilderExtensions` in `Microsoft.AspNetCore.Html.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HtmlContentBuilderExtensions
            {
                public static Microsoft.AspNetCore.Html.IHtmlContentBuilder AppendFormat(this Microsoft.AspNetCore.Html.IHtmlContentBuilder builder, string format, params object[] args) => throw null;
                public static Microsoft.AspNetCore.Html.IHtmlContentBuilder AppendFormat(this Microsoft.AspNetCore.Html.IHtmlContentBuilder builder, System.IFormatProvider formatProvider, string format, params object[] args) => throw null;
                public static Microsoft.AspNetCore.Html.IHtmlContentBuilder AppendHtmlLine(this Microsoft.AspNetCore.Html.IHtmlContentBuilder builder, string encoded) => throw null;
                public static Microsoft.AspNetCore.Html.IHtmlContentBuilder AppendLine(this Microsoft.AspNetCore.Html.IHtmlContentBuilder builder, string unencoded) => throw null;
                public static Microsoft.AspNetCore.Html.IHtmlContentBuilder AppendLine(this Microsoft.AspNetCore.Html.IHtmlContentBuilder builder, Microsoft.AspNetCore.Html.IHtmlContent content) => throw null;
                public static Microsoft.AspNetCore.Html.IHtmlContentBuilder AppendLine(this Microsoft.AspNetCore.Html.IHtmlContentBuilder builder) => throw null;
                public static Microsoft.AspNetCore.Html.IHtmlContentBuilder SetContent(this Microsoft.AspNetCore.Html.IHtmlContentBuilder builder, string unencoded) => throw null;
                public static Microsoft.AspNetCore.Html.IHtmlContentBuilder SetHtmlContent(this Microsoft.AspNetCore.Html.IHtmlContentBuilder builder, string encoded) => throw null;
                public static Microsoft.AspNetCore.Html.IHtmlContentBuilder SetHtmlContent(this Microsoft.AspNetCore.Html.IHtmlContentBuilder builder, Microsoft.AspNetCore.Html.IHtmlContent content) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Html.HtmlFormattableString` in `Microsoft.AspNetCore.Html.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HtmlFormattableString : Microsoft.AspNetCore.Html.IHtmlContent
            {
                public HtmlFormattableString(string format, params object[] args) => throw null;
                public HtmlFormattableString(System.IFormatProvider formatProvider, string format, params object[] args) => throw null;
                public void WriteTo(System.IO.TextWriter writer, System.Text.Encodings.Web.HtmlEncoder encoder) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Html.HtmlString` in `Microsoft.AspNetCore.Html.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HtmlString : Microsoft.AspNetCore.Html.IHtmlContent
            {
                public static Microsoft.AspNetCore.Html.HtmlString Empty;
                public HtmlString(string value) => throw null;
                public static Microsoft.AspNetCore.Html.HtmlString NewLine;
                public override string ToString() => throw null;
                public string Value { get => throw null; }
                public void WriteTo(System.IO.TextWriter writer, System.Text.Encodings.Web.HtmlEncoder encoder) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Html.IHtmlContent` in `Microsoft.AspNetCore.Html.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IHtmlContent
            {
                void WriteTo(System.IO.TextWriter writer, System.Text.Encodings.Web.HtmlEncoder encoder);
            }

            // Generated from `Microsoft.AspNetCore.Html.IHtmlContentBuilder` in `Microsoft.AspNetCore.Html.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IHtmlContentBuilder : Microsoft.AspNetCore.Html.IHtmlContentContainer, Microsoft.AspNetCore.Html.IHtmlContent
            {
                Microsoft.AspNetCore.Html.IHtmlContentBuilder Append(string unencoded);
                Microsoft.AspNetCore.Html.IHtmlContentBuilder AppendHtml(string encoded);
                Microsoft.AspNetCore.Html.IHtmlContentBuilder AppendHtml(Microsoft.AspNetCore.Html.IHtmlContent content);
                Microsoft.AspNetCore.Html.IHtmlContentBuilder Clear();
            }

            // Generated from `Microsoft.AspNetCore.Html.IHtmlContentContainer` in `Microsoft.AspNetCore.Html.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IHtmlContentContainer : Microsoft.AspNetCore.Html.IHtmlContent
            {
                void CopyTo(Microsoft.AspNetCore.Html.IHtmlContentBuilder builder);
                void MoveTo(Microsoft.AspNetCore.Html.IHtmlContentBuilder builder);
            }

        }
    }
}
