// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.EncoderServiceCollectionExtensions` in `Microsoft.Extensions.WebEncoders, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class EncoderServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddWebEncoders(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.Extensions.WebEncoders.WebEncoderOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddWebEncoders(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
            }

        }
        namespace WebEncoders
        {
            // Generated from `Microsoft.Extensions.WebEncoders.WebEncoderOptions` in `Microsoft.Extensions.WebEncoders, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class WebEncoderOptions
            {
                public System.Text.Encodings.Web.TextEncoderSettings TextEncoderSettings { get => throw null; set => throw null; }
                public WebEncoderOptions() => throw null;
            }

            namespace Testing
            {
                // Generated from `Microsoft.Extensions.WebEncoders.Testing.HtmlTestEncoder` in `Microsoft.Extensions.WebEncoders, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class HtmlTestEncoder : System.Text.Encodings.Web.HtmlEncoder
                {
                    public override void Encode(System.IO.TextWriter output, string value, int startIndex, int characterCount) => throw null;
                    public override void Encode(System.IO.TextWriter output, System.Char[] value, int startIndex, int characterCount) => throw null;
                    public override string Encode(string value) => throw null;
                    unsafe public override int FindFirstCharacterToEncode(System.Char* text, int textLength) => throw null;
                    public HtmlTestEncoder() => throw null;
                    public override int MaxOutputCharactersPerInputCharacter { get => throw null; }
                    unsafe public override bool TryEncodeUnicodeScalar(int unicodeScalar, System.Char* buffer, int bufferLength, out int numberOfCharactersWritten) => throw null;
                    public override bool WillEncode(int unicodeScalar) => throw null;
                }

                // Generated from `Microsoft.Extensions.WebEncoders.Testing.JavaScriptTestEncoder` in `Microsoft.Extensions.WebEncoders, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class JavaScriptTestEncoder : System.Text.Encodings.Web.JavaScriptEncoder
                {
                    public override void Encode(System.IO.TextWriter output, string value, int startIndex, int characterCount) => throw null;
                    public override void Encode(System.IO.TextWriter output, System.Char[] value, int startIndex, int characterCount) => throw null;
                    public override string Encode(string value) => throw null;
                    unsafe public override int FindFirstCharacterToEncode(System.Char* text, int textLength) => throw null;
                    public JavaScriptTestEncoder() => throw null;
                    public override int MaxOutputCharactersPerInputCharacter { get => throw null; }
                    unsafe public override bool TryEncodeUnicodeScalar(int unicodeScalar, System.Char* buffer, int bufferLength, out int numberOfCharactersWritten) => throw null;
                    public override bool WillEncode(int unicodeScalar) => throw null;
                }

                // Generated from `Microsoft.Extensions.WebEncoders.Testing.UrlTestEncoder` in `Microsoft.Extensions.WebEncoders, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class UrlTestEncoder : System.Text.Encodings.Web.UrlEncoder
                {
                    public override void Encode(System.IO.TextWriter output, string value, int startIndex, int characterCount) => throw null;
                    public override void Encode(System.IO.TextWriter output, System.Char[] value, int startIndex, int characterCount) => throw null;
                    public override string Encode(string value) => throw null;
                    unsafe public override int FindFirstCharacterToEncode(System.Char* text, int textLength) => throw null;
                    public override int MaxOutputCharactersPerInputCharacter { get => throw null; }
                    unsafe public override bool TryEncodeUnicodeScalar(int unicodeScalar, System.Char* buffer, int bufferLength, out int numberOfCharactersWritten) => throw null;
                    public UrlTestEncoder() => throw null;
                    public override bool WillEncode(int unicodeScalar) => throw null;
                }

            }
        }
    }
}
