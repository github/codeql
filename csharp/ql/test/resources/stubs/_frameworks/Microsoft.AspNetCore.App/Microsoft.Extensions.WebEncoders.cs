// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.WebEncoders, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.

namespace Microsoft
{
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static class EncoderServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddWebEncoders(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddWebEncoders(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.Extensions.WebEncoders.WebEncoderOptions> setupAction) => throw null;
            }

        }
        namespace WebEncoders
        {
            public class WebEncoderOptions
            {
                public System.Text.Encodings.Web.TextEncoderSettings TextEncoderSettings { get => throw null; set => throw null; }
                public WebEncoderOptions() => throw null;
            }

            namespace Testing
            {
                public class HtmlTestEncoder : System.Text.Encodings.Web.HtmlEncoder
                {
                    public override void Encode(System.IO.TextWriter output, System.Char[] value, int startIndex, int characterCount) => throw null;
                    public override void Encode(System.IO.TextWriter output, string value, int startIndex, int characterCount) => throw null;
                    public override string Encode(string value) => throw null;
                    unsafe public override int FindFirstCharacterToEncode(System.Char* text, int textLength) => throw null;
                    public HtmlTestEncoder() => throw null;
                    public override int MaxOutputCharactersPerInputCharacter { get => throw null; }
                    unsafe public override bool TryEncodeUnicodeScalar(int unicodeScalar, System.Char* buffer, int bufferLength, out int numberOfCharactersWritten) => throw null;
                    public override bool WillEncode(int unicodeScalar) => throw null;
                }

                public class JavaScriptTestEncoder : System.Text.Encodings.Web.JavaScriptEncoder
                {
                    public override void Encode(System.IO.TextWriter output, System.Char[] value, int startIndex, int characterCount) => throw null;
                    public override void Encode(System.IO.TextWriter output, string value, int startIndex, int characterCount) => throw null;
                    public override string Encode(string value) => throw null;
                    unsafe public override int FindFirstCharacterToEncode(System.Char* text, int textLength) => throw null;
                    public JavaScriptTestEncoder() => throw null;
                    public override int MaxOutputCharactersPerInputCharacter { get => throw null; }
                    unsafe public override bool TryEncodeUnicodeScalar(int unicodeScalar, System.Char* buffer, int bufferLength, out int numberOfCharactersWritten) => throw null;
                    public override bool WillEncode(int unicodeScalar) => throw null;
                }

                public class UrlTestEncoder : System.Text.Encodings.Web.UrlEncoder
                {
                    public override void Encode(System.IO.TextWriter output, System.Char[] value, int startIndex, int characterCount) => throw null;
                    public override void Encode(System.IO.TextWriter output, string value, int startIndex, int characterCount) => throw null;
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
