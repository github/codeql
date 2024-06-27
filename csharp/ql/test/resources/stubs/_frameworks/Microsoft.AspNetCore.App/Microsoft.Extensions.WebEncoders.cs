// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.WebEncoders, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class EncoderServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddWebEncoders(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddWebEncoders(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.Extensions.WebEncoders.WebEncoderOptions> setupAction) => throw null;
            }
        }
        namespace WebEncoders
        {
            namespace Testing
            {
                public sealed class HtmlTestEncoder : System.Text.Encodings.Web.HtmlEncoder
                {
                    public HtmlTestEncoder() => throw null;
                    public override string Encode(string value) => throw null;
                    public override void Encode(System.IO.TextWriter output, char[] value, int startIndex, int characterCount) => throw null;
                    public override void Encode(System.IO.TextWriter output, string value, int startIndex, int characterCount) => throw null;
                    public override unsafe int FindFirstCharacterToEncode(char* text, int textLength) => throw null;
                    public override int MaxOutputCharactersPerInputCharacter { get => throw null; }
                    public override unsafe bool TryEncodeUnicodeScalar(int unicodeScalar, char* buffer, int bufferLength, out int numberOfCharactersWritten) => throw null;
                    public override bool WillEncode(int unicodeScalar) => throw null;
                }
                public class JavaScriptTestEncoder : System.Text.Encodings.Web.JavaScriptEncoder
                {
                    public JavaScriptTestEncoder() => throw null;
                    public override string Encode(string value) => throw null;
                    public override void Encode(System.IO.TextWriter output, char[] value, int startIndex, int characterCount) => throw null;
                    public override void Encode(System.IO.TextWriter output, string value, int startIndex, int characterCount) => throw null;
                    public override unsafe int FindFirstCharacterToEncode(char* text, int textLength) => throw null;
                    public override int MaxOutputCharactersPerInputCharacter { get => throw null; }
                    public override unsafe bool TryEncodeUnicodeScalar(int unicodeScalar, char* buffer, int bufferLength, out int numberOfCharactersWritten) => throw null;
                    public override bool WillEncode(int unicodeScalar) => throw null;
                }
                public class UrlTestEncoder : System.Text.Encodings.Web.UrlEncoder
                {
                    public UrlTestEncoder() => throw null;
                    public override string Encode(string value) => throw null;
                    public override void Encode(System.IO.TextWriter output, char[] value, int startIndex, int characterCount) => throw null;
                    public override void Encode(System.IO.TextWriter output, string value, int startIndex, int characterCount) => throw null;
                    public override unsafe int FindFirstCharacterToEncode(char* text, int textLength) => throw null;
                    public override int MaxOutputCharactersPerInputCharacter { get => throw null; }
                    public override unsafe bool TryEncodeUnicodeScalar(int unicodeScalar, char* buffer, int bufferLength, out int numberOfCharactersWritten) => throw null;
                    public override bool WillEncode(int unicodeScalar) => throw null;
                }
            }
            public sealed class WebEncoderOptions
            {
                public WebEncoderOptions() => throw null;
                public System.Text.Encodings.Web.TextEncoderSettings TextEncoderSettings { get => throw null; set { } }
            }
        }
    }
}
