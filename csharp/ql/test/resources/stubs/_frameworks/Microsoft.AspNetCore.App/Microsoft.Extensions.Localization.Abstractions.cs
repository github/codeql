// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Localization.Abstractions, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.

namespace Microsoft
{
    namespace Extensions
    {
        namespace Localization
        {
            public interface IStringLocalizer
            {
                System.Collections.Generic.IEnumerable<Microsoft.Extensions.Localization.LocalizedString> GetAllStrings(bool includeParentCultures);
                Microsoft.Extensions.Localization.LocalizedString this[string name, params object[] arguments] { get; }
                Microsoft.Extensions.Localization.LocalizedString this[string name] { get; }
            }

            public interface IStringLocalizer<T> : Microsoft.Extensions.Localization.IStringLocalizer
            {
            }

            public interface IStringLocalizerFactory
            {
                Microsoft.Extensions.Localization.IStringLocalizer Create(System.Type resourceSource);
                Microsoft.Extensions.Localization.IStringLocalizer Create(string baseName, string location);
            }

            public class LocalizedString
            {
                public LocalizedString(string name, string value) => throw null;
                public LocalizedString(string name, string value, bool resourceNotFound) => throw null;
                public LocalizedString(string name, string value, bool resourceNotFound, string searchedLocation) => throw null;
                public string Name { get => throw null; }
                public bool ResourceNotFound { get => throw null; }
                public string SearchedLocation { get => throw null; }
                public override string ToString() => throw null;
                public string Value { get => throw null; }
                public static implicit operator string(Microsoft.Extensions.Localization.LocalizedString localizedString) => throw null;
            }

            public class StringLocalizer<TResourceSource> : Microsoft.Extensions.Localization.IStringLocalizer, Microsoft.Extensions.Localization.IStringLocalizer<TResourceSource>
            {
                public System.Collections.Generic.IEnumerable<Microsoft.Extensions.Localization.LocalizedString> GetAllStrings(bool includeParentCultures) => throw null;
                public virtual Microsoft.Extensions.Localization.LocalizedString this[string name, params object[] arguments] { get => throw null; }
                public virtual Microsoft.Extensions.Localization.LocalizedString this[string name] { get => throw null; }
                public StringLocalizer(Microsoft.Extensions.Localization.IStringLocalizerFactory factory) => throw null;
            }

            public static class StringLocalizerExtensions
            {
                public static System.Collections.Generic.IEnumerable<Microsoft.Extensions.Localization.LocalizedString> GetAllStrings(this Microsoft.Extensions.Localization.IStringLocalizer stringLocalizer) => throw null;
                public static Microsoft.Extensions.Localization.LocalizedString GetString(this Microsoft.Extensions.Localization.IStringLocalizer stringLocalizer, string name) => throw null;
                public static Microsoft.Extensions.Localization.LocalizedString GetString(this Microsoft.Extensions.Localization.IStringLocalizer stringLocalizer, string name, params object[] arguments) => throw null;
            }

        }
    }
}
