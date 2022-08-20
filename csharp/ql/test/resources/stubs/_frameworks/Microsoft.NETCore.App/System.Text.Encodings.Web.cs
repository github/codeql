// This file contains auto-generated code.

namespace System
{
    namespace Text
    {
        namespace Encodings
        {
            namespace Web
            {
                // Generated from `System.Text.Encodings.Web.HtmlEncoder` in `System.Text.Encodings.Web, Version=6.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public abstract class HtmlEncoder : System.Text.Encodings.Web.TextEncoder
                {
                    public static System.Text.Encodings.Web.HtmlEncoder Create(System.Text.Encodings.Web.TextEncoderSettings settings) => throw null;
                    public static System.Text.Encodings.Web.HtmlEncoder Create(params System.Text.Unicode.UnicodeRange[] allowedRanges) => throw null;
                    public static System.Text.Encodings.Web.HtmlEncoder Default { get => throw null; }
                    protected HtmlEncoder() => throw null;
                }

                // Generated from `System.Text.Encodings.Web.JavaScriptEncoder` in `System.Text.Encodings.Web, Version=6.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public abstract class JavaScriptEncoder : System.Text.Encodings.Web.TextEncoder
                {
                    public static System.Text.Encodings.Web.JavaScriptEncoder Create(System.Text.Encodings.Web.TextEncoderSettings settings) => throw null;
                    public static System.Text.Encodings.Web.JavaScriptEncoder Create(params System.Text.Unicode.UnicodeRange[] allowedRanges) => throw null;
                    public static System.Text.Encodings.Web.JavaScriptEncoder Default { get => throw null; }
                    protected JavaScriptEncoder() => throw null;
                    public static System.Text.Encodings.Web.JavaScriptEncoder UnsafeRelaxedJsonEscaping { get => throw null; }
                }

                // Generated from `System.Text.Encodings.Web.TextEncoder` in `System.Text.Encodings.Web, Version=6.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public abstract class TextEncoder
                {
                    public virtual System.Buffers.OperationStatus Encode(System.ReadOnlySpan<System.Char> source, System.Span<System.Char> destination, out int charsConsumed, out int charsWritten, bool isFinalBlock = default(bool)) => throw null;
                    public virtual void Encode(System.IO.TextWriter output, System.Char[] value, int startIndex, int characterCount) => throw null;
                    public void Encode(System.IO.TextWriter output, string value) => throw null;
                    public virtual void Encode(System.IO.TextWriter output, string value, int startIndex, int characterCount) => throw null;
                    public virtual string Encode(string value) => throw null;
                    public virtual System.Buffers.OperationStatus EncodeUtf8(System.ReadOnlySpan<System.Byte> utf8Source, System.Span<System.Byte> utf8Destination, out int bytesConsumed, out int bytesWritten, bool isFinalBlock = default(bool)) => throw null;
                    unsafe public abstract int FindFirstCharacterToEncode(System.Char* text, int textLength);
                    public virtual int FindFirstCharacterToEncodeUtf8(System.ReadOnlySpan<System.Byte> utf8Text) => throw null;
                    public abstract int MaxOutputCharactersPerInputCharacter { get; }
                    protected TextEncoder() => throw null;
                    unsafe public abstract bool TryEncodeUnicodeScalar(int unicodeScalar, System.Char* buffer, int bufferLength, out int numberOfCharactersWritten);
                    public abstract bool WillEncode(int unicodeScalar);
                }

                // Generated from `System.Text.Encodings.Web.TextEncoderSettings` in `System.Text.Encodings.Web, Version=6.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class TextEncoderSettings
                {
                    public virtual void AllowCharacter(System.Char character) => throw null;
                    public virtual void AllowCharacters(params System.Char[] characters) => throw null;
                    public virtual void AllowCodePoints(System.Collections.Generic.IEnumerable<int> codePoints) => throw null;
                    public virtual void AllowRange(System.Text.Unicode.UnicodeRange range) => throw null;
                    public virtual void AllowRanges(params System.Text.Unicode.UnicodeRange[] ranges) => throw null;
                    public virtual void Clear() => throw null;
                    public virtual void ForbidCharacter(System.Char character) => throw null;
                    public virtual void ForbidCharacters(params System.Char[] characters) => throw null;
                    public virtual void ForbidRange(System.Text.Unicode.UnicodeRange range) => throw null;
                    public virtual void ForbidRanges(params System.Text.Unicode.UnicodeRange[] ranges) => throw null;
                    public virtual System.Collections.Generic.IEnumerable<int> GetAllowedCodePoints() => throw null;
                    public TextEncoderSettings() => throw null;
                    public TextEncoderSettings(System.Text.Encodings.Web.TextEncoderSettings other) => throw null;
                    public TextEncoderSettings(params System.Text.Unicode.UnicodeRange[] allowedRanges) => throw null;
                }

