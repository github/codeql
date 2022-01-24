// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace Localization
        {
            // Generated from `Microsoft.Extensions.Localization.IStringLocalizer` in `Microsoft.Extensions.Localization.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IStringLocalizer
            {
                System.Collections.Generic.IEnumerable<Microsoft.Extensions.Localization.LocalizedString> GetAllStrings(bool includeParentCultures);
                Microsoft.Extensions.Localization.LocalizedString this[string name] { get; }
                Microsoft.Extensions.Localization.LocalizedString this[string name, params object[] arguments] { get; }
            }

            // Generated from `Microsoft.Extensions.Localization.IStringLocalizer<>` in `Microsoft.Extensions.Localization.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IStringLocalizer<T> : Microsoft.Extensions.Localization.IStringLocalizer
            {
            }

            // Generated from `Microsoft.Extensions.Localization.IStringLocalizerFactory` in `Microsoft.Extensions.Localization.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IStringLocalizerFactory
            {
                Microsoft.Extensions.Localization.IStringLocalizer Create(string baseName, string location);
                Microsoft.Extensions.Localization.IStringLocalizer Create(System.Type resourceSource);
            }

            // Generated from `Microsoft.Extensions.Localization.LocalizedString` in `Microsoft.Extensions.Localization.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class LocalizedString
            {
                public LocalizedString(string name, string value, bool resourceNotFound, string searchedLocation) => throw null;
                public LocalizedString(string name, string value, bool resourceNotFound) => throw null;
                public LocalizedString(string name, string value) => throw null;
                public string Name { get => throw null; }
                public bool ResourceNotFound { get => throw null; }
                public string SearchedLocation { get => throw null; }
                public override string ToString() => throw null;
                public string Value { get => throw null; }
                public static implicit operator string(Microsoft.Extensions.Localization.LocalizedString localizedString) => throw null;
            }

            // Generated from `Microsoft.Extensions.Localization.StringLocalizer<>` in `Microsoft.Extensions.Localization.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class StringLocalizer<TResourceSource> : Microsoft.Extensions.Localization.IStringLocalizer<TResourceSource>, Microsoft.Extensions.Localization.IStringLocalizer
            {
                public System.Collections.Generic.IEnumerable<Microsoft.Extensions.Localization.LocalizedString> GetAllStrings(bool includeParentCultures) => throw null;
                public virtual Microsoft.Extensions.Localization.LocalizedString this[string name] { get => throw null; }
                public virtual Microsoft.Extensions.Localization.LocalizedString this[string name, params object[] arguments] { get => throw null; }
                public StringLocalizer(Microsoft.Extensions.Localization.IStringLocalizerFactory factory) => throw null;
            }

            // Generated from `Microsoft.Extensions.Localization.StringLocalizerExtensions` in `Microsoft.Extensions.Localization.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class StringLocalizerExtensions
            {
                public static System.Collections.Generic.IEnumerable<Microsoft.Extensions.Localization.LocalizedString> GetAllStrings(this Microsoft.Extensions.Localization.IStringLocalizer stringLocalizer) => throw null;
                public static Microsoft.Extensions.Localization.LocalizedString GetString(this Microsoft.Extensions.Localization.IStringLocalizer stringLocalizer, string name, params object[] arguments) => throw null;
                public static Microsoft.Extensions.Localization.LocalizedString GetString(this Microsoft.Extensions.Localization.IStringLocalizer stringLocalizer, string name) => throw null;
            }

        }
    }
}
