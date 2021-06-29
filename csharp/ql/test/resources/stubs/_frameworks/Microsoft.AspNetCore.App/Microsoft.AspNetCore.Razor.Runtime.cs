// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Razor
        {
            namespace Hosting
            {
                // Generated from `Microsoft.AspNetCore.Razor.Hosting.IRazorSourceChecksumMetadata` in `Microsoft.AspNetCore.Razor.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IRazorSourceChecksumMetadata
                {
                    string Checksum { get; }
                    string ChecksumAlgorithm { get; }
                    string Identifier { get; }
                }

                // Generated from `Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItem` in `Microsoft.AspNetCore.Razor.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class RazorCompiledItem
                {
                    public abstract string Identifier { get; }
                    public abstract string Kind { get; }
                    public abstract System.Collections.Generic.IReadOnlyList<object> Metadata { get; }
                    protected RazorCompiledItem() => throw null;
                    public abstract System.Type Type { get; }
                }

                // Generated from `Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItemAttribute` in `Microsoft.AspNetCore.Razor.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RazorCompiledItemAttribute : System.Attribute
                {
                    public string Identifier { get => throw null; }
                    public string Kind { get => throw null; }
                    public RazorCompiledItemAttribute(System.Type type, string kind, string identifier) => throw null;
                    public System.Type Type { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItemExtensions` in `Microsoft.AspNetCore.Razor.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class RazorCompiledItemExtensions
                {
                    public static System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Razor.Hosting.IRazorSourceChecksumMetadata> GetChecksumMetadata(this Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItem item) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItemLoader` in `Microsoft.AspNetCore.Razor.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RazorCompiledItemLoader
                {
                    protected virtual Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItem CreateItem(Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItemAttribute attribute) => throw null;
                    protected System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItemAttribute> LoadAttributes(System.Reflection.Assembly assembly) => throw null;
                    public virtual System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItem> LoadItems(System.Reflection.Assembly assembly) => throw null;
                    public RazorCompiledItemLoader() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItemMetadataAttribute` in `Microsoft.AspNetCore.Razor.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RazorCompiledItemMetadataAttribute : System.Attribute
                {
                    public string Key { get => throw null; }
                    public RazorCompiledItemMetadataAttribute(string key, string value) => throw null;
                    public string Value { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Razor.Hosting.RazorConfigurationNameAttribute` in `Microsoft.AspNetCore.Razor.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RazorConfigurationNameAttribute : System.Attribute
                {
                    public string ConfigurationName { get => throw null; }
                    public RazorConfigurationNameAttribute(string configurationName) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Razor.Hosting.RazorExtensionAssemblyNameAttribute` in `Microsoft.AspNetCore.Razor.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RazorExtensionAssemblyNameAttribute : System.Attribute
                {
                    public string AssemblyName { get => throw null; }
                    public string ExtensionName { get => throw null; }
                    public RazorExtensionAssemblyNameAttribute(string extensionName, string assemblyName) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Razor.Hosting.RazorLanguageVersionAttribute` in `Microsoft.AspNetCore.Razor.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RazorLanguageVersionAttribute : System.Attribute
                {
                    public string LanguageVersion { get => throw null; }
                    public RazorLanguageVersionAttribute(string languageVersion) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute` in `Microsoft.AspNetCore.Razor.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RazorSourceChecksumAttribute : System.Attribute, Microsoft.AspNetCore.Razor.Hosting.IRazorSourceChecksumMetadata
                {
                    public string Checksum { get => throw null; }
                    public string ChecksumAlgorithm { get => throw null; }
                    public string Identifier { get => throw null; }
                    public RazorSourceChecksumAttribute(string checksumAlgorithm, string checksum, string identifier) => throw null;
                }

            }
            namespace Runtime
            {
                namespace TagHelpers
                {
                    // Generated from `Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperExecutionContext` in `Microsoft.AspNetCore.Razor.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class TagHelperExecutionContext
                    {
                        public void Add(Microsoft.AspNetCore.Razor.TagHelpers.ITagHelper tagHelper) => throw null;
                        public void AddHtmlAttribute(string name, object value, Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle valueStyle) => throw null;
                        public void AddHtmlAttribute(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute attribute) => throw null;
                        public void AddTagHelperAttribute(string name, object value, Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle valueStyle) => throw null;
                        public void AddTagHelperAttribute(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute attribute) => throw null;
                        public bool ChildContentRetrieved { get => throw null; }
                        public Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext Context { get => throw null; }
                        public System.Collections.Generic.IDictionary<object, object> Items { get => throw null; }
                        public Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput Output { get => throw null; set => throw null; }
                        public void Reinitialize(string tagName, Microsoft.AspNetCore.Razor.TagHelpers.TagMode tagMode, System.Collections.Generic.IDictionary<object, object> items, string uniqueId, System.Func<System.Threading.Tasks.Task> executeChildContentAsync) => throw null;
                        public System.Threading.Tasks.Task SetOutputContentAsync() => throw null;
                        public TagHelperExecutionContext(string tagName, Microsoft.AspNetCore.Razor.TagHelpers.TagMode tagMode, System.Collections.Generic.IDictionary<object, object> items, string uniqueId, System.Func<System.Threading.Tasks.Task> executeChildContentAsync, System.Action<System.Text.Encodings.Web.HtmlEncoder> startTagHelperWritingScope, System.Func<Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContent> endTagHelperWritingScope) => throw null;
                        public System.Collections.Generic.IList<Microsoft.AspNetCore.Razor.TagHelpers.ITagHelper> TagHelpers { get => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperRunner` in `Microsoft.AspNetCore.Razor.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class TagHelperRunner
                    {
                        public System.Threading.Tasks.Task RunAsync(Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperExecutionContext executionContext) => throw null;
                        public TagHelperRunner() => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperScopeManager` in `Microsoft.AspNetCore.Razor.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class TagHelperScopeManager
                    {
                        public Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperExecutionContext Begin(string tagName, Microsoft.AspNetCore.Razor.TagHelpers.TagMode tagMode, string uniqueId, System.Func<System.Threading.Tasks.Task> executeChildContentAsync) => throw null;
                        public Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperExecutionContext End() => throw null;
                        public TagHelperScopeManager(System.Action<System.Text.Encodings.Web.HtmlEncoder> startTagHelperWritingScope, System.Func<Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContent> endTagHelperWritingScope) => throw null;
                    }

                }
            }
        }
    }
}