                // Generated from `System.Text.Encodings.Web.UrlEncoder` in `System.Text.Encodings.Web, Version=6.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public abstract class UrlEncoder : System.Text.Encodings.Web.TextEncoder
                {
                    public static System.Text.Encodings.Web.UrlEncoder Create(System.Text.Encodings.Web.TextEncoderSettings settings) => throw null;
                    public static System.Text.Encodings.Web.UrlEncoder Create(params System.Text.Unicode.UnicodeRange[] allowedRanges) => throw null;
                    public static System.Text.Encodings.Web.UrlEncoder Default { get => throw null; }
                    protected UrlEncoder() => throw null;
                }

            }
        }
        namespace Unicode
        {
            // Generated from `System.Text.Unicode.UnicodeRange` in `System.Text.Encodings.Web, Version=6.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class UnicodeRange
            {
                public static System.Text.Unicode.UnicodeRange Create(System.Char firstCharacter, System.Char lastCharacter) => throw null;
                public int FirstCodePoint { get => throw null; }
                public int Length { get => throw null; }
                public UnicodeRange(int firstCodePoint, int length) => throw null;
            }

            // Generated from `System.Text.Unicode.UnicodeRanges` in `System.Text.Encodings.Web, Version=6.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public static class UnicodeRanges
            {
                public static System.Text.Unicode.UnicodeRange All { get => throw null; }
                public static System.Text.Unicode.UnicodeRange AlphabeticPresentationForms { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Arabic { get => throw null; }
                public static System.Text.Unicode.UnicodeRange ArabicExtendedA { get => throw null; }
                public static System.Text.Unicode.UnicodeRange ArabicPresentationFormsA { get => throw null; }
                public static System.Text.Unicode.UnicodeRange ArabicPresentationFormsB { get => throw null; }
                public static System.Text.Unicode.UnicodeRange ArabicSupplement { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Armenian { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Arrows { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Balinese { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Bamum { get => throw null; }
                public static System.Text.Unicode.UnicodeRange BasicLatin { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Batak { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Bengali { get => throw null; }
                public static System.Text.Unicode.UnicodeRange BlockElements { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Bopomofo { get => throw null; }
                public static System.Text.Unicode.UnicodeRange BopomofoExtended { get => throw null; }
                public static System.Text.Unicode.UnicodeRange BoxDrawing { get => throw null; }
                public static System.Text.Unicode.UnicodeRange BraillePatterns { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Buginese { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Buhid { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Cham { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Cherokee { get => throw null; }
                public static System.Text.Unicode.UnicodeRange CherokeeSupplement { get => throw null; }
                public static System.Text.Unicode.UnicodeRange CjkCompatibility { get => throw null; }
                public static System.Text.Unicode.UnicodeRange CjkCompatibilityForms { get => throw null; }
                public static System.Text.Unicode.UnicodeRange CjkCompatibilityIdeographs { get => throw null; }
                public static System.Text.Unicode.UnicodeRange CjkRadicalsSupplement { get => throw null; }
                public static System.Text.Unicode.UnicodeRange CjkStrokes { get => throw null; }
                public static System.Text.Unicode.UnicodeRange CjkSymbolsandPunctuation { get => throw null; }
                public static System.Text.Unicode.UnicodeRange CjkUnifiedIdeographs { get => throw null; }
                public static System.Text.Unicode.UnicodeRange CjkUnifiedIdeographsExtensionA { get => throw null; }
                public static System.Text.Unicode.UnicodeRange CombiningDiacriticalMarks { get => throw null; }
                public static System.Text.Unicode.UnicodeRange CombiningDiacriticalMarksExtended { get => throw null; }
                public static System.Text.Unicode.UnicodeRange CombiningDiacriticalMarksSupplement { get => throw null; }
                public static System.Text.Unicode.UnicodeRange CombiningDiacriticalMarksforSymbols { get => throw null; }
                public static System.Text.Unicode.UnicodeRange CombiningHalfMarks { get => throw null; }
                public static System.Text.Unicode.UnicodeRange CommonIndicNumberForms { get => throw null; }
                public static System.Text.Unicode.UnicodeRange ControlPictures { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Coptic { get => throw null; }
                public static System.Text.Unicode.UnicodeRange CurrencySymbols { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Cyrillic { get => throw null; }
                public static System.Text.Unicode.UnicodeRange CyrillicExtendedA { get => throw null; }
                public static System.Text.Unicode.UnicodeRange CyrillicExtendedB { get => throw null; }
                public static System.Text.Unicode.UnicodeRange CyrillicExtendedC { get => throw null; }
                public static System.Text.Unicode.UnicodeRange CyrillicSupplement { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Devanagari { get => throw null; }
                public static System.Text.Unicode.UnicodeRange DevanagariExtended { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Dingbats { get => throw null; }
                public static System.Text.Unicode.UnicodeRange EnclosedAlphanumerics { get => throw null; }
                public static System.Text.Unicode.UnicodeRange EnclosedCjkLettersandMonths { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Ethiopic { get => throw null; }
                public static System.Text.Unicode.UnicodeRange EthiopicExtended { get => throw null; }
                public static System.Text.Unicode.UnicodeRange EthiopicExtendedA { get => throw null; }
                public static System.Text.Unicode.UnicodeRange EthiopicSupplement { get => throw null; }
                public static System.Text.Unicode.UnicodeRange GeneralPunctuation { get => throw null; }
                public static System.Text.Unicode.UnicodeRange GeometricShapes { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Georgian { get => throw null; }
                public static System.Text.Unicode.UnicodeRange GeorgianExtended { get => throw null; }
                public static System.Text.Unicode.UnicodeRange GeorgianSupplement { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Glagolitic { get => throw null; }
                public static System.Text.Unicode.UnicodeRange GreekExtended { get => throw null; }
                public static System.Text.Unicode.UnicodeRange GreekandCoptic { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Gujarati { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Gurmukhi { get => throw null; }
                public static System.Text.Unicode.UnicodeRange HalfwidthandFullwidthForms { get => throw null; }
                public static System.Text.Unicode.UnicodeRange HangulCompatibilityJamo { get => throw null; }
                public static System.Text.Unicode.UnicodeRange HangulJamo { get => throw null; }
                public static System.Text.Unicode.UnicodeRange HangulJamoExtendedA { get => throw null; }
                public static System.Text.Unicode.UnicodeRange HangulJamoExtendedB { get => throw null; }
                public static System.Text.Unicode.UnicodeRange HangulSyllables { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Hanunoo { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Hebrew { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Hiragana { get => throw null; }
                public static System.Text.Unicode.UnicodeRange IdeographicDescriptionCharacters { get => throw null; }
                public static System.Text.Unicode.UnicodeRange IpaExtensions { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Javanese { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Kanbun { get => throw null; }
                public static System.Text.Unicode.UnicodeRange KangxiRadicals { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Kannada { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Katakana { get => throw null; }
                public static System.Text.Unicode.UnicodeRange KatakanaPhoneticExtensions { get => throw null; }
                public static System.Text.Unicode.UnicodeRange KayahLi { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Khmer { get => throw null; }
                public static System.Text.Unicode.UnicodeRange KhmerSymbols { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Lao { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Latin1Supplement { get => throw null; }
                public static System.Text.Unicode.UnicodeRange LatinExtendedA { get => throw null; }
                public static System.Text.Unicode.UnicodeRange LatinExtendedAdditional { get => throw null; }
                public static System.Text.Unicode.UnicodeRange LatinExtendedB { get => throw null; }
                public static System.Text.Unicode.UnicodeRange LatinExtendedC { get => throw null; }
                public static System.Text.Unicode.UnicodeRange LatinExtendedD { get => throw null; }
                public static System.Text.Unicode.UnicodeRange LatinExtendedE { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Lepcha { get => throw null; }
                public static System.Text.Unicode.UnicodeRange LetterlikeSymbols { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Limbu { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Lisu { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Malayalam { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Mandaic { get => throw null; }
                public static System.Text.Unicode.UnicodeRange MathematicalOperators { get => throw null; }
                public static System.Text.Unicode.UnicodeRange MeeteiMayek { get => throw null; }
                public static System.Text.Unicode.UnicodeRange MeeteiMayekExtensions { get => throw null; }
                public static System.Text.Unicode.UnicodeRange MiscellaneousMathematicalSymbolsA { get => throw null; }
                public static System.Text.Unicode.UnicodeRange MiscellaneousMathematicalSymbolsB { get => throw null; }
                public static System.Text.Unicode.UnicodeRange MiscellaneousSymbols { get => throw null; }
                public static System.Text.Unicode.UnicodeRange MiscellaneousSymbolsandArrows { get => throw null; }
                public static System.Text.Unicode.UnicodeRange MiscellaneousTechnical { get => throw null; }
                public static System.Text.Unicode.UnicodeRange ModifierToneLetters { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Mongolian { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Myanmar { get => throw null; }
                public static System.Text.Unicode.UnicodeRange MyanmarExtendedA { get => throw null; }
                public static System.Text.Unicode.UnicodeRange MyanmarExtendedB { get => throw null; }
                public static System.Text.Unicode.UnicodeRange NKo { get => throw null; }
                public static System.Text.Unicode.UnicodeRange NewTaiLue { get => throw null; }
                public static System.Text.Unicode.UnicodeRange None { get => throw null; }
                public static System.Text.Unicode.UnicodeRange NumberForms { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Ogham { get => throw null; }
                public static System.Text.Unicode.UnicodeRange OlChiki { get => throw null; }
                public static System.Text.Unicode.UnicodeRange OpticalCharacterRecognition { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Oriya { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Phagspa { get => throw null; }
                public static System.Text.Unicode.UnicodeRange PhoneticExtensions { get => throw null; }
                public static System.Text.Unicode.UnicodeRange PhoneticExtensionsSupplement { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Rejang { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Runic { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Samaritan { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Saurashtra { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Sinhala { get => throw null; }
                public static System.Text.Unicode.UnicodeRange SmallFormVariants { get => throw null; }
                public static System.Text.Unicode.UnicodeRange SpacingModifierLetters { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Specials { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Sundanese { get => throw null; }
                public static System.Text.Unicode.UnicodeRange SundaneseSupplement { get => throw null; }
                public static System.Text.Unicode.UnicodeRange SuperscriptsandSubscripts { get => throw null; }
                public static System.Text.Unicode.UnicodeRange SupplementalArrowsA { get => throw null; }
                public static System.Text.Unicode.UnicodeRange SupplementalArrowsB { get => throw null; }
                public static System.Text.Unicode.UnicodeRange SupplementalMathematicalOperators { get => throw null; }
                public static System.Text.Unicode.UnicodeRange SupplementalPunctuation { get => throw null; }
                public static System.Text.Unicode.UnicodeRange SylotiNagri { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Syriac { get => throw null; }
                public static System.Text.Unicode.UnicodeRange SyriacSupplement { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Tagalog { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Tagbanwa { get => throw null; }
                public static System.Text.Unicode.UnicodeRange TaiLe { get => throw null; }
                public static System.Text.Unicode.UnicodeRange TaiTham { get => throw null; }
                public static System.Text.Unicode.UnicodeRange TaiViet { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Tamil { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Telugu { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Thaana { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Thai { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Tibetan { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Tifinagh { get => throw null; }
                public static System.Text.Unicode.UnicodeRange UnifiedCanadianAboriginalSyllabics { get => throw null; }
                public static System.Text.Unicode.UnicodeRange UnifiedCanadianAboriginalSyllabicsExtended { get => throw null; }
                public static System.Text.Unicode.UnicodeRange Vai { get => throw null; }
                public static System.Text.Unicode.UnicodeRange VariationSelectors { get => throw null; }
                public static System.Text.Unicode.UnicodeRange VedicExtensions { get => throw null; }
                public static System.Text.Unicode.UnicodeRange VerticalForms { get => throw null; }
                public static System.Text.Unicode.UnicodeRange YiRadicals { get => throw null; }
                public static System.Text.Unicode.UnicodeRange YiSyllables { get => throw null; }
                public static System.Text.Unicode.UnicodeRange YijingHexagramSymbols { get => throw null; }
            }

        }
    }
}
