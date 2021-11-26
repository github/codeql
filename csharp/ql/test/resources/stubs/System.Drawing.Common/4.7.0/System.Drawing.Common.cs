// This file contains auto-generated code.

namespace System
{
    namespace Drawing
    {
        // Generated from `System.Drawing.Bitmap` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class Bitmap : System.Drawing.Image
        {
            public Bitmap(string filename, bool useIcm) => throw null;
            public Bitmap(string filename) => throw null;
            public Bitmap(int width, int height, int stride, System.Drawing.Imaging.PixelFormat format, System.IntPtr scan0) => throw null;
            public Bitmap(int width, int height, System.Drawing.Imaging.PixelFormat format) => throw null;
            public Bitmap(int width, int height, System.Drawing.Graphics g) => throw null;
            public Bitmap(int width, int height) => throw null;
            public Bitmap(System.Type type, string resource) => throw null;
            public Bitmap(System.IO.Stream stream, bool useIcm) => throw null;
            public Bitmap(System.IO.Stream stream) => throw null;
            public Bitmap(System.Drawing.Image original, int width, int height) => throw null;
            public Bitmap(System.Drawing.Image original, System.Drawing.Size newSize) => throw null;
            public Bitmap(System.Drawing.Image original) => throw null;
            public System.Drawing.Bitmap Clone(System.Drawing.RectangleF rect, System.Drawing.Imaging.PixelFormat format) => throw null;
            public System.Drawing.Bitmap Clone(System.Drawing.Rectangle rect, System.Drawing.Imaging.PixelFormat format) => throw null;
            public static System.Drawing.Bitmap FromHicon(System.IntPtr hicon) => throw null;
            public static System.Drawing.Bitmap FromResource(System.IntPtr hinstance, string bitmapName) => throw null;
            public System.IntPtr GetHbitmap(System.Drawing.Color background) => throw null;
            public System.IntPtr GetHbitmap() => throw null;
            public System.IntPtr GetHicon() => throw null;
            public System.Drawing.Color GetPixel(int x, int y) => throw null;
            public System.Drawing.Imaging.BitmapData LockBits(System.Drawing.Rectangle rect, System.Drawing.Imaging.ImageLockMode flags, System.Drawing.Imaging.PixelFormat format, System.Drawing.Imaging.BitmapData bitmapData) => throw null;
            public System.Drawing.Imaging.BitmapData LockBits(System.Drawing.Rectangle rect, System.Drawing.Imaging.ImageLockMode flags, System.Drawing.Imaging.PixelFormat format) => throw null;
            public void MakeTransparent(System.Drawing.Color transparentColor) => throw null;
            public void MakeTransparent() => throw null;
            public void SetPixel(int x, int y, System.Drawing.Color color) => throw null;
            public void SetResolution(float xDpi, float yDpi) => throw null;
            public void UnlockBits(System.Drawing.Imaging.BitmapData bitmapdata) => throw null;
        }

        // Generated from `System.Drawing.BitmapSuffixInSameAssemblyAttribute` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class BitmapSuffixInSameAssemblyAttribute : System.Attribute
        {
            public BitmapSuffixInSameAssemblyAttribute() => throw null;
        }

        // Generated from `System.Drawing.BitmapSuffixInSatelliteAssemblyAttribute` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class BitmapSuffixInSatelliteAssemblyAttribute : System.Attribute
        {
            public BitmapSuffixInSatelliteAssemblyAttribute() => throw null;
        }

        // Generated from `System.Drawing.Brush` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public abstract class Brush : System.MarshalByRefObject, System.IDisposable, System.ICloneable
        {
            protected Brush() => throw null;
            public abstract object Clone();
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            protected internal void SetNativeBrush(System.IntPtr brush) => throw null;
            // ERR: Stub generator didn't handle member: ~Brush
        }

        // Generated from `System.Drawing.Brushes` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public static class Brushes
        {
            public static System.Drawing.Brush AliceBlue { get => throw null; }
            public static System.Drawing.Brush AntiqueWhite { get => throw null; }
            public static System.Drawing.Brush Aqua { get => throw null; }
            public static System.Drawing.Brush Aquamarine { get => throw null; }
            public static System.Drawing.Brush Azure { get => throw null; }
            public static System.Drawing.Brush Beige { get => throw null; }
            public static System.Drawing.Brush Bisque { get => throw null; }
            public static System.Drawing.Brush Black { get => throw null; }
            public static System.Drawing.Brush BlanchedAlmond { get => throw null; }
            public static System.Drawing.Brush Blue { get => throw null; }
            public static System.Drawing.Brush BlueViolet { get => throw null; }
            public static System.Drawing.Brush Brown { get => throw null; }
            public static System.Drawing.Brush BurlyWood { get => throw null; }
            public static System.Drawing.Brush CadetBlue { get => throw null; }
            public static System.Drawing.Brush Chartreuse { get => throw null; }
            public static System.Drawing.Brush Chocolate { get => throw null; }
            public static System.Drawing.Brush Coral { get => throw null; }
            public static System.Drawing.Brush CornflowerBlue { get => throw null; }
            public static System.Drawing.Brush Cornsilk { get => throw null; }
            public static System.Drawing.Brush Crimson { get => throw null; }
            public static System.Drawing.Brush Cyan { get => throw null; }
            public static System.Drawing.Brush DarkBlue { get => throw null; }
            public static System.Drawing.Brush DarkCyan { get => throw null; }
            public static System.Drawing.Brush DarkGoldenrod { get => throw null; }
            public static System.Drawing.Brush DarkGray { get => throw null; }
            public static System.Drawing.Brush DarkGreen { get => throw null; }
            public static System.Drawing.Brush DarkKhaki { get => throw null; }
            public static System.Drawing.Brush DarkMagenta { get => throw null; }
            public static System.Drawing.Brush DarkOliveGreen { get => throw null; }
            public static System.Drawing.Brush DarkOrange { get => throw null; }
            public static System.Drawing.Brush DarkOrchid { get => throw null; }
            public static System.Drawing.Brush DarkRed { get => throw null; }
            public static System.Drawing.Brush DarkSalmon { get => throw null; }
            public static System.Drawing.Brush DarkSeaGreen { get => throw null; }
            public static System.Drawing.Brush DarkSlateBlue { get => throw null; }
            public static System.Drawing.Brush DarkSlateGray { get => throw null; }
            public static System.Drawing.Brush DarkTurquoise { get => throw null; }
            public static System.Drawing.Brush DarkViolet { get => throw null; }
            public static System.Drawing.Brush DeepPink { get => throw null; }
            public static System.Drawing.Brush DeepSkyBlue { get => throw null; }
            public static System.Drawing.Brush DimGray { get => throw null; }
            public static System.Drawing.Brush DodgerBlue { get => throw null; }
            public static System.Drawing.Brush Firebrick { get => throw null; }
            public static System.Drawing.Brush FloralWhite { get => throw null; }
            public static System.Drawing.Brush ForestGreen { get => throw null; }
            public static System.Drawing.Brush Fuchsia { get => throw null; }
            public static System.Drawing.Brush Gainsboro { get => throw null; }
            public static System.Drawing.Brush GhostWhite { get => throw null; }
            public static System.Drawing.Brush Gold { get => throw null; }
            public static System.Drawing.Brush Goldenrod { get => throw null; }
            public static System.Drawing.Brush Gray { get => throw null; }
            public static System.Drawing.Brush Green { get => throw null; }
            public static System.Drawing.Brush GreenYellow { get => throw null; }
            public static System.Drawing.Brush Honeydew { get => throw null; }
            public static System.Drawing.Brush HotPink { get => throw null; }
            public static System.Drawing.Brush IndianRed { get => throw null; }
            public static System.Drawing.Brush Indigo { get => throw null; }
            public static System.Drawing.Brush Ivory { get => throw null; }
            public static System.Drawing.Brush Khaki { get => throw null; }
            public static System.Drawing.Brush Lavender { get => throw null; }
            public static System.Drawing.Brush LavenderBlush { get => throw null; }
            public static System.Drawing.Brush LawnGreen { get => throw null; }
            public static System.Drawing.Brush LemonChiffon { get => throw null; }
            public static System.Drawing.Brush LightBlue { get => throw null; }
            public static System.Drawing.Brush LightCoral { get => throw null; }
            public static System.Drawing.Brush LightCyan { get => throw null; }
            public static System.Drawing.Brush LightGoldenrodYellow { get => throw null; }
            public static System.Drawing.Brush LightGray { get => throw null; }
            public static System.Drawing.Brush LightGreen { get => throw null; }
            public static System.Drawing.Brush LightPink { get => throw null; }
            public static System.Drawing.Brush LightSalmon { get => throw null; }
            public static System.Drawing.Brush LightSeaGreen { get => throw null; }
            public static System.Drawing.Brush LightSkyBlue { get => throw null; }
            public static System.Drawing.Brush LightSlateGray { get => throw null; }
            public static System.Drawing.Brush LightSteelBlue { get => throw null; }
            public static System.Drawing.Brush LightYellow { get => throw null; }
            public static System.Drawing.Brush Lime { get => throw null; }
            public static System.Drawing.Brush LimeGreen { get => throw null; }
            public static System.Drawing.Brush Linen { get => throw null; }
            public static System.Drawing.Brush Magenta { get => throw null; }
            public static System.Drawing.Brush Maroon { get => throw null; }
            public static System.Drawing.Brush MediumAquamarine { get => throw null; }
            public static System.Drawing.Brush MediumBlue { get => throw null; }
            public static System.Drawing.Brush MediumOrchid { get => throw null; }
            public static System.Drawing.Brush MediumPurple { get => throw null; }
            public static System.Drawing.Brush MediumSeaGreen { get => throw null; }
            public static System.Drawing.Brush MediumSlateBlue { get => throw null; }
            public static System.Drawing.Brush MediumSpringGreen { get => throw null; }
            public static System.Drawing.Brush MediumTurquoise { get => throw null; }
            public static System.Drawing.Brush MediumVioletRed { get => throw null; }
            public static System.Drawing.Brush MidnightBlue { get => throw null; }
            public static System.Drawing.Brush MintCream { get => throw null; }
            public static System.Drawing.Brush MistyRose { get => throw null; }
            public static System.Drawing.Brush Moccasin { get => throw null; }
            public static System.Drawing.Brush NavajoWhite { get => throw null; }
            public static System.Drawing.Brush Navy { get => throw null; }
            public static System.Drawing.Brush OldLace { get => throw null; }
            public static System.Drawing.Brush Olive { get => throw null; }
            public static System.Drawing.Brush OliveDrab { get => throw null; }
            public static System.Drawing.Brush Orange { get => throw null; }
            public static System.Drawing.Brush OrangeRed { get => throw null; }
            public static System.Drawing.Brush Orchid { get => throw null; }
            public static System.Drawing.Brush PaleGoldenrod { get => throw null; }
            public static System.Drawing.Brush PaleGreen { get => throw null; }
            public static System.Drawing.Brush PaleTurquoise { get => throw null; }
            public static System.Drawing.Brush PaleVioletRed { get => throw null; }
            public static System.Drawing.Brush PapayaWhip { get => throw null; }
            public static System.Drawing.Brush PeachPuff { get => throw null; }
            public static System.Drawing.Brush Peru { get => throw null; }
            public static System.Drawing.Brush Pink { get => throw null; }
            public static System.Drawing.Brush Plum { get => throw null; }
            public static System.Drawing.Brush PowderBlue { get => throw null; }
            public static System.Drawing.Brush Purple { get => throw null; }
            public static System.Drawing.Brush Red { get => throw null; }
            public static System.Drawing.Brush RosyBrown { get => throw null; }
            public static System.Drawing.Brush RoyalBlue { get => throw null; }
            public static System.Drawing.Brush SaddleBrown { get => throw null; }
            public static System.Drawing.Brush Salmon { get => throw null; }
            public static System.Drawing.Brush SandyBrown { get => throw null; }
            public static System.Drawing.Brush SeaGreen { get => throw null; }
            public static System.Drawing.Brush SeaShell { get => throw null; }
            public static System.Drawing.Brush Sienna { get => throw null; }
            public static System.Drawing.Brush Silver { get => throw null; }
            public static System.Drawing.Brush SkyBlue { get => throw null; }
            public static System.Drawing.Brush SlateBlue { get => throw null; }
            public static System.Drawing.Brush SlateGray { get => throw null; }
            public static System.Drawing.Brush Snow { get => throw null; }
            public static System.Drawing.Brush SpringGreen { get => throw null; }
            public static System.Drawing.Brush SteelBlue { get => throw null; }
            public static System.Drawing.Brush Tan { get => throw null; }
            public static System.Drawing.Brush Teal { get => throw null; }
            public static System.Drawing.Brush Thistle { get => throw null; }
            public static System.Drawing.Brush Tomato { get => throw null; }
            public static System.Drawing.Brush Transparent { get => throw null; }
            public static System.Drawing.Brush Turquoise { get => throw null; }
            public static System.Drawing.Brush Violet { get => throw null; }
            public static System.Drawing.Brush Wheat { get => throw null; }
            public static System.Drawing.Brush White { get => throw null; }
            public static System.Drawing.Brush WhiteSmoke { get => throw null; }
            public static System.Drawing.Brush Yellow { get => throw null; }
            public static System.Drawing.Brush YellowGreen { get => throw null; }
        }

        // Generated from `System.Drawing.BufferedGraphics` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class BufferedGraphics : System.IDisposable
        {
            public void Dispose() => throw null;
            public System.Drawing.Graphics Graphics { get => throw null; }
            public void Render(System.IntPtr targetDC) => throw null;
            public void Render(System.Drawing.Graphics target) => throw null;
            public void Render() => throw null;
            // ERR: Stub generator didn't handle member: ~BufferedGraphics
        }

        // Generated from `System.Drawing.BufferedGraphicsContext` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class BufferedGraphicsContext : System.IDisposable
        {
            public System.Drawing.BufferedGraphics Allocate(System.IntPtr targetDC, System.Drawing.Rectangle targetRectangle) => throw null;
            public System.Drawing.BufferedGraphics Allocate(System.Drawing.Graphics targetGraphics, System.Drawing.Rectangle targetRectangle) => throw null;
            public BufferedGraphicsContext() => throw null;
            public void Dispose() => throw null;
            public void Invalidate() => throw null;
            public System.Drawing.Size MaximumBuffer { get => throw null; set => throw null; }
            // ERR: Stub generator didn't handle member: ~BufferedGraphicsContext
        }

        // Generated from `System.Drawing.BufferedGraphicsManager` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public static class BufferedGraphicsManager
        {
            public static System.Drawing.BufferedGraphicsContext Current { get => throw null; }
        }

        // Generated from `System.Drawing.CharacterRange` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public struct CharacterRange
        {
            public static bool operator !=(System.Drawing.CharacterRange cr1, System.Drawing.CharacterRange cr2) => throw null;
            public static bool operator ==(System.Drawing.CharacterRange cr1, System.Drawing.CharacterRange cr2) => throw null;
            public CharacterRange(int First, int Length) => throw null;
            // Stub generator skipped constructor 
            public override bool Equals(object obj) => throw null;
            public int First { get => throw null; set => throw null; }
            public override int GetHashCode() => throw null;
            public int Length { get => throw null; set => throw null; }
        }

        // Generated from `System.Drawing.ContentAlignment` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public enum ContentAlignment
        {
            BottomCenter,
            BottomLeft,
            BottomRight,
            MiddleCenter,
            MiddleLeft,
            MiddleRight,
            TopCenter,
            TopLeft,
            TopRight,
        }

        // Generated from `System.Drawing.CopyPixelOperation` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public enum CopyPixelOperation
        {
            Blackness,
            CaptureBlt,
            DestinationInvert,
            MergeCopy,
            MergePaint,
            NoMirrorBitmap,
            NotSourceCopy,
            NotSourceErase,
            PatCopy,
            PatInvert,
            PatPaint,
            SourceAnd,
            SourceCopy,
            SourceErase,
            SourceInvert,
            SourcePaint,
            Whiteness,
        }

        // Generated from `System.Drawing.Font` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class Font : System.MarshalByRefObject, System.Runtime.Serialization.ISerializable, System.IDisposable, System.ICloneable
        {
            public bool Bold { get => throw null; }
            public object Clone() => throw null;
            public void Dispose() => throw null;
            public override bool Equals(object obj) => throw null;
            public Font(string familyName, float emSize, System.Drawing.GraphicsUnit unit) => throw null;
            public Font(string familyName, float emSize, System.Drawing.FontStyle style, System.Drawing.GraphicsUnit unit, System.Byte gdiCharSet, bool gdiVerticalFont) => throw null;
            public Font(string familyName, float emSize, System.Drawing.FontStyle style, System.Drawing.GraphicsUnit unit, System.Byte gdiCharSet) => throw null;
            public Font(string familyName, float emSize, System.Drawing.FontStyle style, System.Drawing.GraphicsUnit unit) => throw null;
            public Font(string familyName, float emSize, System.Drawing.FontStyle style) => throw null;
            public Font(string familyName, float emSize) => throw null;
            public Font(System.Drawing.FontFamily family, float emSize, System.Drawing.GraphicsUnit unit) => throw null;
            public Font(System.Drawing.FontFamily family, float emSize, System.Drawing.FontStyle style, System.Drawing.GraphicsUnit unit, System.Byte gdiCharSet, bool gdiVerticalFont) => throw null;
            public Font(System.Drawing.FontFamily family, float emSize, System.Drawing.FontStyle style, System.Drawing.GraphicsUnit unit, System.Byte gdiCharSet) => throw null;
            public Font(System.Drawing.FontFamily family, float emSize, System.Drawing.FontStyle style, System.Drawing.GraphicsUnit unit) => throw null;
            public Font(System.Drawing.FontFamily family, float emSize, System.Drawing.FontStyle style) => throw null;
            public Font(System.Drawing.FontFamily family, float emSize) => throw null;
            public Font(System.Drawing.Font prototype, System.Drawing.FontStyle newStyle) => throw null;
            public System.Drawing.FontFamily FontFamily { get => throw null; }
            public static System.Drawing.Font FromHdc(System.IntPtr hdc) => throw null;
            public static System.Drawing.Font FromHfont(System.IntPtr hfont) => throw null;
            public static System.Drawing.Font FromLogFont(object lf, System.IntPtr hdc) => throw null;
            public static System.Drawing.Font FromLogFont(object lf) => throw null;
            public System.Byte GdiCharSet { get => throw null; }
            public bool GdiVerticalFont { get => throw null; }
            public override int GetHashCode() => throw null;
            public float GetHeight(float dpi) => throw null;
            public float GetHeight(System.Drawing.Graphics graphics) => throw null;
            public float GetHeight() => throw null;
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo si, System.Runtime.Serialization.StreamingContext context) => throw null;
            public int Height { get => throw null; }
            public bool IsSystemFont { get => throw null; }
            public bool Italic { get => throw null; }
            public string Name { get => throw null; }
            public string OriginalFontName { get => throw null; }
            public float Size { get => throw null; }
            public float SizeInPoints { get => throw null; }
            public bool Strikeout { get => throw null; }
            public System.Drawing.FontStyle Style { get => throw null; }
            public string SystemFontName { get => throw null; }
            public System.IntPtr ToHfont() => throw null;
            public void ToLogFont(object logFont, System.Drawing.Graphics graphics) => throw null;
            public void ToLogFont(object logFont) => throw null;
            public override string ToString() => throw null;
            public bool Underline { get => throw null; }
            public System.Drawing.GraphicsUnit Unit { get => throw null; }
            // ERR: Stub generator didn't handle member: ~Font
        }

        // Generated from `System.Drawing.FontFamily` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class FontFamily : System.MarshalByRefObject, System.IDisposable
        {
            public void Dispose() => throw null;
            public override bool Equals(object obj) => throw null;
            public static System.Drawing.FontFamily[] Families { get => throw null; }
            public FontFamily(string name, System.Drawing.Text.FontCollection fontCollection) => throw null;
            public FontFamily(string name) => throw null;
            public FontFamily(System.Drawing.Text.GenericFontFamilies genericFamily) => throw null;
            public static System.Drawing.FontFamily GenericMonospace { get => throw null; }
            public static System.Drawing.FontFamily GenericSansSerif { get => throw null; }
            public static System.Drawing.FontFamily GenericSerif { get => throw null; }
            public int GetCellAscent(System.Drawing.FontStyle style) => throw null;
            public int GetCellDescent(System.Drawing.FontStyle style) => throw null;
            public int GetEmHeight(System.Drawing.FontStyle style) => throw null;
            public static System.Drawing.FontFamily[] GetFamilies(System.Drawing.Graphics graphics) => throw null;
            public override int GetHashCode() => throw null;
            public int GetLineSpacing(System.Drawing.FontStyle style) => throw null;
            public string GetName(int language) => throw null;
            public bool IsStyleAvailable(System.Drawing.FontStyle style) => throw null;
            public string Name { get => throw null; }
            public override string ToString() => throw null;
            // ERR: Stub generator didn't handle member: ~FontFamily
        }

        // Generated from `System.Drawing.FontStyle` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        [System.Flags]
        public enum FontStyle
        {
            Bold,
            Italic,
            Regular,
            Strikeout,
            Underline,
        }

        // Generated from `System.Drawing.Graphics` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class Graphics : System.MarshalByRefObject, System.IDisposable, System.Drawing.IDeviceContext
        {
            public void AddMetafileComment(System.Byte[] data) => throw null;
            public System.Drawing.Drawing2D.GraphicsContainer BeginContainer(System.Drawing.RectangleF dstrect, System.Drawing.RectangleF srcrect, System.Drawing.GraphicsUnit unit) => throw null;
            public System.Drawing.Drawing2D.GraphicsContainer BeginContainer(System.Drawing.Rectangle dstrect, System.Drawing.Rectangle srcrect, System.Drawing.GraphicsUnit unit) => throw null;
            public System.Drawing.Drawing2D.GraphicsContainer BeginContainer() => throw null;
            public void Clear(System.Drawing.Color color) => throw null;
            public System.Drawing.Region Clip { get => throw null; set => throw null; }
            public System.Drawing.RectangleF ClipBounds { get => throw null; }
            public System.Drawing.Drawing2D.CompositingMode CompositingMode { get => throw null; set => throw null; }
            public System.Drawing.Drawing2D.CompositingQuality CompositingQuality { get => throw null; set => throw null; }
            public void CopyFromScreen(int sourceX, int sourceY, int destinationX, int destinationY, System.Drawing.Size blockRegionSize, System.Drawing.CopyPixelOperation copyPixelOperation) => throw null;
            public void CopyFromScreen(int sourceX, int sourceY, int destinationX, int destinationY, System.Drawing.Size blockRegionSize) => throw null;
            public void CopyFromScreen(System.Drawing.Point upperLeftSource, System.Drawing.Point upperLeftDestination, System.Drawing.Size blockRegionSize, System.Drawing.CopyPixelOperation copyPixelOperation) => throw null;
            public void CopyFromScreen(System.Drawing.Point upperLeftSource, System.Drawing.Point upperLeftDestination, System.Drawing.Size blockRegionSize) => throw null;
            public void Dispose() => throw null;
            public float DpiX { get => throw null; }
            public float DpiY { get => throw null; }
            public void DrawArc(System.Drawing.Pen pen, int x, int y, int width, int height, int startAngle, int sweepAngle) => throw null;
            public void DrawArc(System.Drawing.Pen pen, float x, float y, float width, float height, float startAngle, float sweepAngle) => throw null;
            public void DrawArc(System.Drawing.Pen pen, System.Drawing.RectangleF rect, float startAngle, float sweepAngle) => throw null;
            public void DrawArc(System.Drawing.Pen pen, System.Drawing.Rectangle rect, float startAngle, float sweepAngle) => throw null;
            public void DrawBezier(System.Drawing.Pen pen, float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) => throw null;
            public void DrawBezier(System.Drawing.Pen pen, System.Drawing.PointF pt1, System.Drawing.PointF pt2, System.Drawing.PointF pt3, System.Drawing.PointF pt4) => throw null;
            public void DrawBezier(System.Drawing.Pen pen, System.Drawing.Point pt1, System.Drawing.Point pt2, System.Drawing.Point pt3, System.Drawing.Point pt4) => throw null;
            public void DrawBeziers(System.Drawing.Pen pen, System.Drawing.Point[] points) => throw null;
            public void DrawBeziers(System.Drawing.Pen pen, System.Drawing.PointF[] points) => throw null;
            public void DrawClosedCurve(System.Drawing.Pen pen, System.Drawing.Point[] points, float tension, System.Drawing.Drawing2D.FillMode fillmode) => throw null;
            public void DrawClosedCurve(System.Drawing.Pen pen, System.Drawing.Point[] points) => throw null;
            public void DrawClosedCurve(System.Drawing.Pen pen, System.Drawing.PointF[] points, float tension, System.Drawing.Drawing2D.FillMode fillmode) => throw null;
            public void DrawClosedCurve(System.Drawing.Pen pen, System.Drawing.PointF[] points) => throw null;
            public void DrawCurve(System.Drawing.Pen pen, System.Drawing.Point[] points, int offset, int numberOfSegments, float tension) => throw null;
            public void DrawCurve(System.Drawing.Pen pen, System.Drawing.Point[] points, float tension) => throw null;
            public void DrawCurve(System.Drawing.Pen pen, System.Drawing.Point[] points) => throw null;
            public void DrawCurve(System.Drawing.Pen pen, System.Drawing.PointF[] points, int offset, int numberOfSegments, float tension) => throw null;
            public void DrawCurve(System.Drawing.Pen pen, System.Drawing.PointF[] points, int offset, int numberOfSegments) => throw null;
            public void DrawCurve(System.Drawing.Pen pen, System.Drawing.PointF[] points, float tension) => throw null;
            public void DrawCurve(System.Drawing.Pen pen, System.Drawing.PointF[] points) => throw null;
            public void DrawEllipse(System.Drawing.Pen pen, int x, int y, int width, int height) => throw null;
            public void DrawEllipse(System.Drawing.Pen pen, float x, float y, float width, float height) => throw null;
            public void DrawEllipse(System.Drawing.Pen pen, System.Drawing.RectangleF rect) => throw null;
            public void DrawEllipse(System.Drawing.Pen pen, System.Drawing.Rectangle rect) => throw null;
            public void DrawIcon(System.Drawing.Icon icon, int x, int y) => throw null;
            public void DrawIcon(System.Drawing.Icon icon, System.Drawing.Rectangle targetRect) => throw null;
            public void DrawIconUnstretched(System.Drawing.Icon icon, System.Drawing.Rectangle targetRect) => throw null;
            public void DrawImage(System.Drawing.Image image, int x, int y, int width, int height) => throw null;
            public void DrawImage(System.Drawing.Image image, int x, int y, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit srcUnit) => throw null;
            public void DrawImage(System.Drawing.Image image, int x, int y) => throw null;
            public void DrawImage(System.Drawing.Image image, float x, float y, float width, float height) => throw null;
            public void DrawImage(System.Drawing.Image image, float x, float y, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit srcUnit) => throw null;
            public void DrawImage(System.Drawing.Image image, float x, float y) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.RectangleF rect) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.RectangleF destRect, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit srcUnit) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Rectangle rect) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Rectangle destRect, int srcX, int srcY, int srcWidth, int srcHeight, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Imaging.ImageAttributes imageAttrs, System.Drawing.Graphics.DrawImageAbort callback, System.IntPtr callbackData) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Rectangle destRect, int srcX, int srcY, int srcWidth, int srcHeight, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Imaging.ImageAttributes imageAttr, System.Drawing.Graphics.DrawImageAbort callback) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Rectangle destRect, int srcX, int srcY, int srcWidth, int srcHeight, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Rectangle destRect, int srcX, int srcY, int srcWidth, int srcHeight, System.Drawing.GraphicsUnit srcUnit) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Rectangle destRect, float srcX, float srcY, float srcWidth, float srcHeight, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Imaging.ImageAttributes imageAttrs, System.Drawing.Graphics.DrawImageAbort callback, System.IntPtr callbackData) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Rectangle destRect, float srcX, float srcY, float srcWidth, float srcHeight, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Imaging.ImageAttributes imageAttrs, System.Drawing.Graphics.DrawImageAbort callback) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Rectangle destRect, float srcX, float srcY, float srcWidth, float srcHeight, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Imaging.ImageAttributes imageAttrs) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Rectangle destRect, float srcX, float srcY, float srcWidth, float srcHeight, System.Drawing.GraphicsUnit srcUnit) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Rectangle destRect, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit srcUnit) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Point[] destPoints, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Imaging.ImageAttributes imageAttr, System.Drawing.Graphics.DrawImageAbort callback, int callbackData) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Point[] destPoints, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Imaging.ImageAttributes imageAttr, System.Drawing.Graphics.DrawImageAbort callback) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Point[] destPoints, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Point[] destPoints, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit srcUnit) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Point[] destPoints) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.PointF[] destPoints, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Imaging.ImageAttributes imageAttr, System.Drawing.Graphics.DrawImageAbort callback, int callbackData) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.PointF[] destPoints, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Imaging.ImageAttributes imageAttr, System.Drawing.Graphics.DrawImageAbort callback) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.PointF[] destPoints, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.PointF[] destPoints, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit srcUnit) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.PointF[] destPoints) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.PointF point) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Point point) => throw null;
            // Generated from `System.Drawing.Graphics+DrawImageAbort` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public delegate bool DrawImageAbort(System.IntPtr callbackdata);


            public void DrawImageUnscaled(System.Drawing.Image image, int x, int y, int width, int height) => throw null;
            public void DrawImageUnscaled(System.Drawing.Image image, int x, int y) => throw null;
            public void DrawImageUnscaled(System.Drawing.Image image, System.Drawing.Rectangle rect) => throw null;
            public void DrawImageUnscaled(System.Drawing.Image image, System.Drawing.Point point) => throw null;
            public void DrawImageUnscaledAndClipped(System.Drawing.Image image, System.Drawing.Rectangle rect) => throw null;
            public void DrawLine(System.Drawing.Pen pen, int x1, int y1, int x2, int y2) => throw null;
            public void DrawLine(System.Drawing.Pen pen, float x1, float y1, float x2, float y2) => throw null;
            public void DrawLine(System.Drawing.Pen pen, System.Drawing.PointF pt1, System.Drawing.PointF pt2) => throw null;
            public void DrawLine(System.Drawing.Pen pen, System.Drawing.Point pt1, System.Drawing.Point pt2) => throw null;
            public void DrawLines(System.Drawing.Pen pen, System.Drawing.Point[] points) => throw null;
            public void DrawLines(System.Drawing.Pen pen, System.Drawing.PointF[] points) => throw null;
            public void DrawPath(System.Drawing.Pen pen, System.Drawing.Drawing2D.GraphicsPath path) => throw null;
            public void DrawPie(System.Drawing.Pen pen, int x, int y, int width, int height, int startAngle, int sweepAngle) => throw null;
            public void DrawPie(System.Drawing.Pen pen, float x, float y, float width, float height, float startAngle, float sweepAngle) => throw null;
            public void DrawPie(System.Drawing.Pen pen, System.Drawing.RectangleF rect, float startAngle, float sweepAngle) => throw null;
            public void DrawPie(System.Drawing.Pen pen, System.Drawing.Rectangle rect, float startAngle, float sweepAngle) => throw null;
            public void DrawPolygon(System.Drawing.Pen pen, System.Drawing.Point[] points) => throw null;
            public void DrawPolygon(System.Drawing.Pen pen, System.Drawing.PointF[] points) => throw null;
            public void DrawRectangle(System.Drawing.Pen pen, int x, int y, int width, int height) => throw null;
            public void DrawRectangle(System.Drawing.Pen pen, float x, float y, float width, float height) => throw null;
            public void DrawRectangle(System.Drawing.Pen pen, System.Drawing.Rectangle rect) => throw null;
            public void DrawRectangles(System.Drawing.Pen pen, System.Drawing.Rectangle[] rects) => throw null;
            public void DrawRectangles(System.Drawing.Pen pen, System.Drawing.RectangleF[] rects) => throw null;
            public void DrawString(string s, System.Drawing.Font font, System.Drawing.Brush brush, float x, float y, System.Drawing.StringFormat format) => throw null;
            public void DrawString(string s, System.Drawing.Font font, System.Drawing.Brush brush, float x, float y) => throw null;
            public void DrawString(string s, System.Drawing.Font font, System.Drawing.Brush brush, System.Drawing.RectangleF layoutRectangle, System.Drawing.StringFormat format) => throw null;
            public void DrawString(string s, System.Drawing.Font font, System.Drawing.Brush brush, System.Drawing.RectangleF layoutRectangle) => throw null;
            public void DrawString(string s, System.Drawing.Font font, System.Drawing.Brush brush, System.Drawing.PointF point, System.Drawing.StringFormat format) => throw null;
            public void DrawString(string s, System.Drawing.Font font, System.Drawing.Brush brush, System.Drawing.PointF point) => throw null;
            public void EndContainer(System.Drawing.Drawing2D.GraphicsContainer container) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.RectangleF destRect, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit unit, System.Drawing.Graphics.EnumerateMetafileProc callback, System.IntPtr callbackData, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.RectangleF destRect, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Graphics.EnumerateMetafileProc callback, System.IntPtr callbackData) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.RectangleF destRect, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Graphics.EnumerateMetafileProc callback) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.RectangleF destRect, System.Drawing.Graphics.EnumerateMetafileProc callback, System.IntPtr callbackData, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.RectangleF destRect, System.Drawing.Graphics.EnumerateMetafileProc callback, System.IntPtr callbackData) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.RectangleF destRect, System.Drawing.Graphics.EnumerateMetafileProc callback) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Rectangle destRect, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit unit, System.Drawing.Graphics.EnumerateMetafileProc callback, System.IntPtr callbackData, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Rectangle destRect, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Graphics.EnumerateMetafileProc callback, System.IntPtr callbackData) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Rectangle destRect, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Graphics.EnumerateMetafileProc callback) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Rectangle destRect, System.Drawing.Graphics.EnumerateMetafileProc callback, System.IntPtr callbackData, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Rectangle destRect, System.Drawing.Graphics.EnumerateMetafileProc callback, System.IntPtr callbackData) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Rectangle destRect, System.Drawing.Graphics.EnumerateMetafileProc callback) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Point[] destPoints, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit unit, System.Drawing.Graphics.EnumerateMetafileProc callback, System.IntPtr callbackData, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Point[] destPoints, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Graphics.EnumerateMetafileProc callback, System.IntPtr callbackData) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Point[] destPoints, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Graphics.EnumerateMetafileProc callback) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Point[] destPoints, System.Drawing.Graphics.EnumerateMetafileProc callback, System.IntPtr callbackData, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Point[] destPoints, System.Drawing.Graphics.EnumerateMetafileProc callback, System.IntPtr callbackData) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Point[] destPoints, System.Drawing.Graphics.EnumerateMetafileProc callback) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.PointF[] destPoints, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit unit, System.Drawing.Graphics.EnumerateMetafileProc callback, System.IntPtr callbackData, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.PointF[] destPoints, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Graphics.EnumerateMetafileProc callback, System.IntPtr callbackData) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.PointF[] destPoints, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Graphics.EnumerateMetafileProc callback) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.PointF[] destPoints, System.Drawing.Graphics.EnumerateMetafileProc callback, System.IntPtr callbackData, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.PointF[] destPoints, System.Drawing.Graphics.EnumerateMetafileProc callback, System.IntPtr callbackData) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.PointF[] destPoints, System.Drawing.Graphics.EnumerateMetafileProc callback) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.PointF destPoint, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit unit, System.Drawing.Graphics.EnumerateMetafileProc callback, System.IntPtr callbackData, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.PointF destPoint, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Graphics.EnumerateMetafileProc callback, System.IntPtr callbackData) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.PointF destPoint, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Graphics.EnumerateMetafileProc callback) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.PointF destPoint, System.Drawing.Graphics.EnumerateMetafileProc callback, System.IntPtr callbackData, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.PointF destPoint, System.Drawing.Graphics.EnumerateMetafileProc callback, System.IntPtr callbackData) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.PointF destPoint, System.Drawing.Graphics.EnumerateMetafileProc callback) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Point destPoint, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit unit, System.Drawing.Graphics.EnumerateMetafileProc callback, System.IntPtr callbackData, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Point destPoint, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Graphics.EnumerateMetafileProc callback, System.IntPtr callbackData) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Point destPoint, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Graphics.EnumerateMetafileProc callback) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Point destPoint, System.Drawing.Graphics.EnumerateMetafileProc callback, System.IntPtr callbackData, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Point destPoint, System.Drawing.Graphics.EnumerateMetafileProc callback, System.IntPtr callbackData) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Point destPoint, System.Drawing.Graphics.EnumerateMetafileProc callback) => throw null;
            // Generated from `System.Drawing.Graphics+EnumerateMetafileProc` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public delegate bool EnumerateMetafileProc(System.Drawing.Imaging.EmfPlusRecordType recordType, int flags, int dataSize, System.IntPtr data, System.Drawing.Imaging.PlayRecordCallback callbackData);


            public void ExcludeClip(System.Drawing.Region region) => throw null;
            public void ExcludeClip(System.Drawing.Rectangle rect) => throw null;
            public void FillClosedCurve(System.Drawing.Brush brush, System.Drawing.Point[] points, System.Drawing.Drawing2D.FillMode fillmode, float tension) => throw null;
            public void FillClosedCurve(System.Drawing.Brush brush, System.Drawing.Point[] points, System.Drawing.Drawing2D.FillMode fillmode) => throw null;
            public void FillClosedCurve(System.Drawing.Brush brush, System.Drawing.Point[] points) => throw null;
            public void FillClosedCurve(System.Drawing.Brush brush, System.Drawing.PointF[] points, System.Drawing.Drawing2D.FillMode fillmode, float tension) => throw null;
            public void FillClosedCurve(System.Drawing.Brush brush, System.Drawing.PointF[] points, System.Drawing.Drawing2D.FillMode fillmode) => throw null;
            public void FillClosedCurve(System.Drawing.Brush brush, System.Drawing.PointF[] points) => throw null;
            public void FillEllipse(System.Drawing.Brush brush, int x, int y, int width, int height) => throw null;
            public void FillEllipse(System.Drawing.Brush brush, float x, float y, float width, float height) => throw null;
            public void FillEllipse(System.Drawing.Brush brush, System.Drawing.RectangleF rect) => throw null;
            public void FillEllipse(System.Drawing.Brush brush, System.Drawing.Rectangle rect) => throw null;
            public void FillPath(System.Drawing.Brush brush, System.Drawing.Drawing2D.GraphicsPath path) => throw null;
            public void FillPie(System.Drawing.Brush brush, int x, int y, int width, int height, int startAngle, int sweepAngle) => throw null;
            public void FillPie(System.Drawing.Brush brush, float x, float y, float width, float height, float startAngle, float sweepAngle) => throw null;
            public void FillPie(System.Drawing.Brush brush, System.Drawing.Rectangle rect, float startAngle, float sweepAngle) => throw null;
            public void FillPolygon(System.Drawing.Brush brush, System.Drawing.Point[] points, System.Drawing.Drawing2D.FillMode fillMode) => throw null;
            public void FillPolygon(System.Drawing.Brush brush, System.Drawing.Point[] points) => throw null;
            public void FillPolygon(System.Drawing.Brush brush, System.Drawing.PointF[] points, System.Drawing.Drawing2D.FillMode fillMode) => throw null;
            public void FillPolygon(System.Drawing.Brush brush, System.Drawing.PointF[] points) => throw null;
            public void FillRectangle(System.Drawing.Brush brush, int x, int y, int width, int height) => throw null;
            public void FillRectangle(System.Drawing.Brush brush, float x, float y, float width, float height) => throw null;
            public void FillRectangle(System.Drawing.Brush brush, System.Drawing.RectangleF rect) => throw null;
            public void FillRectangle(System.Drawing.Brush brush, System.Drawing.Rectangle rect) => throw null;
            public void FillRectangles(System.Drawing.Brush brush, System.Drawing.Rectangle[] rects) => throw null;
            public void FillRectangles(System.Drawing.Brush brush, System.Drawing.RectangleF[] rects) => throw null;
            public void FillRegion(System.Drawing.Brush brush, System.Drawing.Region region) => throw null;
            public void Flush(System.Drawing.Drawing2D.FlushIntention intention) => throw null;
            public void Flush() => throw null;
            public static System.Drawing.Graphics FromHdc(System.IntPtr hdc, System.IntPtr hdevice) => throw null;
            public static System.Drawing.Graphics FromHdc(System.IntPtr hdc) => throw null;
            public static System.Drawing.Graphics FromHdcInternal(System.IntPtr hdc) => throw null;
            public static System.Drawing.Graphics FromHwnd(System.IntPtr hwnd) => throw null;
            public static System.Drawing.Graphics FromHwndInternal(System.IntPtr hwnd) => throw null;
            public static System.Drawing.Graphics FromImage(System.Drawing.Image image) => throw null;
            public object GetContextInfo() => throw null;
            public static System.IntPtr GetHalftonePalette() => throw null;
            public System.IntPtr GetHdc() => throw null;
            public System.Drawing.Color GetNearestColor(System.Drawing.Color color) => throw null;
            public System.Drawing.Drawing2D.InterpolationMode InterpolationMode { get => throw null; set => throw null; }
            public void IntersectClip(System.Drawing.Region region) => throw null;
            public void IntersectClip(System.Drawing.RectangleF rect) => throw null;
            public void IntersectClip(System.Drawing.Rectangle rect) => throw null;
            public bool IsClipEmpty { get => throw null; }
            public bool IsVisible(int x, int y, int width, int height) => throw null;
            public bool IsVisible(int x, int y) => throw null;
            public bool IsVisible(float x, float y, float width, float height) => throw null;
            public bool IsVisible(float x, float y) => throw null;
            public bool IsVisible(System.Drawing.RectangleF rect) => throw null;
            public bool IsVisible(System.Drawing.Rectangle rect) => throw null;
            public bool IsVisible(System.Drawing.PointF point) => throw null;
            public bool IsVisible(System.Drawing.Point point) => throw null;
            public bool IsVisibleClipEmpty { get => throw null; }
            public System.Drawing.Region[] MeasureCharacterRanges(string text, System.Drawing.Font font, System.Drawing.RectangleF layoutRect, System.Drawing.StringFormat stringFormat) => throw null;
            public System.Drawing.SizeF MeasureString(string text, System.Drawing.Font font, int width, System.Drawing.StringFormat format) => throw null;
            public System.Drawing.SizeF MeasureString(string text, System.Drawing.Font font, int width) => throw null;
            public System.Drawing.SizeF MeasureString(string text, System.Drawing.Font font, System.Drawing.SizeF layoutArea, System.Drawing.StringFormat stringFormat, out int charactersFitted, out int linesFilled) => throw null;
            public System.Drawing.SizeF MeasureString(string text, System.Drawing.Font font, System.Drawing.SizeF layoutArea, System.Drawing.StringFormat stringFormat) => throw null;
            public System.Drawing.SizeF MeasureString(string text, System.Drawing.Font font, System.Drawing.SizeF layoutArea) => throw null;
            public System.Drawing.SizeF MeasureString(string text, System.Drawing.Font font, System.Drawing.PointF origin, System.Drawing.StringFormat stringFormat) => throw null;
            public System.Drawing.SizeF MeasureString(string text, System.Drawing.Font font) => throw null;
            public void MultiplyTransform(System.Drawing.Drawing2D.Matrix matrix, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
            public void MultiplyTransform(System.Drawing.Drawing2D.Matrix matrix) => throw null;
            public float PageScale { get => throw null; set => throw null; }
            public System.Drawing.GraphicsUnit PageUnit { get => throw null; set => throw null; }
            public System.Drawing.Drawing2D.PixelOffsetMode PixelOffsetMode { get => throw null; set => throw null; }
            public void ReleaseHdc(System.IntPtr hdc) => throw null;
            public void ReleaseHdc() => throw null;
            public void ReleaseHdcInternal(System.IntPtr hdc) => throw null;
            public System.Drawing.Point RenderingOrigin { get => throw null; set => throw null; }
            public void ResetClip() => throw null;
            public void ResetTransform() => throw null;
            public void Restore(System.Drawing.Drawing2D.GraphicsState gstate) => throw null;
            public void RotateTransform(float angle, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
            public void RotateTransform(float angle) => throw null;
            public System.Drawing.Drawing2D.GraphicsState Save() => throw null;
            public void ScaleTransform(float sx, float sy, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
            public void ScaleTransform(float sx, float sy) => throw null;
            public void SetClip(System.Drawing.Region region, System.Drawing.Drawing2D.CombineMode combineMode) => throw null;
            public void SetClip(System.Drawing.RectangleF rect, System.Drawing.Drawing2D.CombineMode combineMode) => throw null;
            public void SetClip(System.Drawing.RectangleF rect) => throw null;
            public void SetClip(System.Drawing.Rectangle rect, System.Drawing.Drawing2D.CombineMode combineMode) => throw null;
            public void SetClip(System.Drawing.Rectangle rect) => throw null;
            public void SetClip(System.Drawing.Graphics g, System.Drawing.Drawing2D.CombineMode combineMode) => throw null;
            public void SetClip(System.Drawing.Graphics g) => throw null;
            public void SetClip(System.Drawing.Drawing2D.GraphicsPath path, System.Drawing.Drawing2D.CombineMode combineMode) => throw null;
            public void SetClip(System.Drawing.Drawing2D.GraphicsPath path) => throw null;
            public System.Drawing.Drawing2D.SmoothingMode SmoothingMode { get => throw null; set => throw null; }
            public int TextContrast { get => throw null; set => throw null; }
            public System.Drawing.Text.TextRenderingHint TextRenderingHint { get => throw null; set => throw null; }
            public System.Drawing.Drawing2D.Matrix Transform { get => throw null; set => throw null; }
            public void TransformPoints(System.Drawing.Drawing2D.CoordinateSpace destSpace, System.Drawing.Drawing2D.CoordinateSpace srcSpace, System.Drawing.Point[] pts) => throw null;
            public void TransformPoints(System.Drawing.Drawing2D.CoordinateSpace destSpace, System.Drawing.Drawing2D.CoordinateSpace srcSpace, System.Drawing.PointF[] pts) => throw null;
            public void TranslateClip(int dx, int dy) => throw null;
            public void TranslateClip(float dx, float dy) => throw null;
            public void TranslateTransform(float dx, float dy, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
            public void TranslateTransform(float dx, float dy) => throw null;
            public System.Drawing.RectangleF VisibleClipBounds { get => throw null; }
            // ERR: Stub generator didn't handle member: ~Graphics
        }

        // Generated from `System.Drawing.GraphicsUnit` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public enum GraphicsUnit
        {
            Display,
            Document,
            Inch,
            Millimeter,
            Pixel,
            Point,
            World,
        }

        // Generated from `System.Drawing.IDeviceContext` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public interface IDeviceContext : System.IDisposable
        {
            System.IntPtr GetHdc();
            void ReleaseHdc();
        }

        // Generated from `System.Drawing.Icon` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class Icon : System.MarshalByRefObject, System.Runtime.Serialization.ISerializable, System.IDisposable, System.ICloneable
        {
            public object Clone() => throw null;
            public void Dispose() => throw null;
            public static System.Drawing.Icon ExtractAssociatedIcon(string filePath) => throw null;
            public static System.Drawing.Icon FromHandle(System.IntPtr handle) => throw null;
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public System.IntPtr Handle { get => throw null; }
            public int Height { get => throw null; }
            public Icon(string fileName, int width, int height) => throw null;
            public Icon(string fileName, System.Drawing.Size size) => throw null;
            public Icon(string fileName) => throw null;
            public Icon(System.Type type, string resource) => throw null;
            public Icon(System.IO.Stream stream, int width, int height) => throw null;
            public Icon(System.IO.Stream stream, System.Drawing.Size size) => throw null;
            public Icon(System.IO.Stream stream) => throw null;
            public Icon(System.Drawing.Icon original, int width, int height) => throw null;
            public Icon(System.Drawing.Icon original, System.Drawing.Size size) => throw null;
            public void Save(System.IO.Stream outputStream) => throw null;
            public System.Drawing.Size Size { get => throw null; }
            public System.Drawing.Bitmap ToBitmap() => throw null;
            public override string ToString() => throw null;
            public int Width { get => throw null; }
            // ERR: Stub generator didn't handle member: ~Icon
        }

        // Generated from `System.Drawing.Image` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public abstract class Image : System.MarshalByRefObject, System.Runtime.Serialization.ISerializable, System.IDisposable, System.ICloneable
        {
            public object Clone() => throw null;
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            public int Flags { get => throw null; }
            public System.Guid[] FrameDimensionsList { get => throw null; }
            public static System.Drawing.Image FromFile(string filename, bool useEmbeddedColorManagement) => throw null;
            public static System.Drawing.Image FromFile(string filename) => throw null;
            public static System.Drawing.Bitmap FromHbitmap(System.IntPtr hbitmap, System.IntPtr hpalette) => throw null;
            public static System.Drawing.Bitmap FromHbitmap(System.IntPtr hbitmap) => throw null;
            public static System.Drawing.Image FromStream(System.IO.Stream stream, bool useEmbeddedColorManagement, bool validateImageData) => throw null;
            public static System.Drawing.Image FromStream(System.IO.Stream stream, bool useEmbeddedColorManagement) => throw null;
            public static System.Drawing.Image FromStream(System.IO.Stream stream) => throw null;
            public System.Drawing.RectangleF GetBounds(ref System.Drawing.GraphicsUnit pageUnit) => throw null;
            public System.Drawing.Imaging.EncoderParameters GetEncoderParameterList(System.Guid encoder) => throw null;
            public int GetFrameCount(System.Drawing.Imaging.FrameDimension dimension) => throw null;
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public static int GetPixelFormatSize(System.Drawing.Imaging.PixelFormat pixfmt) => throw null;
            public System.Drawing.Imaging.PropertyItem GetPropertyItem(int propid) => throw null;
            public System.Drawing.Image GetThumbnailImage(int thumbWidth, int thumbHeight, System.Drawing.Image.GetThumbnailImageAbort callback, System.IntPtr callbackData) => throw null;
            // Generated from `System.Drawing.Image+GetThumbnailImageAbort` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public delegate bool GetThumbnailImageAbort();


            public int Height { get => throw null; }
            public float HorizontalResolution { get => throw null; }
            internal Image() => throw null;
            public static bool IsAlphaPixelFormat(System.Drawing.Imaging.PixelFormat pixfmt) => throw null;
            public static bool IsCanonicalPixelFormat(System.Drawing.Imaging.PixelFormat pixfmt) => throw null;
            public static bool IsExtendedPixelFormat(System.Drawing.Imaging.PixelFormat pixfmt) => throw null;
            public System.Drawing.Imaging.ColorPalette Palette { get => throw null; set => throw null; }
            public System.Drawing.SizeF PhysicalDimension { get => throw null; }
            public System.Drawing.Imaging.PixelFormat PixelFormat { get => throw null; }
            public int[] PropertyIdList { get => throw null; }
            public System.Drawing.Imaging.PropertyItem[] PropertyItems { get => throw null; }
            public System.Drawing.Imaging.ImageFormat RawFormat { get => throw null; }
            public void RemovePropertyItem(int propid) => throw null;
            public void RotateFlip(System.Drawing.RotateFlipType rotateFlipType) => throw null;
            public void Save(string filename, System.Drawing.Imaging.ImageFormat format) => throw null;
            public void Save(string filename, System.Drawing.Imaging.ImageCodecInfo encoder, System.Drawing.Imaging.EncoderParameters encoderParams) => throw null;
            public void Save(string filename) => throw null;
            public void Save(System.IO.Stream stream, System.Drawing.Imaging.ImageFormat format) => throw null;
            public void Save(System.IO.Stream stream, System.Drawing.Imaging.ImageCodecInfo encoder, System.Drawing.Imaging.EncoderParameters encoderParams) => throw null;
            public void SaveAdd(System.Drawing.Imaging.EncoderParameters encoderParams) => throw null;
            public void SaveAdd(System.Drawing.Image image, System.Drawing.Imaging.EncoderParameters encoderParams) => throw null;
            public int SelectActiveFrame(System.Drawing.Imaging.FrameDimension dimension, int frameIndex) => throw null;
            public void SetPropertyItem(System.Drawing.Imaging.PropertyItem propitem) => throw null;
            public System.Drawing.Size Size { get => throw null; }
            public object Tag { get => throw null; set => throw null; }
            public float VerticalResolution { get => throw null; }
            public int Width { get => throw null; }
            // ERR: Stub generator didn't handle member: ~Image
        }

        // Generated from `System.Drawing.ImageAnimator` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ImageAnimator
        {
            public static void Animate(System.Drawing.Image image, System.EventHandler onFrameChangedHandler) => throw null;
            public static bool CanAnimate(System.Drawing.Image image) => throw null;
            public static void StopAnimate(System.Drawing.Image image, System.EventHandler onFrameChangedHandler) => throw null;
            public static void UpdateFrames(System.Drawing.Image image) => throw null;
            public static void UpdateFrames() => throw null;
        }

        // Generated from `System.Drawing.Pen` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class Pen : System.MarshalByRefObject, System.IDisposable, System.ICloneable
        {
            public System.Drawing.Drawing2D.PenAlignment Alignment { get => throw null; set => throw null; }
            public System.Drawing.Brush Brush { get => throw null; set => throw null; }
            public object Clone() => throw null;
            public System.Drawing.Color Color { get => throw null; set => throw null; }
            public float[] CompoundArray { get => throw null; set => throw null; }
            public System.Drawing.Drawing2D.CustomLineCap CustomEndCap { get => throw null; set => throw null; }
            public System.Drawing.Drawing2D.CustomLineCap CustomStartCap { get => throw null; set => throw null; }
            public System.Drawing.Drawing2D.DashCap DashCap { get => throw null; set => throw null; }
            public float DashOffset { get => throw null; set => throw null; }
            public float[] DashPattern { get => throw null; set => throw null; }
            public System.Drawing.Drawing2D.DashStyle DashStyle { get => throw null; set => throw null; }
            public void Dispose() => throw null;
            public System.Drawing.Drawing2D.LineCap EndCap { get => throw null; set => throw null; }
            public System.Drawing.Drawing2D.LineJoin LineJoin { get => throw null; set => throw null; }
            public float MiterLimit { get => throw null; set => throw null; }
            public void MultiplyTransform(System.Drawing.Drawing2D.Matrix matrix, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
            public void MultiplyTransform(System.Drawing.Drawing2D.Matrix matrix) => throw null;
            public Pen(System.Drawing.Color color, float width) => throw null;
            public Pen(System.Drawing.Color color) => throw null;
            public Pen(System.Drawing.Brush brush, float width) => throw null;
            public Pen(System.Drawing.Brush brush) => throw null;
            public System.Drawing.Drawing2D.PenType PenType { get => throw null; }
            public void ResetTransform() => throw null;
            public void RotateTransform(float angle, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
            public void RotateTransform(float angle) => throw null;
            public void ScaleTransform(float sx, float sy, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
            public void ScaleTransform(float sx, float sy) => throw null;
            public void SetLineCap(System.Drawing.Drawing2D.LineCap startCap, System.Drawing.Drawing2D.LineCap endCap, System.Drawing.Drawing2D.DashCap dashCap) => throw null;
            public System.Drawing.Drawing2D.LineCap StartCap { get => throw null; set => throw null; }
            public System.Drawing.Drawing2D.Matrix Transform { get => throw null; set => throw null; }
            public void TranslateTransform(float dx, float dy, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
            public void TranslateTransform(float dx, float dy) => throw null;
            public float Width { get => throw null; set => throw null; }
            // ERR: Stub generator didn't handle member: ~Pen
        }

        // Generated from `System.Drawing.Pens` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public static class Pens
        {
            public static System.Drawing.Pen AliceBlue { get => throw null; }
            public static System.Drawing.Pen AntiqueWhite { get => throw null; }
            public static System.Drawing.Pen Aqua { get => throw null; }
            public static System.Drawing.Pen Aquamarine { get => throw null; }
            public static System.Drawing.Pen Azure { get => throw null; }
            public static System.Drawing.Pen Beige { get => throw null; }
            public static System.Drawing.Pen Bisque { get => throw null; }
            public static System.Drawing.Pen Black { get => throw null; }
            public static System.Drawing.Pen BlanchedAlmond { get => throw null; }
            public static System.Drawing.Pen Blue { get => throw null; }
            public static System.Drawing.Pen BlueViolet { get => throw null; }
            public static System.Drawing.Pen Brown { get => throw null; }
            public static System.Drawing.Pen BurlyWood { get => throw null; }
            public static System.Drawing.Pen CadetBlue { get => throw null; }
            public static System.Drawing.Pen Chartreuse { get => throw null; }
            public static System.Drawing.Pen Chocolate { get => throw null; }
            public static System.Drawing.Pen Coral { get => throw null; }
            public static System.Drawing.Pen CornflowerBlue { get => throw null; }
            public static System.Drawing.Pen Cornsilk { get => throw null; }
            public static System.Drawing.Pen Crimson { get => throw null; }
            public static System.Drawing.Pen Cyan { get => throw null; }
            public static System.Drawing.Pen DarkBlue { get => throw null; }
            public static System.Drawing.Pen DarkCyan { get => throw null; }
            public static System.Drawing.Pen DarkGoldenrod { get => throw null; }
            public static System.Drawing.Pen DarkGray { get => throw null; }
            public static System.Drawing.Pen DarkGreen { get => throw null; }
            public static System.Drawing.Pen DarkKhaki { get => throw null; }
            public static System.Drawing.Pen DarkMagenta { get => throw null; }
            public static System.Drawing.Pen DarkOliveGreen { get => throw null; }
            public static System.Drawing.Pen DarkOrange { get => throw null; }
            public static System.Drawing.Pen DarkOrchid { get => throw null; }
            public static System.Drawing.Pen DarkRed { get => throw null; }
            public static System.Drawing.Pen DarkSalmon { get => throw null; }
            public static System.Drawing.Pen DarkSeaGreen { get => throw null; }
            public static System.Drawing.Pen DarkSlateBlue { get => throw null; }
            public static System.Drawing.Pen DarkSlateGray { get => throw null; }
            public static System.Drawing.Pen DarkTurquoise { get => throw null; }
            public static System.Drawing.Pen DarkViolet { get => throw null; }
            public static System.Drawing.Pen DeepPink { get => throw null; }
            public static System.Drawing.Pen DeepSkyBlue { get => throw null; }
            public static System.Drawing.Pen DimGray { get => throw null; }
            public static System.Drawing.Pen DodgerBlue { get => throw null; }
            public static System.Drawing.Pen Firebrick { get => throw null; }
            public static System.Drawing.Pen FloralWhite { get => throw null; }
            public static System.Drawing.Pen ForestGreen { get => throw null; }
            public static System.Drawing.Pen Fuchsia { get => throw null; }
            public static System.Drawing.Pen Gainsboro { get => throw null; }
            public static System.Drawing.Pen GhostWhite { get => throw null; }
            public static System.Drawing.Pen Gold { get => throw null; }
            public static System.Drawing.Pen Goldenrod { get => throw null; }
            public static System.Drawing.Pen Gray { get => throw null; }
            public static System.Drawing.Pen Green { get => throw null; }
            public static System.Drawing.Pen GreenYellow { get => throw null; }
            public static System.Drawing.Pen Honeydew { get => throw null; }
            public static System.Drawing.Pen HotPink { get => throw null; }
            public static System.Drawing.Pen IndianRed { get => throw null; }
            public static System.Drawing.Pen Indigo { get => throw null; }
            public static System.Drawing.Pen Ivory { get => throw null; }
            public static System.Drawing.Pen Khaki { get => throw null; }
            public static System.Drawing.Pen Lavender { get => throw null; }
            public static System.Drawing.Pen LavenderBlush { get => throw null; }
            public static System.Drawing.Pen LawnGreen { get => throw null; }
            public static System.Drawing.Pen LemonChiffon { get => throw null; }
            public static System.Drawing.Pen LightBlue { get => throw null; }
            public static System.Drawing.Pen LightCoral { get => throw null; }
            public static System.Drawing.Pen LightCyan { get => throw null; }
            public static System.Drawing.Pen LightGoldenrodYellow { get => throw null; }
            public static System.Drawing.Pen LightGray { get => throw null; }
            public static System.Drawing.Pen LightGreen { get => throw null; }
            public static System.Drawing.Pen LightPink { get => throw null; }
            public static System.Drawing.Pen LightSalmon { get => throw null; }
            public static System.Drawing.Pen LightSeaGreen { get => throw null; }
            public static System.Drawing.Pen LightSkyBlue { get => throw null; }
            public static System.Drawing.Pen LightSlateGray { get => throw null; }
            public static System.Drawing.Pen LightSteelBlue { get => throw null; }
            public static System.Drawing.Pen LightYellow { get => throw null; }
            public static System.Drawing.Pen Lime { get => throw null; }
            public static System.Drawing.Pen LimeGreen { get => throw null; }
            public static System.Drawing.Pen Linen { get => throw null; }
            public static System.Drawing.Pen Magenta { get => throw null; }
            public static System.Drawing.Pen Maroon { get => throw null; }
            public static System.Drawing.Pen MediumAquamarine { get => throw null; }
            public static System.Drawing.Pen MediumBlue { get => throw null; }
            public static System.Drawing.Pen MediumOrchid { get => throw null; }
            public static System.Drawing.Pen MediumPurple { get => throw null; }
            public static System.Drawing.Pen MediumSeaGreen { get => throw null; }
            public static System.Drawing.Pen MediumSlateBlue { get => throw null; }
            public static System.Drawing.Pen MediumSpringGreen { get => throw null; }
            public static System.Drawing.Pen MediumTurquoise { get => throw null; }
            public static System.Drawing.Pen MediumVioletRed { get => throw null; }
            public static System.Drawing.Pen MidnightBlue { get => throw null; }
            public static System.Drawing.Pen MintCream { get => throw null; }
            public static System.Drawing.Pen MistyRose { get => throw null; }
            public static System.Drawing.Pen Moccasin { get => throw null; }
            public static System.Drawing.Pen NavajoWhite { get => throw null; }
            public static System.Drawing.Pen Navy { get => throw null; }
            public static System.Drawing.Pen OldLace { get => throw null; }
            public static System.Drawing.Pen Olive { get => throw null; }
            public static System.Drawing.Pen OliveDrab { get => throw null; }
            public static System.Drawing.Pen Orange { get => throw null; }
            public static System.Drawing.Pen OrangeRed { get => throw null; }
            public static System.Drawing.Pen Orchid { get => throw null; }
            public static System.Drawing.Pen PaleGoldenrod { get => throw null; }
            public static System.Drawing.Pen PaleGreen { get => throw null; }
            public static System.Drawing.Pen PaleTurquoise { get => throw null; }
            public static System.Drawing.Pen PaleVioletRed { get => throw null; }
            public static System.Drawing.Pen PapayaWhip { get => throw null; }
            public static System.Drawing.Pen PeachPuff { get => throw null; }
            public static System.Drawing.Pen Peru { get => throw null; }
            public static System.Drawing.Pen Pink { get => throw null; }
            public static System.Drawing.Pen Plum { get => throw null; }
            public static System.Drawing.Pen PowderBlue { get => throw null; }
            public static System.Drawing.Pen Purple { get => throw null; }
            public static System.Drawing.Pen Red { get => throw null; }
            public static System.Drawing.Pen RosyBrown { get => throw null; }
            public static System.Drawing.Pen RoyalBlue { get => throw null; }
            public static System.Drawing.Pen SaddleBrown { get => throw null; }
            public static System.Drawing.Pen Salmon { get => throw null; }
            public static System.Drawing.Pen SandyBrown { get => throw null; }
            public static System.Drawing.Pen SeaGreen { get => throw null; }
            public static System.Drawing.Pen SeaShell { get => throw null; }
            public static System.Drawing.Pen Sienna { get => throw null; }
            public static System.Drawing.Pen Silver { get => throw null; }
            public static System.Drawing.Pen SkyBlue { get => throw null; }
            public static System.Drawing.Pen SlateBlue { get => throw null; }
            public static System.Drawing.Pen SlateGray { get => throw null; }
            public static System.Drawing.Pen Snow { get => throw null; }
            public static System.Drawing.Pen SpringGreen { get => throw null; }
            public static System.Drawing.Pen SteelBlue { get => throw null; }
            public static System.Drawing.Pen Tan { get => throw null; }
            public static System.Drawing.Pen Teal { get => throw null; }
            public static System.Drawing.Pen Thistle { get => throw null; }
            public static System.Drawing.Pen Tomato { get => throw null; }
            public static System.Drawing.Pen Transparent { get => throw null; }
            public static System.Drawing.Pen Turquoise { get => throw null; }
            public static System.Drawing.Pen Violet { get => throw null; }
            public static System.Drawing.Pen Wheat { get => throw null; }
            public static System.Drawing.Pen White { get => throw null; }
            public static System.Drawing.Pen WhiteSmoke { get => throw null; }
            public static System.Drawing.Pen Yellow { get => throw null; }
            public static System.Drawing.Pen YellowGreen { get => throw null; }
        }

        // Generated from `System.Drawing.Region` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class Region : System.MarshalByRefObject, System.IDisposable
        {
            public System.Drawing.Region Clone() => throw null;
            public void Complement(System.Drawing.Region region) => throw null;
            public void Complement(System.Drawing.RectangleF rect) => throw null;
            public void Complement(System.Drawing.Rectangle rect) => throw null;
            public void Complement(System.Drawing.Drawing2D.GraphicsPath path) => throw null;
            public void Dispose() => throw null;
            public bool Equals(System.Drawing.Region region, System.Drawing.Graphics g) => throw null;
            public void Exclude(System.Drawing.Region region) => throw null;
            public void Exclude(System.Drawing.RectangleF rect) => throw null;
            public void Exclude(System.Drawing.Rectangle rect) => throw null;
            public void Exclude(System.Drawing.Drawing2D.GraphicsPath path) => throw null;
            public static System.Drawing.Region FromHrgn(System.IntPtr hrgn) => throw null;
            public System.Drawing.RectangleF GetBounds(System.Drawing.Graphics g) => throw null;
            public System.IntPtr GetHrgn(System.Drawing.Graphics g) => throw null;
            public System.Drawing.Drawing2D.RegionData GetRegionData() => throw null;
            public System.Drawing.RectangleF[] GetRegionScans(System.Drawing.Drawing2D.Matrix matrix) => throw null;
            public void Intersect(System.Drawing.Region region) => throw null;
            public void Intersect(System.Drawing.RectangleF rect) => throw null;
            public void Intersect(System.Drawing.Rectangle rect) => throw null;
            public void Intersect(System.Drawing.Drawing2D.GraphicsPath path) => throw null;
            public bool IsEmpty(System.Drawing.Graphics g) => throw null;
            public bool IsInfinite(System.Drawing.Graphics g) => throw null;
            public bool IsVisible(int x, int y, int width, int height, System.Drawing.Graphics g) => throw null;
            public bool IsVisible(int x, int y, int width, int height) => throw null;
            public bool IsVisible(int x, int y, System.Drawing.Graphics g) => throw null;
            public bool IsVisible(float x, float y, float width, float height, System.Drawing.Graphics g) => throw null;
            public bool IsVisible(float x, float y, float width, float height) => throw null;
            public bool IsVisible(float x, float y, System.Drawing.Graphics g) => throw null;
            public bool IsVisible(float x, float y) => throw null;
            public bool IsVisible(System.Drawing.RectangleF rect, System.Drawing.Graphics g) => throw null;
            public bool IsVisible(System.Drawing.RectangleF rect) => throw null;
            public bool IsVisible(System.Drawing.Rectangle rect, System.Drawing.Graphics g) => throw null;
            public bool IsVisible(System.Drawing.Rectangle rect) => throw null;
            public bool IsVisible(System.Drawing.PointF point, System.Drawing.Graphics g) => throw null;
            public bool IsVisible(System.Drawing.PointF point) => throw null;
            public bool IsVisible(System.Drawing.Point point, System.Drawing.Graphics g) => throw null;
            public bool IsVisible(System.Drawing.Point point) => throw null;
            public void MakeEmpty() => throw null;
            public void MakeInfinite() => throw null;
            public Region(System.Drawing.RectangleF rect) => throw null;
            public Region(System.Drawing.Rectangle rect) => throw null;
            public Region(System.Drawing.Drawing2D.RegionData rgnData) => throw null;
            public Region(System.Drawing.Drawing2D.GraphicsPath path) => throw null;
            public Region() => throw null;
            public void ReleaseHrgn(System.IntPtr regionHandle) => throw null;
            public void Transform(System.Drawing.Drawing2D.Matrix matrix) => throw null;
            public void Translate(int dx, int dy) => throw null;
            public void Translate(float dx, float dy) => throw null;
            public void Union(System.Drawing.Region region) => throw null;
            public void Union(System.Drawing.RectangleF rect) => throw null;
            public void Union(System.Drawing.Rectangle rect) => throw null;
            public void Union(System.Drawing.Drawing2D.GraphicsPath path) => throw null;
            public void Xor(System.Drawing.Region region) => throw null;
            public void Xor(System.Drawing.RectangleF rect) => throw null;
            public void Xor(System.Drawing.Rectangle rect) => throw null;
            public void Xor(System.Drawing.Drawing2D.GraphicsPath path) => throw null;
            // ERR: Stub generator didn't handle member: ~Region
        }

        // Generated from `System.Drawing.RotateFlipType` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public enum RotateFlipType
        {
            Rotate180FlipNone,
            Rotate180FlipX,
            Rotate180FlipXY,
            Rotate180FlipY,
            Rotate270FlipNone,
            Rotate270FlipX,
            Rotate270FlipXY,
            Rotate270FlipY,
            Rotate90FlipNone,
            Rotate90FlipX,
            Rotate90FlipXY,
            Rotate90FlipY,
            RotateNoneFlipNone,
            RotateNoneFlipX,
            RotateNoneFlipXY,
            RotateNoneFlipY,
        }

        // Generated from `System.Drawing.SolidBrush` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SolidBrush : System.Drawing.Brush
        {
            public override object Clone() => throw null;
            public System.Drawing.Color Color { get => throw null; set => throw null; }
            protected override void Dispose(bool disposing) => throw null;
            public SolidBrush(System.Drawing.Color color) => throw null;
        }

        // Generated from `System.Drawing.StringAlignment` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public enum StringAlignment
        {
            Center,
            Far,
            Near,
        }

        // Generated from `System.Drawing.StringDigitSubstitute` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public enum StringDigitSubstitute
        {
            National,
            None,
            Traditional,
            User,
        }

        // Generated from `System.Drawing.StringFormat` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class StringFormat : System.MarshalByRefObject, System.IDisposable, System.ICloneable
        {
            public System.Drawing.StringAlignment Alignment { get => throw null; set => throw null; }
            public object Clone() => throw null;
            public int DigitSubstitutionLanguage { get => throw null; }
            public System.Drawing.StringDigitSubstitute DigitSubstitutionMethod { get => throw null; }
            public void Dispose() => throw null;
            public System.Drawing.StringFormatFlags FormatFlags { get => throw null; set => throw null; }
            public static System.Drawing.StringFormat GenericDefault { get => throw null; }
            public static System.Drawing.StringFormat GenericTypographic { get => throw null; }
            public float[] GetTabStops(out float firstTabOffset) => throw null;
            public System.Drawing.Text.HotkeyPrefix HotkeyPrefix { get => throw null; set => throw null; }
            public System.Drawing.StringAlignment LineAlignment { get => throw null; set => throw null; }
            public void SetDigitSubstitution(int language, System.Drawing.StringDigitSubstitute substitute) => throw null;
            public void SetMeasurableCharacterRanges(System.Drawing.CharacterRange[] ranges) => throw null;
            public void SetTabStops(float firstTabOffset, float[] tabStops) => throw null;
            public StringFormat(System.Drawing.StringFormatFlags options, int language) => throw null;
            public StringFormat(System.Drawing.StringFormatFlags options) => throw null;
            public StringFormat(System.Drawing.StringFormat format) => throw null;
            public StringFormat() => throw null;
            public override string ToString() => throw null;
            public System.Drawing.StringTrimming Trimming { get => throw null; set => throw null; }
            // ERR: Stub generator didn't handle member: ~StringFormat
        }

        // Generated from `System.Drawing.StringFormatFlags` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        [System.Flags]
        public enum StringFormatFlags
        {
            DirectionRightToLeft,
            DirectionVertical,
            DisplayFormatControl,
            FitBlackBox,
            LineLimit,
            MeasureTrailingSpaces,
            NoClip,
            NoFontFallback,
            NoWrap,
        }

        // Generated from `System.Drawing.StringTrimming` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public enum StringTrimming
        {
            Character,
            EllipsisCharacter,
            EllipsisPath,
            EllipsisWord,
            None,
            Word,
        }

        // Generated from `System.Drawing.StringUnit` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public enum StringUnit
        {
            Display,
            Document,
            Em,
            Inch,
            Millimeter,
            Pixel,
            Point,
            World,
        }

        // Generated from `System.Drawing.SystemBrushes` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public static class SystemBrushes
        {
            public static System.Drawing.Brush ActiveBorder { get => throw null; }
            public static System.Drawing.Brush ActiveCaption { get => throw null; }
            public static System.Drawing.Brush ActiveCaptionText { get => throw null; }
            public static System.Drawing.Brush AppWorkspace { get => throw null; }
            public static System.Drawing.Brush ButtonFace { get => throw null; }
            public static System.Drawing.Brush ButtonHighlight { get => throw null; }
            public static System.Drawing.Brush ButtonShadow { get => throw null; }
            public static System.Drawing.Brush Control { get => throw null; }
            public static System.Drawing.Brush ControlDark { get => throw null; }
            public static System.Drawing.Brush ControlDarkDark { get => throw null; }
            public static System.Drawing.Brush ControlLight { get => throw null; }
            public static System.Drawing.Brush ControlLightLight { get => throw null; }
            public static System.Drawing.Brush ControlText { get => throw null; }
            public static System.Drawing.Brush Desktop { get => throw null; }
            public static System.Drawing.Brush FromSystemColor(System.Drawing.Color c) => throw null;
            public static System.Drawing.Brush GradientActiveCaption { get => throw null; }
            public static System.Drawing.Brush GradientInactiveCaption { get => throw null; }
            public static System.Drawing.Brush GrayText { get => throw null; }
            public static System.Drawing.Brush Highlight { get => throw null; }
            public static System.Drawing.Brush HighlightText { get => throw null; }
            public static System.Drawing.Brush HotTrack { get => throw null; }
            public static System.Drawing.Brush InactiveBorder { get => throw null; }
            public static System.Drawing.Brush InactiveCaption { get => throw null; }
            public static System.Drawing.Brush InactiveCaptionText { get => throw null; }
            public static System.Drawing.Brush Info { get => throw null; }
            public static System.Drawing.Brush InfoText { get => throw null; }
            public static System.Drawing.Brush Menu { get => throw null; }
            public static System.Drawing.Brush MenuBar { get => throw null; }
            public static System.Drawing.Brush MenuHighlight { get => throw null; }
            public static System.Drawing.Brush MenuText { get => throw null; }
            public static System.Drawing.Brush ScrollBar { get => throw null; }
            public static System.Drawing.Brush Window { get => throw null; }
            public static System.Drawing.Brush WindowFrame { get => throw null; }
            public static System.Drawing.Brush WindowText { get => throw null; }
        }

        // Generated from `System.Drawing.SystemFonts` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public static class SystemFonts
        {
            public static System.Drawing.Font CaptionFont { get => throw null; }
            public static System.Drawing.Font DefaultFont { get => throw null; }
            public static System.Drawing.Font DialogFont { get => throw null; }
            public static System.Drawing.Font GetFontByName(string systemFontName) => throw null;
            public static System.Drawing.Font IconTitleFont { get => throw null; }
            public static System.Drawing.Font MenuFont { get => throw null; }
            public static System.Drawing.Font MessageBoxFont { get => throw null; }
            public static System.Drawing.Font SmallCaptionFont { get => throw null; }
            public static System.Drawing.Font StatusFont { get => throw null; }
        }

        // Generated from `System.Drawing.SystemIcons` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public static class SystemIcons
        {
            public static System.Drawing.Icon Application { get => throw null; }
            public static System.Drawing.Icon Asterisk { get => throw null; }
            public static System.Drawing.Icon Error { get => throw null; }
            public static System.Drawing.Icon Exclamation { get => throw null; }
            public static System.Drawing.Icon Hand { get => throw null; }
            public static System.Drawing.Icon Information { get => throw null; }
            public static System.Drawing.Icon Question { get => throw null; }
            public static System.Drawing.Icon Shield { get => throw null; }
            public static System.Drawing.Icon Warning { get => throw null; }
            public static System.Drawing.Icon WinLogo { get => throw null; }
        }

        // Generated from `System.Drawing.SystemPens` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public static class SystemPens
        {
            public static System.Drawing.Pen ActiveBorder { get => throw null; }
            public static System.Drawing.Pen ActiveCaption { get => throw null; }
            public static System.Drawing.Pen ActiveCaptionText { get => throw null; }
            public static System.Drawing.Pen AppWorkspace { get => throw null; }
            public static System.Drawing.Pen ButtonFace { get => throw null; }
            public static System.Drawing.Pen ButtonHighlight { get => throw null; }
            public static System.Drawing.Pen ButtonShadow { get => throw null; }
            public static System.Drawing.Pen Control { get => throw null; }
            public static System.Drawing.Pen ControlDark { get => throw null; }
            public static System.Drawing.Pen ControlDarkDark { get => throw null; }
            public static System.Drawing.Pen ControlLight { get => throw null; }
            public static System.Drawing.Pen ControlLightLight { get => throw null; }
            public static System.Drawing.Pen ControlText { get => throw null; }
            public static System.Drawing.Pen Desktop { get => throw null; }
            public static System.Drawing.Pen FromSystemColor(System.Drawing.Color c) => throw null;
            public static System.Drawing.Pen GradientActiveCaption { get => throw null; }
            public static System.Drawing.Pen GradientInactiveCaption { get => throw null; }
            public static System.Drawing.Pen GrayText { get => throw null; }
            public static System.Drawing.Pen Highlight { get => throw null; }
            public static System.Drawing.Pen HighlightText { get => throw null; }
            public static System.Drawing.Pen HotTrack { get => throw null; }
            public static System.Drawing.Pen InactiveBorder { get => throw null; }
            public static System.Drawing.Pen InactiveCaption { get => throw null; }
            public static System.Drawing.Pen InactiveCaptionText { get => throw null; }
            public static System.Drawing.Pen Info { get => throw null; }
            public static System.Drawing.Pen InfoText { get => throw null; }
            public static System.Drawing.Pen Menu { get => throw null; }
            public static System.Drawing.Pen MenuBar { get => throw null; }
            public static System.Drawing.Pen MenuHighlight { get => throw null; }
            public static System.Drawing.Pen MenuText { get => throw null; }
            public static System.Drawing.Pen ScrollBar { get => throw null; }
            public static System.Drawing.Pen Window { get => throw null; }
            public static System.Drawing.Pen WindowFrame { get => throw null; }
            public static System.Drawing.Pen WindowText { get => throw null; }
        }

        // Generated from `System.Drawing.TextureBrush` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class TextureBrush : System.Drawing.Brush
        {
            public override object Clone() => throw null;
            public System.Drawing.Image Image { get => throw null; }
            public void MultiplyTransform(System.Drawing.Drawing2D.Matrix matrix, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
            public void MultiplyTransform(System.Drawing.Drawing2D.Matrix matrix) => throw null;
            public void ResetTransform() => throw null;
            public void RotateTransform(float angle, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
            public void RotateTransform(float angle) => throw null;
            public void ScaleTransform(float sx, float sy, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
            public void ScaleTransform(float sx, float sy) => throw null;
            public TextureBrush(System.Drawing.Image image, System.Drawing.RectangleF dstRect, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public TextureBrush(System.Drawing.Image image, System.Drawing.RectangleF dstRect) => throw null;
            public TextureBrush(System.Drawing.Image image, System.Drawing.Rectangle dstRect, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public TextureBrush(System.Drawing.Image image, System.Drawing.Rectangle dstRect) => throw null;
            public TextureBrush(System.Drawing.Image image, System.Drawing.Drawing2D.WrapMode wrapMode, System.Drawing.RectangleF dstRect) => throw null;
            public TextureBrush(System.Drawing.Image image, System.Drawing.Drawing2D.WrapMode wrapMode, System.Drawing.Rectangle dstRect) => throw null;
            public TextureBrush(System.Drawing.Image image, System.Drawing.Drawing2D.WrapMode wrapMode) => throw null;
            public TextureBrush(System.Drawing.Image bitmap) => throw null;
            public System.Drawing.Drawing2D.Matrix Transform { get => throw null; set => throw null; }
            public void TranslateTransform(float dx, float dy, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
            public void TranslateTransform(float dx, float dy) => throw null;
            public System.Drawing.Drawing2D.WrapMode WrapMode { get => throw null; set => throw null; }
        }

        // Generated from `System.Drawing.ToolboxBitmapAttribute` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ToolboxBitmapAttribute : System.Attribute
        {
            public static System.Drawing.ToolboxBitmapAttribute Default;
            public override bool Equals(object value) => throw null;
            public override int GetHashCode() => throw null;
            public System.Drawing.Image GetImage(object component, bool large) => throw null;
            public System.Drawing.Image GetImage(object component) => throw null;
            public System.Drawing.Image GetImage(System.Type type, string imgName, bool large) => throw null;
            public System.Drawing.Image GetImage(System.Type type, bool large) => throw null;
            public System.Drawing.Image GetImage(System.Type type) => throw null;
            public static System.Drawing.Image GetImageFromResource(System.Type t, string imageName, bool large) => throw null;
            public ToolboxBitmapAttribute(string imageFile) => throw null;
            public ToolboxBitmapAttribute(System.Type t, string name) => throw null;
            public ToolboxBitmapAttribute(System.Type t) => throw null;
        }

        namespace Design
        {
            // Generated from `System.Drawing.Design.CategoryNameCollection` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class CategoryNameCollection : System.Collections.ReadOnlyCollectionBase
            {
                public CategoryNameCollection(string[] value) => throw null;
                public CategoryNameCollection(System.Drawing.Design.CategoryNameCollection value) => throw null;
                public bool Contains(string value) => throw null;
                public void CopyTo(string[] array, int index) => throw null;
                public int IndexOf(string value) => throw null;
                public string this[int index] { get => throw null; }
            }

        }
        namespace Drawing2D
        {
            // Generated from `System.Drawing.Drawing2D.AdjustableArrowCap` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class AdjustableArrowCap : System.Drawing.Drawing2D.CustomLineCap
            {
                public AdjustableArrowCap(float width, float height, bool isFilled) : base(default(System.Drawing.Drawing2D.GraphicsPath), default(System.Drawing.Drawing2D.GraphicsPath)) => throw null;
                public AdjustableArrowCap(float width, float height) : base(default(System.Drawing.Drawing2D.GraphicsPath), default(System.Drawing.Drawing2D.GraphicsPath)) => throw null;
                public bool Filled { get => throw null; set => throw null; }
                public float Height { get => throw null; set => throw null; }
                public float MiddleInset { get => throw null; set => throw null; }
                public float Width { get => throw null; set => throw null; }
            }

            // Generated from `System.Drawing.Drawing2D.Blend` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class Blend
            {
                public Blend(int count) => throw null;
                public Blend() => throw null;
                public float[] Factors { get => throw null; set => throw null; }
                public float[] Positions { get => throw null; set => throw null; }
            }

            // Generated from `System.Drawing.Drawing2D.ColorBlend` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class ColorBlend
            {
                public ColorBlend(int count) => throw null;
                public ColorBlend() => throw null;
                public System.Drawing.Color[] Colors { get => throw null; set => throw null; }
                public float[] Positions { get => throw null; set => throw null; }
            }

            // Generated from `System.Drawing.Drawing2D.CombineMode` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum CombineMode
            {
                Complement,
                Exclude,
                Intersect,
                Replace,
                Union,
                Xor,
            }

            // Generated from `System.Drawing.Drawing2D.CompositingMode` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum CompositingMode
            {
                SourceCopy,
                SourceOver,
            }

            // Generated from `System.Drawing.Drawing2D.CompositingQuality` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum CompositingQuality
            {
                AssumeLinear,
                Default,
                GammaCorrected,
                HighQuality,
                HighSpeed,
                Invalid,
            }

            // Generated from `System.Drawing.Drawing2D.CoordinateSpace` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum CoordinateSpace
            {
                Device,
                Page,
                World,
            }

            // Generated from `System.Drawing.Drawing2D.CustomLineCap` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class CustomLineCap : System.MarshalByRefObject, System.IDisposable, System.ICloneable
            {
                public System.Drawing.Drawing2D.LineCap BaseCap { get => throw null; set => throw null; }
                public float BaseInset { get => throw null; set => throw null; }
                public object Clone() => throw null;
                public CustomLineCap(System.Drawing.Drawing2D.GraphicsPath fillPath, System.Drawing.Drawing2D.GraphicsPath strokePath, System.Drawing.Drawing2D.LineCap baseCap, float baseInset) => throw null;
                public CustomLineCap(System.Drawing.Drawing2D.GraphicsPath fillPath, System.Drawing.Drawing2D.GraphicsPath strokePath, System.Drawing.Drawing2D.LineCap baseCap) => throw null;
                public CustomLineCap(System.Drawing.Drawing2D.GraphicsPath fillPath, System.Drawing.Drawing2D.GraphicsPath strokePath) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public void GetStrokeCaps(out System.Drawing.Drawing2D.LineCap startCap, out System.Drawing.Drawing2D.LineCap endCap) => throw null;
                public void SetStrokeCaps(System.Drawing.Drawing2D.LineCap startCap, System.Drawing.Drawing2D.LineCap endCap) => throw null;
                public System.Drawing.Drawing2D.LineJoin StrokeJoin { get => throw null; set => throw null; }
                public float WidthScale { get => throw null; set => throw null; }
                // ERR: Stub generator didn't handle member: ~CustomLineCap
            }

            // Generated from `System.Drawing.Drawing2D.DashCap` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum DashCap
            {
                Flat,
                Round,
                Triangle,
            }

            // Generated from `System.Drawing.Drawing2D.DashStyle` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum DashStyle
            {
                Custom,
                Dash,
                DashDot,
                DashDotDot,
                Dot,
                Solid,
            }

            // Generated from `System.Drawing.Drawing2D.FillMode` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum FillMode
            {
                Alternate,
                Winding,
            }

            // Generated from `System.Drawing.Drawing2D.FlushIntention` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum FlushIntention
            {
                Flush,
                Sync,
            }

            // Generated from `System.Drawing.Drawing2D.GraphicsContainer` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class GraphicsContainer : System.MarshalByRefObject
            {
            }

            // Generated from `System.Drawing.Drawing2D.GraphicsPath` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class GraphicsPath : System.MarshalByRefObject, System.IDisposable, System.ICloneable
            {
                public void AddArc(int x, int y, int width, int height, float startAngle, float sweepAngle) => throw null;
                public void AddArc(float x, float y, float width, float height, float startAngle, float sweepAngle) => throw null;
                public void AddArc(System.Drawing.RectangleF rect, float startAngle, float sweepAngle) => throw null;
                public void AddArc(System.Drawing.Rectangle rect, float startAngle, float sweepAngle) => throw null;
                public void AddBezier(int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4) => throw null;
                public void AddBezier(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) => throw null;
                public void AddBezier(System.Drawing.PointF pt1, System.Drawing.PointF pt2, System.Drawing.PointF pt3, System.Drawing.PointF pt4) => throw null;
                public void AddBezier(System.Drawing.Point pt1, System.Drawing.Point pt2, System.Drawing.Point pt3, System.Drawing.Point pt4) => throw null;
                public void AddBeziers(params System.Drawing.Point[] points) => throw null;
                public void AddBeziers(System.Drawing.PointF[] points) => throw null;
                public void AddClosedCurve(System.Drawing.Point[] points, float tension) => throw null;
                public void AddClosedCurve(System.Drawing.Point[] points) => throw null;
                public void AddClosedCurve(System.Drawing.PointF[] points, float tension) => throw null;
                public void AddClosedCurve(System.Drawing.PointF[] points) => throw null;
                public void AddCurve(System.Drawing.Point[] points, int offset, int numberOfSegments, float tension) => throw null;
                public void AddCurve(System.Drawing.Point[] points, float tension) => throw null;
                public void AddCurve(System.Drawing.Point[] points) => throw null;
                public void AddCurve(System.Drawing.PointF[] points, int offset, int numberOfSegments, float tension) => throw null;
                public void AddCurve(System.Drawing.PointF[] points, float tension) => throw null;
                public void AddCurve(System.Drawing.PointF[] points) => throw null;
                public void AddEllipse(int x, int y, int width, int height) => throw null;
                public void AddEllipse(float x, float y, float width, float height) => throw null;
                public void AddEllipse(System.Drawing.RectangleF rect) => throw null;
                public void AddEllipse(System.Drawing.Rectangle rect) => throw null;
                public void AddLine(int x1, int y1, int x2, int y2) => throw null;
                public void AddLine(float x1, float y1, float x2, float y2) => throw null;
                public void AddLine(System.Drawing.PointF pt1, System.Drawing.PointF pt2) => throw null;
                public void AddLine(System.Drawing.Point pt1, System.Drawing.Point pt2) => throw null;
                public void AddLines(System.Drawing.Point[] points) => throw null;
                public void AddLines(System.Drawing.PointF[] points) => throw null;
                public void AddPath(System.Drawing.Drawing2D.GraphicsPath addingPath, bool connect) => throw null;
                public void AddPie(int x, int y, int width, int height, float startAngle, float sweepAngle) => throw null;
                public void AddPie(float x, float y, float width, float height, float startAngle, float sweepAngle) => throw null;
                public void AddPie(System.Drawing.Rectangle rect, float startAngle, float sweepAngle) => throw null;
                public void AddPolygon(System.Drawing.Point[] points) => throw null;
                public void AddPolygon(System.Drawing.PointF[] points) => throw null;
                public void AddRectangle(System.Drawing.RectangleF rect) => throw null;
                public void AddRectangle(System.Drawing.Rectangle rect) => throw null;
                public void AddRectangles(System.Drawing.Rectangle[] rects) => throw null;
                public void AddRectangles(System.Drawing.RectangleF[] rects) => throw null;
                public void AddString(string s, System.Drawing.FontFamily family, int style, float emSize, System.Drawing.RectangleF layoutRect, System.Drawing.StringFormat format) => throw null;
                public void AddString(string s, System.Drawing.FontFamily family, int style, float emSize, System.Drawing.Rectangle layoutRect, System.Drawing.StringFormat format) => throw null;
                public void AddString(string s, System.Drawing.FontFamily family, int style, float emSize, System.Drawing.PointF origin, System.Drawing.StringFormat format) => throw null;
                public void AddString(string s, System.Drawing.FontFamily family, int style, float emSize, System.Drawing.Point origin, System.Drawing.StringFormat format) => throw null;
                public void ClearMarkers() => throw null;
                public object Clone() => throw null;
                public void CloseAllFigures() => throw null;
                public void CloseFigure() => throw null;
                public void Dispose() => throw null;
                public System.Drawing.Drawing2D.FillMode FillMode { get => throw null; set => throw null; }
                public void Flatten(System.Drawing.Drawing2D.Matrix matrix, float flatness) => throw null;
                public void Flatten(System.Drawing.Drawing2D.Matrix matrix) => throw null;
                public void Flatten() => throw null;
                public System.Drawing.RectangleF GetBounds(System.Drawing.Drawing2D.Matrix matrix, System.Drawing.Pen pen) => throw null;
                public System.Drawing.RectangleF GetBounds(System.Drawing.Drawing2D.Matrix matrix) => throw null;
                public System.Drawing.RectangleF GetBounds() => throw null;
                public System.Drawing.PointF GetLastPoint() => throw null;
                public GraphicsPath(System.Drawing.Point[] pts, System.Byte[] types, System.Drawing.Drawing2D.FillMode fillMode) => throw null;
                public GraphicsPath(System.Drawing.Point[] pts, System.Byte[] types) => throw null;
                public GraphicsPath(System.Drawing.PointF[] pts, System.Byte[] types, System.Drawing.Drawing2D.FillMode fillMode) => throw null;
                public GraphicsPath(System.Drawing.PointF[] pts, System.Byte[] types) => throw null;
                public GraphicsPath(System.Drawing.Drawing2D.FillMode fillMode) => throw null;
                public GraphicsPath() => throw null;
                public bool IsOutlineVisible(int x, int y, System.Drawing.Pen pen, System.Drawing.Graphics graphics) => throw null;
                public bool IsOutlineVisible(int x, int y, System.Drawing.Pen pen) => throw null;
                public bool IsOutlineVisible(float x, float y, System.Drawing.Pen pen, System.Drawing.Graphics graphics) => throw null;
                public bool IsOutlineVisible(float x, float y, System.Drawing.Pen pen) => throw null;
                public bool IsOutlineVisible(System.Drawing.PointF pt, System.Drawing.Pen pen, System.Drawing.Graphics graphics) => throw null;
                public bool IsOutlineVisible(System.Drawing.PointF point, System.Drawing.Pen pen) => throw null;
                public bool IsOutlineVisible(System.Drawing.Point pt, System.Drawing.Pen pen, System.Drawing.Graphics graphics) => throw null;
                public bool IsOutlineVisible(System.Drawing.Point point, System.Drawing.Pen pen) => throw null;
                public bool IsVisible(int x, int y, System.Drawing.Graphics graphics) => throw null;
                public bool IsVisible(int x, int y) => throw null;
                public bool IsVisible(float x, float y, System.Drawing.Graphics graphics) => throw null;
                public bool IsVisible(float x, float y) => throw null;
                public bool IsVisible(System.Drawing.PointF pt, System.Drawing.Graphics graphics) => throw null;
                public bool IsVisible(System.Drawing.PointF point) => throw null;
                public bool IsVisible(System.Drawing.Point pt, System.Drawing.Graphics graphics) => throw null;
                public bool IsVisible(System.Drawing.Point point) => throw null;
                public System.Drawing.Drawing2D.PathData PathData { get => throw null; }
                public System.Drawing.PointF[] PathPoints { get => throw null; }
                public System.Byte[] PathTypes { get => throw null; }
                public int PointCount { get => throw null; }
                public void Reset() => throw null;
                public void Reverse() => throw null;
                public void SetMarkers() => throw null;
                public void StartFigure() => throw null;
                public void Transform(System.Drawing.Drawing2D.Matrix matrix) => throw null;
                public void Warp(System.Drawing.PointF[] destPoints, System.Drawing.RectangleF srcRect, System.Drawing.Drawing2D.Matrix matrix, System.Drawing.Drawing2D.WarpMode warpMode, float flatness) => throw null;
                public void Warp(System.Drawing.PointF[] destPoints, System.Drawing.RectangleF srcRect, System.Drawing.Drawing2D.Matrix matrix, System.Drawing.Drawing2D.WarpMode warpMode) => throw null;
                public void Warp(System.Drawing.PointF[] destPoints, System.Drawing.RectangleF srcRect, System.Drawing.Drawing2D.Matrix matrix) => throw null;
                public void Warp(System.Drawing.PointF[] destPoints, System.Drawing.RectangleF srcRect) => throw null;
                public void Widen(System.Drawing.Pen pen, System.Drawing.Drawing2D.Matrix matrix, float flatness) => throw null;
                public void Widen(System.Drawing.Pen pen, System.Drawing.Drawing2D.Matrix matrix) => throw null;
                public void Widen(System.Drawing.Pen pen) => throw null;
                // ERR: Stub generator didn't handle member: ~GraphicsPath
            }

            // Generated from `System.Drawing.Drawing2D.GraphicsPathIterator` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class GraphicsPathIterator : System.MarshalByRefObject, System.IDisposable
            {
                public int CopyData(ref System.Drawing.PointF[] points, ref System.Byte[] types, int startIndex, int endIndex) => throw null;
                public int Count { get => throw null; }
                public void Dispose() => throw null;
                public int Enumerate(ref System.Drawing.PointF[] points, ref System.Byte[] types) => throw null;
                public GraphicsPathIterator(System.Drawing.Drawing2D.GraphicsPath path) => throw null;
                public bool HasCurve() => throw null;
                public int NextMarker(out int startIndex, out int endIndex) => throw null;
                public int NextMarker(System.Drawing.Drawing2D.GraphicsPath path) => throw null;
                public int NextPathType(out System.Byte pathType, out int startIndex, out int endIndex) => throw null;
                public int NextSubpath(out int startIndex, out int endIndex, out bool isClosed) => throw null;
                public int NextSubpath(System.Drawing.Drawing2D.GraphicsPath path, out bool isClosed) => throw null;
                public void Rewind() => throw null;
                public int SubpathCount { get => throw null; }
                // ERR: Stub generator didn't handle member: ~GraphicsPathIterator
            }

            // Generated from `System.Drawing.Drawing2D.GraphicsState` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class GraphicsState : System.MarshalByRefObject
            {
            }

            // Generated from `System.Drawing.Drawing2D.HatchBrush` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class HatchBrush : System.Drawing.Brush
            {
                public System.Drawing.Color BackgroundColor { get => throw null; }
                public override object Clone() => throw null;
                public System.Drawing.Color ForegroundColor { get => throw null; }
                public HatchBrush(System.Drawing.Drawing2D.HatchStyle hatchstyle, System.Drawing.Color foreColor, System.Drawing.Color backColor) => throw null;
                public HatchBrush(System.Drawing.Drawing2D.HatchStyle hatchstyle, System.Drawing.Color foreColor) => throw null;
                public System.Drawing.Drawing2D.HatchStyle HatchStyle { get => throw null; }
            }

            // Generated from `System.Drawing.Drawing2D.HatchStyle` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum HatchStyle
            {
                BackwardDiagonal,
                Cross,
                DarkDownwardDiagonal,
                DarkHorizontal,
                DarkUpwardDiagonal,
                DarkVertical,
                DashedDownwardDiagonal,
                DashedHorizontal,
                DashedUpwardDiagonal,
                DashedVertical,
                DiagonalBrick,
                DiagonalCross,
                Divot,
                DottedDiamond,
                DottedGrid,
                ForwardDiagonal,
                Horizontal,
                HorizontalBrick,
                LargeCheckerBoard,
                LargeConfetti,
                LargeGrid,
                LightDownwardDiagonal,
                LightHorizontal,
                LightUpwardDiagonal,
                LightVertical,
                Max,
                Min,
                NarrowHorizontal,
                NarrowVertical,
                OutlinedDiamond,
                Percent05,
                Percent10,
                Percent20,
                Percent25,
                Percent30,
                Percent40,
                Percent50,
                Percent60,
                Percent70,
                Percent75,
                Percent80,
                Percent90,
                Plaid,
                Shingle,
                SmallCheckerBoard,
                SmallConfetti,
                SmallGrid,
                SolidDiamond,
                Sphere,
                Trellis,
                Vertical,
                Wave,
                Weave,
                WideDownwardDiagonal,
                WideUpwardDiagonal,
                ZigZag,
            }

            // Generated from `System.Drawing.Drawing2D.InterpolationMode` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum InterpolationMode
            {
                Bicubic,
                Bilinear,
                Default,
                High,
                HighQualityBicubic,
                HighQualityBilinear,
                Invalid,
                Low,
                NearestNeighbor,
            }

            // Generated from `System.Drawing.Drawing2D.LineCap` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum LineCap
            {
                AnchorMask,
                ArrowAnchor,
                Custom,
                DiamondAnchor,
                Flat,
                NoAnchor,
                Round,
                RoundAnchor,
                Square,
                SquareAnchor,
                Triangle,
            }

            // Generated from `System.Drawing.Drawing2D.LineJoin` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum LineJoin
            {
                Bevel,
                Miter,
                MiterClipped,
                Round,
            }

            // Generated from `System.Drawing.Drawing2D.LinearGradientBrush` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class LinearGradientBrush : System.Drawing.Brush
            {
                public System.Drawing.Drawing2D.Blend Blend { get => throw null; set => throw null; }
                public override object Clone() => throw null;
                public bool GammaCorrection { get => throw null; set => throw null; }
                public System.Drawing.Drawing2D.ColorBlend InterpolationColors { get => throw null; set => throw null; }
                public System.Drawing.Color[] LinearColors { get => throw null; set => throw null; }
                public LinearGradientBrush(System.Drawing.RectangleF rect, System.Drawing.Color color1, System.Drawing.Color color2, float angle, bool isAngleScaleable) => throw null;
                public LinearGradientBrush(System.Drawing.RectangleF rect, System.Drawing.Color color1, System.Drawing.Color color2, float angle) => throw null;
                public LinearGradientBrush(System.Drawing.RectangleF rect, System.Drawing.Color color1, System.Drawing.Color color2, System.Drawing.Drawing2D.LinearGradientMode linearGradientMode) => throw null;
                public LinearGradientBrush(System.Drawing.Rectangle rect, System.Drawing.Color color1, System.Drawing.Color color2, float angle, bool isAngleScaleable) => throw null;
                public LinearGradientBrush(System.Drawing.Rectangle rect, System.Drawing.Color color1, System.Drawing.Color color2, float angle) => throw null;
                public LinearGradientBrush(System.Drawing.Rectangle rect, System.Drawing.Color color1, System.Drawing.Color color2, System.Drawing.Drawing2D.LinearGradientMode linearGradientMode) => throw null;
                public LinearGradientBrush(System.Drawing.PointF point1, System.Drawing.PointF point2, System.Drawing.Color color1, System.Drawing.Color color2) => throw null;
                public LinearGradientBrush(System.Drawing.Point point1, System.Drawing.Point point2, System.Drawing.Color color1, System.Drawing.Color color2) => throw null;
                public void MultiplyTransform(System.Drawing.Drawing2D.Matrix matrix, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
                public void MultiplyTransform(System.Drawing.Drawing2D.Matrix matrix) => throw null;
                public System.Drawing.RectangleF Rectangle { get => throw null; }
                public void ResetTransform() => throw null;
                public void RotateTransform(float angle, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
                public void RotateTransform(float angle) => throw null;
                public void ScaleTransform(float sx, float sy, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
                public void ScaleTransform(float sx, float sy) => throw null;
                public void SetBlendTriangularShape(float focus, float scale) => throw null;
                public void SetBlendTriangularShape(float focus) => throw null;
                public void SetSigmaBellShape(float focus, float scale) => throw null;
                public void SetSigmaBellShape(float focus) => throw null;
                public System.Drawing.Drawing2D.Matrix Transform { get => throw null; set => throw null; }
                public void TranslateTransform(float dx, float dy, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
                public void TranslateTransform(float dx, float dy) => throw null;
                public System.Drawing.Drawing2D.WrapMode WrapMode { get => throw null; set => throw null; }
            }

            // Generated from `System.Drawing.Drawing2D.LinearGradientMode` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum LinearGradientMode
            {
                BackwardDiagonal,
                ForwardDiagonal,
                Horizontal,
                Vertical,
            }

            // Generated from `System.Drawing.Drawing2D.Matrix` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class Matrix : System.MarshalByRefObject, System.IDisposable
            {
                public System.Drawing.Drawing2D.Matrix Clone() => throw null;
                public void Dispose() => throw null;
                public float[] Elements { get => throw null; }
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public void Invert() => throw null;
                public bool IsIdentity { get => throw null; }
                public bool IsInvertible { get => throw null; }
                public Matrix(float m11, float m12, float m21, float m22, float dx, float dy) => throw null;
                public Matrix(System.Drawing.RectangleF rect, System.Drawing.PointF[] plgpts) => throw null;
                public Matrix(System.Drawing.Rectangle rect, System.Drawing.Point[] plgpts) => throw null;
                public Matrix() => throw null;
                public void Multiply(System.Drawing.Drawing2D.Matrix matrix, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
                public void Multiply(System.Drawing.Drawing2D.Matrix matrix) => throw null;
                public float OffsetX { get => throw null; }
                public float OffsetY { get => throw null; }
                public void Reset() => throw null;
                public void Rotate(float angle, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
                public void Rotate(float angle) => throw null;
                public void RotateAt(float angle, System.Drawing.PointF point, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
                public void RotateAt(float angle, System.Drawing.PointF point) => throw null;
                public void Scale(float scaleX, float scaleY, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
                public void Scale(float scaleX, float scaleY) => throw null;
                public void Shear(float shearX, float shearY, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
                public void Shear(float shearX, float shearY) => throw null;
                public void TransformPoints(System.Drawing.Point[] pts) => throw null;
                public void TransformPoints(System.Drawing.PointF[] pts) => throw null;
                public void TransformVectors(System.Drawing.Point[] pts) => throw null;
                public void TransformVectors(System.Drawing.PointF[] pts) => throw null;
                public void Translate(float offsetX, float offsetY, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
                public void Translate(float offsetX, float offsetY) => throw null;
                public void VectorTransformPoints(System.Drawing.Point[] pts) => throw null;
                // ERR: Stub generator didn't handle member: ~Matrix
            }

            // Generated from `System.Drawing.Drawing2D.MatrixOrder` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum MatrixOrder
            {
                Append,
                Prepend,
            }

            // Generated from `System.Drawing.Drawing2D.PathData` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PathData
            {
                public PathData() => throw null;
                public System.Drawing.PointF[] Points { get => throw null; set => throw null; }
                public System.Byte[] Types { get => throw null; set => throw null; }
            }

            // Generated from `System.Drawing.Drawing2D.PathGradientBrush` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PathGradientBrush : System.Drawing.Brush
            {
                public System.Drawing.Drawing2D.Blend Blend { get => throw null; set => throw null; }
                public System.Drawing.Color CenterColor { get => throw null; set => throw null; }
                public System.Drawing.PointF CenterPoint { get => throw null; set => throw null; }
                public override object Clone() => throw null;
                public System.Drawing.PointF FocusScales { get => throw null; set => throw null; }
                public System.Drawing.Drawing2D.ColorBlend InterpolationColors { get => throw null; set => throw null; }
                public void MultiplyTransform(System.Drawing.Drawing2D.Matrix matrix, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
                public void MultiplyTransform(System.Drawing.Drawing2D.Matrix matrix) => throw null;
                public PathGradientBrush(System.Drawing.Point[] points, System.Drawing.Drawing2D.WrapMode wrapMode) => throw null;
                public PathGradientBrush(System.Drawing.Point[] points) => throw null;
                public PathGradientBrush(System.Drawing.PointF[] points, System.Drawing.Drawing2D.WrapMode wrapMode) => throw null;
                public PathGradientBrush(System.Drawing.PointF[] points) => throw null;
                public PathGradientBrush(System.Drawing.Drawing2D.GraphicsPath path) => throw null;
                public System.Drawing.RectangleF Rectangle { get => throw null; }
                public void ResetTransform() => throw null;
                public void RotateTransform(float angle, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
                public void RotateTransform(float angle) => throw null;
                public void ScaleTransform(float sx, float sy, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
                public void ScaleTransform(float sx, float sy) => throw null;
                public void SetBlendTriangularShape(float focus, float scale) => throw null;
                public void SetBlendTriangularShape(float focus) => throw null;
                public void SetSigmaBellShape(float focus, float scale) => throw null;
                public void SetSigmaBellShape(float focus) => throw null;
                public System.Drawing.Color[] SurroundColors { get => throw null; set => throw null; }
                public System.Drawing.Drawing2D.Matrix Transform { get => throw null; set => throw null; }
                public void TranslateTransform(float dx, float dy, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
                public void TranslateTransform(float dx, float dy) => throw null;
                public System.Drawing.Drawing2D.WrapMode WrapMode { get => throw null; set => throw null; }
            }

            // Generated from `System.Drawing.Drawing2D.PathPointType` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum PathPointType
            {
                Bezier,
                Bezier3,
                CloseSubpath,
                DashMode,
                Line,
                PathMarker,
                PathTypeMask,
                Start,
            }

            // Generated from `System.Drawing.Drawing2D.PenAlignment` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum PenAlignment
            {
                Center,
                Inset,
                Left,
                Outset,
                Right,
            }

            // Generated from `System.Drawing.Drawing2D.PenType` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum PenType
            {
                HatchFill,
                LinearGradient,
                PathGradient,
                SolidColor,
                TextureFill,
            }

            // Generated from `System.Drawing.Drawing2D.PixelOffsetMode` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum PixelOffsetMode
            {
                Default,
                Half,
                HighQuality,
                HighSpeed,
                Invalid,
                None,
            }

            // Generated from `System.Drawing.Drawing2D.QualityMode` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum QualityMode
            {
                Default,
                High,
                Invalid,
                Low,
            }

            // Generated from `System.Drawing.Drawing2D.RegionData` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class RegionData
            {
                public System.Byte[] Data { get => throw null; set => throw null; }
            }

            // Generated from `System.Drawing.Drawing2D.SmoothingMode` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum SmoothingMode
            {
                AntiAlias,
                Default,
                HighQuality,
                HighSpeed,
                Invalid,
                None,
            }

            // Generated from `System.Drawing.Drawing2D.WarpMode` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum WarpMode
            {
                Bilinear,
                Perspective,
            }

            // Generated from `System.Drawing.Drawing2D.WrapMode` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum WrapMode
            {
                Clamp,
                Tile,
                TileFlipX,
                TileFlipXY,
                TileFlipY,
            }

        }
        namespace Imaging
        {
            // Generated from `System.Drawing.Imaging.BitmapData` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class BitmapData
            {
                public BitmapData() => throw null;
                public int Height { get => throw null; set => throw null; }
                public System.Drawing.Imaging.PixelFormat PixelFormat { get => throw null; set => throw null; }
                public int Reserved { get => throw null; set => throw null; }
                public System.IntPtr Scan0 { get => throw null; set => throw null; }
                public int Stride { get => throw null; set => throw null; }
                public int Width { get => throw null; set => throw null; }
            }

            // Generated from `System.Drawing.Imaging.ColorAdjustType` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum ColorAdjustType
            {
                Any,
                Bitmap,
                Brush,
                Count,
                Default,
                Pen,
                Text,
            }

            // Generated from `System.Drawing.Imaging.ColorChannelFlag` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum ColorChannelFlag
            {
                ColorChannelC,
                ColorChannelK,
                ColorChannelLast,
                ColorChannelM,
                ColorChannelY,
            }

            // Generated from `System.Drawing.Imaging.ColorMap` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class ColorMap
            {
                public ColorMap() => throw null;
                public System.Drawing.Color NewColor { get => throw null; set => throw null; }
                public System.Drawing.Color OldColor { get => throw null; set => throw null; }
            }

            // Generated from `System.Drawing.Imaging.ColorMapType` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum ColorMapType
            {
                Brush,
                Default,
            }

            // Generated from `System.Drawing.Imaging.ColorMatrix` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class ColorMatrix
            {
                public ColorMatrix(float[][] newColorMatrix) => throw null;
                public ColorMatrix() => throw null;
                public float this[int row, int column] { get => throw null; set => throw null; }
                public float Matrix00 { get => throw null; set => throw null; }
                public float Matrix01 { get => throw null; set => throw null; }
                public float Matrix02 { get => throw null; set => throw null; }
                public float Matrix03 { get => throw null; set => throw null; }
                public float Matrix04 { get => throw null; set => throw null; }
                public float Matrix10 { get => throw null; set => throw null; }
                public float Matrix11 { get => throw null; set => throw null; }
                public float Matrix12 { get => throw null; set => throw null; }
                public float Matrix13 { get => throw null; set => throw null; }
                public float Matrix14 { get => throw null; set => throw null; }
                public float Matrix20 { get => throw null; set => throw null; }
                public float Matrix21 { get => throw null; set => throw null; }
                public float Matrix22 { get => throw null; set => throw null; }
                public float Matrix23 { get => throw null; set => throw null; }
                public float Matrix24 { get => throw null; set => throw null; }
                public float Matrix30 { get => throw null; set => throw null; }
                public float Matrix31 { get => throw null; set => throw null; }
                public float Matrix32 { get => throw null; set => throw null; }
                public float Matrix33 { get => throw null; set => throw null; }
                public float Matrix34 { get => throw null; set => throw null; }
                public float Matrix40 { get => throw null; set => throw null; }
                public float Matrix41 { get => throw null; set => throw null; }
                public float Matrix42 { get => throw null; set => throw null; }
                public float Matrix43 { get => throw null; set => throw null; }
                public float Matrix44 { get => throw null; set => throw null; }
            }

            // Generated from `System.Drawing.Imaging.ColorMatrixFlag` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum ColorMatrixFlag
            {
                AltGrays,
                Default,
                SkipGrays,
            }

            // Generated from `System.Drawing.Imaging.ColorMode` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum ColorMode
            {
                Argb32Mode,
                Argb64Mode,
            }

            // Generated from `System.Drawing.Imaging.ColorPalette` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class ColorPalette
            {
                public System.Drawing.Color[] Entries { get => throw null; }
                public int Flags { get => throw null; }
            }

            // Generated from `System.Drawing.Imaging.EmfPlusRecordType` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum EmfPlusRecordType
            {
                BeginContainer,
                BeginContainerNoParams,
                Clear,
                Comment,
                DrawArc,
                DrawBeziers,
                DrawClosedCurve,
                DrawCurve,
                DrawDriverString,
                DrawEllipse,
                DrawImage,
                DrawImagePoints,
                DrawLines,
                DrawPath,
                DrawPie,
                DrawRects,
                DrawString,
                EmfAbortPath,
                EmfAlphaBlend,
                EmfAngleArc,
                EmfArcTo,
                EmfBeginPath,
                EmfBitBlt,
                EmfChord,
                EmfCloseFigure,
                EmfColorCorrectPalette,
                EmfColorMatchToTargetW,
                EmfCreateBrushIndirect,
                EmfCreateColorSpace,
                EmfCreateColorSpaceW,
                EmfCreateDibPatternBrushPt,
                EmfCreateMonoBrush,
                EmfCreatePalette,
                EmfCreatePen,
                EmfDeleteColorSpace,
                EmfDeleteObject,
                EmfDrawEscape,
                EmfEllipse,
                EmfEndPath,
                EmfEof,
                EmfExcludeClipRect,
                EmfExtCreateFontIndirect,
                EmfExtCreatePen,
                EmfExtEscape,
                EmfExtFloodFill,
                EmfExtSelectClipRgn,
                EmfExtTextOutA,
                EmfExtTextOutW,
                EmfFillPath,
                EmfFillRgn,
                EmfFlattenPath,
                EmfForceUfiMapping,
                EmfFrameRgn,
                EmfGdiComment,
                EmfGlsBoundedRecord,
                EmfGlsRecord,
                EmfGradientFill,
                EmfHeader,
                EmfIntersectClipRect,
                EmfInvertRgn,
                EmfLineTo,
                EmfMaskBlt,
                EmfMax,
                EmfMin,
                EmfModifyWorldTransform,
                EmfMoveToEx,
                EmfNamedEscpae,
                EmfOffsetClipRgn,
                EmfPaintRgn,
                EmfPie,
                EmfPixelFormat,
                EmfPlgBlt,
                EmfPlusRecordBase,
                EmfPolyBezier,
                EmfPolyBezier16,
                EmfPolyBezierTo,
                EmfPolyBezierTo16,
                EmfPolyDraw,
                EmfPolyDraw16,
                EmfPolyLineTo,
                EmfPolyPolygon,
                EmfPolyPolygon16,
                EmfPolyPolyline,
                EmfPolyPolyline16,
                EmfPolyTextOutA,
                EmfPolyTextOutW,
                EmfPolygon,
                EmfPolygon16,
                EmfPolyline,
                EmfPolyline16,
                EmfPolylineTo16,
                EmfRealizePalette,
                EmfRectangle,
                EmfReserved069,
                EmfReserved117,
                EmfResizePalette,
                EmfRestoreDC,
                EmfRoundArc,
                EmfRoundRect,
                EmfSaveDC,
                EmfScaleViewportExtEx,
                EmfScaleWindowExtEx,
                EmfSelectClipPath,
                EmfSelectObject,
                EmfSelectPalette,
                EmfSetArcDirection,
                EmfSetBkColor,
                EmfSetBkMode,
                EmfSetBrushOrgEx,
                EmfSetColorAdjustment,
                EmfSetColorSpace,
                EmfSetDIBitsToDevice,
                EmfSetIcmMode,
                EmfSetIcmProfileA,
                EmfSetIcmProfileW,
                EmfSetLayout,
                EmfSetLinkedUfis,
                EmfSetMapMode,
                EmfSetMapperFlags,
                EmfSetMetaRgn,
                EmfSetMiterLimit,
                EmfSetPaletteEntries,
                EmfSetPixelV,
                EmfSetPolyFillMode,
                EmfSetROP2,
                EmfSetStretchBltMode,
                EmfSetTextAlign,
                EmfSetTextColor,
                EmfSetTextJustification,
                EmfSetViewportExtEx,
                EmfSetViewportOrgEx,
                EmfSetWindowExtEx,
                EmfSetWindowOrgEx,
                EmfSetWorldTransform,
                EmfSmallTextOut,
                EmfStartDoc,
                EmfStretchBlt,
                EmfStretchDIBits,
                EmfStrokeAndFillPath,
                EmfStrokePath,
                EmfTransparentBlt,
                EmfWidenPath,
                EndContainer,
                EndOfFile,
                FillClosedCurve,
                FillEllipse,
                FillPath,
                FillPie,
                FillPolygon,
                FillRects,
                FillRegion,
                GetDC,
                Header,
                Invalid,
                Max,
                Min,
                MultiFormatEnd,
                MultiFormatSection,
                MultiFormatStart,
                MultiplyWorldTransform,
                Object,
                OffsetClip,
                ResetClip,
                ResetWorldTransform,
                Restore,
                RotateWorldTransform,
                Save,
                ScaleWorldTransform,
                SetAntiAliasMode,
                SetClipPath,
                SetClipRect,
                SetClipRegion,
                SetCompositingMode,
                SetCompositingQuality,
                SetInterpolationMode,
                SetPageTransform,
                SetPixelOffsetMode,
                SetRenderingOrigin,
                SetTextContrast,
                SetTextRenderingHint,
                SetWorldTransform,
                Total,
                TranslateWorldTransform,
                WmfAnimatePalette,
                WmfArc,
                WmfBitBlt,
                WmfChord,
                WmfCreateBrushIndirect,
                WmfCreateFontIndirect,
                WmfCreatePalette,
                WmfCreatePatternBrush,
                WmfCreatePenIndirect,
                WmfCreateRegion,
                WmfDeleteObject,
                WmfDibBitBlt,
                WmfDibCreatePatternBrush,
                WmfDibStretchBlt,
                WmfEllipse,
                WmfEscape,
                WmfExcludeClipRect,
                WmfExtFloodFill,
                WmfExtTextOut,
                WmfFillRegion,
                WmfFloodFill,
                WmfFrameRegion,
                WmfIntersectClipRect,
                WmfInvertRegion,
                WmfLineTo,
                WmfMoveTo,
                WmfOffsetCilpRgn,
                WmfOffsetViewportOrg,
                WmfOffsetWindowOrg,
                WmfPaintRegion,
                WmfPatBlt,
                WmfPie,
                WmfPolyPolygon,
                WmfPolygon,
                WmfPolyline,
                WmfRealizePalette,
                WmfRecordBase,
                WmfRectangle,
                WmfResizePalette,
                WmfRestoreDC,
                WmfRoundRect,
                WmfSaveDC,
                WmfScaleViewportExt,
                WmfScaleWindowExt,
                WmfSelectClipRegion,
                WmfSelectObject,
                WmfSelectPalette,
                WmfSetBkColor,
                WmfSetBkMode,
                WmfSetDibToDev,
                WmfSetLayout,
                WmfSetMapMode,
                WmfSetMapperFlags,
                WmfSetPalEntries,
                WmfSetPixel,
                WmfSetPolyFillMode,
                WmfSetROP2,
                WmfSetRelAbs,
                WmfSetStretchBltMode,
                WmfSetTextAlign,
                WmfSetTextCharExtra,
                WmfSetTextColor,
                WmfSetTextJustification,
                WmfSetViewportExt,
                WmfSetViewportOrg,
                WmfSetWindowExt,
                WmfSetWindowOrg,
                WmfStretchBlt,
                WmfStretchDib,
                WmfTextOut,
            }

            // Generated from `System.Drawing.Imaging.EmfType` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum EmfType
            {
                EmfOnly,
                EmfPlusDual,
                EmfPlusOnly,
            }

            // Generated from `System.Drawing.Imaging.Encoder` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class Encoder
            {
                public static System.Drawing.Imaging.Encoder ChrominanceTable;
                public static System.Drawing.Imaging.Encoder ColorDepth;
                public static System.Drawing.Imaging.Encoder Compression;
                public Encoder(System.Guid guid) => throw null;
                public System.Guid Guid { get => throw null; }
                public static System.Drawing.Imaging.Encoder LuminanceTable;
                public static System.Drawing.Imaging.Encoder Quality;
                public static System.Drawing.Imaging.Encoder RenderMethod;
                public static System.Drawing.Imaging.Encoder SaveFlag;
                public static System.Drawing.Imaging.Encoder ScanMethod;
                public static System.Drawing.Imaging.Encoder Transformation;
                public static System.Drawing.Imaging.Encoder Version;
            }

            // Generated from `System.Drawing.Imaging.EncoderParameter` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class EncoderParameter : System.IDisposable
            {
                public void Dispose() => throw null;
                public System.Drawing.Imaging.Encoder Encoder { get => throw null; set => throw null; }
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, string value) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, int[] numerator1, int[] denominator1, int[] numerator2, int[] denominator2) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, int[] numerator, int[] denominator) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, int numerator1, int demoninator1, int numerator2, int demoninator2) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, int numerator, int denominator) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, int numberValues, System.Drawing.Imaging.EncoderParameterValueType type, System.IntPtr value) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, int NumberOfValues, int Type, int Value) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, System.Int64[] value) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, System.Int64[] rangebegin, System.Int64[] rangeend) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, System.Int64 value) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, System.Int64 rangebegin, System.Int64 rangeend) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, System.Int16[] value) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, System.Int16 value) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, System.Byte[] value, bool undefined) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, System.Byte[] value) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, System.Byte value, bool undefined) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, System.Byte value) => throw null;
                public int NumberOfValues { get => throw null; }
                public System.Drawing.Imaging.EncoderParameterValueType Type { get => throw null; }
                public System.Drawing.Imaging.EncoderParameterValueType ValueType { get => throw null; }
                // ERR: Stub generator didn't handle member: ~EncoderParameter
            }

            // Generated from `System.Drawing.Imaging.EncoderParameterValueType` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum EncoderParameterValueType
            {
                ValueTypeAscii,
                ValueTypeByte,
                ValueTypeLong,
                ValueTypeLongRange,
                ValueTypeRational,
                ValueTypeRationalRange,
                ValueTypeShort,
                ValueTypeUndefined,
            }

            // Generated from `System.Drawing.Imaging.EncoderParameters` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class EncoderParameters : System.IDisposable
            {
                public void Dispose() => throw null;
                public EncoderParameters(int count) => throw null;
                public EncoderParameters() => throw null;
                public System.Drawing.Imaging.EncoderParameter[] Param { get => throw null; set => throw null; }
            }

            // Generated from `System.Drawing.Imaging.EncoderValue` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum EncoderValue
            {
                ColorTypeCMYK,
                ColorTypeYCCK,
                CompressionCCITT3,
                CompressionCCITT4,
                CompressionLZW,
                CompressionNone,
                CompressionRle,
                Flush,
                FrameDimensionPage,
                FrameDimensionResolution,
                FrameDimensionTime,
                LastFrame,
                MultiFrame,
                RenderNonProgressive,
                RenderProgressive,
                ScanMethodInterlaced,
                ScanMethodNonInterlaced,
                TransformFlipHorizontal,
                TransformFlipVertical,
                TransformRotate180,
                TransformRotate270,
                TransformRotate90,
                VersionGif87,
                VersionGif89,
            }

            // Generated from `System.Drawing.Imaging.FrameDimension` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class FrameDimension
            {
                public override bool Equals(object o) => throw null;
                public FrameDimension(System.Guid guid) => throw null;
                public override int GetHashCode() => throw null;
                public System.Guid Guid { get => throw null; }
                public static System.Drawing.Imaging.FrameDimension Page { get => throw null; }
                public static System.Drawing.Imaging.FrameDimension Resolution { get => throw null; }
                public static System.Drawing.Imaging.FrameDimension Time { get => throw null; }
                public override string ToString() => throw null;
            }

            // Generated from `System.Drawing.Imaging.ImageAttributes` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class ImageAttributes : System.IDisposable, System.ICloneable
            {
                public void ClearBrushRemapTable() => throw null;
                public void ClearColorKey(System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void ClearColorKey() => throw null;
                public void ClearColorMatrix(System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void ClearColorMatrix() => throw null;
                public void ClearGamma(System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void ClearGamma() => throw null;
                public void ClearNoOp(System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void ClearNoOp() => throw null;
                public void ClearOutputChannel(System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void ClearOutputChannel() => throw null;
                public void ClearOutputChannelColorProfile(System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void ClearOutputChannelColorProfile() => throw null;
                public void ClearRemapTable(System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void ClearRemapTable() => throw null;
                public void ClearThreshold(System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void ClearThreshold() => throw null;
                public object Clone() => throw null;
                public void Dispose() => throw null;
                public void GetAdjustedPalette(System.Drawing.Imaging.ColorPalette palette, System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public ImageAttributes() => throw null;
                public void SetBrushRemapTable(System.Drawing.Imaging.ColorMap[] map) => throw null;
                public void SetColorKey(System.Drawing.Color colorLow, System.Drawing.Color colorHigh, System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void SetColorKey(System.Drawing.Color colorLow, System.Drawing.Color colorHigh) => throw null;
                public void SetColorMatrices(System.Drawing.Imaging.ColorMatrix newColorMatrix, System.Drawing.Imaging.ColorMatrix grayMatrix, System.Drawing.Imaging.ColorMatrixFlag mode, System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void SetColorMatrices(System.Drawing.Imaging.ColorMatrix newColorMatrix, System.Drawing.Imaging.ColorMatrix grayMatrix, System.Drawing.Imaging.ColorMatrixFlag flags) => throw null;
                public void SetColorMatrices(System.Drawing.Imaging.ColorMatrix newColorMatrix, System.Drawing.Imaging.ColorMatrix grayMatrix) => throw null;
                public void SetColorMatrix(System.Drawing.Imaging.ColorMatrix newColorMatrix, System.Drawing.Imaging.ColorMatrixFlag mode, System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void SetColorMatrix(System.Drawing.Imaging.ColorMatrix newColorMatrix, System.Drawing.Imaging.ColorMatrixFlag flags) => throw null;
                public void SetColorMatrix(System.Drawing.Imaging.ColorMatrix newColorMatrix) => throw null;
                public void SetGamma(float gamma, System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void SetGamma(float gamma) => throw null;
                public void SetNoOp(System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void SetNoOp() => throw null;
                public void SetOutputChannel(System.Drawing.Imaging.ColorChannelFlag flags, System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void SetOutputChannel(System.Drawing.Imaging.ColorChannelFlag flags) => throw null;
                public void SetOutputChannelColorProfile(string colorProfileFilename, System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void SetOutputChannelColorProfile(string colorProfileFilename) => throw null;
                public void SetRemapTable(System.Drawing.Imaging.ColorMap[] map, System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void SetRemapTable(System.Drawing.Imaging.ColorMap[] map) => throw null;
                public void SetThreshold(float threshold, System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void SetThreshold(float threshold) => throw null;
                public void SetWrapMode(System.Drawing.Drawing2D.WrapMode mode, System.Drawing.Color color, bool clamp) => throw null;
                public void SetWrapMode(System.Drawing.Drawing2D.WrapMode mode, System.Drawing.Color color) => throw null;
                public void SetWrapMode(System.Drawing.Drawing2D.WrapMode mode) => throw null;
                // ERR: Stub generator didn't handle member: ~ImageAttributes
            }

            // Generated from `System.Drawing.Imaging.ImageCodecFlags` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            [System.Flags]
            public enum ImageCodecFlags
            {
                BlockingDecode,
                Builtin,
                Decoder,
                Encoder,
                SeekableEncode,
                SupportBitmap,
                SupportVector,
                System,
                User,
            }

            // Generated from `System.Drawing.Imaging.ImageCodecInfo` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class ImageCodecInfo
            {
                public System.Guid Clsid { get => throw null; set => throw null; }
                public string CodecName { get => throw null; set => throw null; }
                public string DllName { get => throw null; set => throw null; }
                public string FilenameExtension { get => throw null; set => throw null; }
                public System.Drawing.Imaging.ImageCodecFlags Flags { get => throw null; set => throw null; }
                public string FormatDescription { get => throw null; set => throw null; }
                public System.Guid FormatID { get => throw null; set => throw null; }
                public static System.Drawing.Imaging.ImageCodecInfo[] GetImageDecoders() => throw null;
                public static System.Drawing.Imaging.ImageCodecInfo[] GetImageEncoders() => throw null;
                public string MimeType { get => throw null; set => throw null; }
                public System.Byte[][] SignatureMasks { get => throw null; set => throw null; }
                public System.Byte[][] SignaturePatterns { get => throw null; set => throw null; }
                public int Version { get => throw null; set => throw null; }
            }

            // Generated from `System.Drawing.Imaging.ImageFlags` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            [System.Flags]
            public enum ImageFlags
            {
                Caching,
                ColorSpaceCmyk,
                ColorSpaceGray,
                ColorSpaceRgb,
                ColorSpaceYcbcr,
                ColorSpaceYcck,
                HasAlpha,
                HasRealDpi,
                HasRealPixelSize,
                HasTranslucent,
                None,
                PartiallyScalable,
                ReadOnly,
                Scalable,
            }

            // Generated from `System.Drawing.Imaging.ImageFormat` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class ImageFormat
            {
                public static System.Drawing.Imaging.ImageFormat Bmp { get => throw null; }
                public static System.Drawing.Imaging.ImageFormat Emf { get => throw null; }
                public override bool Equals(object o) => throw null;
                public static System.Drawing.Imaging.ImageFormat Exif { get => throw null; }
                public override int GetHashCode() => throw null;
                public static System.Drawing.Imaging.ImageFormat Gif { get => throw null; }
                public System.Guid Guid { get => throw null; }
                public static System.Drawing.Imaging.ImageFormat Icon { get => throw null; }
                public ImageFormat(System.Guid guid) => throw null;
                public static System.Drawing.Imaging.ImageFormat Jpeg { get => throw null; }
                public static System.Drawing.Imaging.ImageFormat MemoryBmp { get => throw null; }
                public static System.Drawing.Imaging.ImageFormat Png { get => throw null; }
                public static System.Drawing.Imaging.ImageFormat Tiff { get => throw null; }
                public override string ToString() => throw null;
                public static System.Drawing.Imaging.ImageFormat Wmf { get => throw null; }
            }

            // Generated from `System.Drawing.Imaging.ImageLockMode` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum ImageLockMode
            {
                ReadOnly,
                ReadWrite,
                UserInputBuffer,
                WriteOnly,
            }

            // Generated from `System.Drawing.Imaging.MetaHeader` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class MetaHeader
            {
                public System.Int16 HeaderSize { get => throw null; set => throw null; }
                public int MaxRecord { get => throw null; set => throw null; }
                public MetaHeader() => throw null;
                public System.Int16 NoObjects { get => throw null; set => throw null; }
                public System.Int16 NoParameters { get => throw null; set => throw null; }
                public int Size { get => throw null; set => throw null; }
                public System.Int16 Type { get => throw null; set => throw null; }
                public System.Int16 Version { get => throw null; set => throw null; }
            }

            // Generated from `System.Drawing.Imaging.Metafile` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class Metafile : System.Drawing.Image
            {
                public System.IntPtr GetHenhmetafile() => throw null;
                public static System.Drawing.Imaging.MetafileHeader GetMetafileHeader(string fileName) => throw null;
                public static System.Drawing.Imaging.MetafileHeader GetMetafileHeader(System.IntPtr hmetafile, System.Drawing.Imaging.WmfPlaceableFileHeader wmfHeader) => throw null;
                public static System.Drawing.Imaging.MetafileHeader GetMetafileHeader(System.IntPtr henhmetafile) => throw null;
                public static System.Drawing.Imaging.MetafileHeader GetMetafileHeader(System.IO.Stream stream) => throw null;
                public System.Drawing.Imaging.MetafileHeader GetMetafileHeader() => throw null;
                public Metafile(string filename) => throw null;
                public Metafile(string fileName, System.IntPtr referenceHdc, System.Drawing.RectangleF frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit, string desc) => throw null;
                public Metafile(string fileName, System.IntPtr referenceHdc, System.Drawing.RectangleF frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit, System.Drawing.Imaging.EmfType type, string description) => throw null;
                public Metafile(string fileName, System.IntPtr referenceHdc, System.Drawing.RectangleF frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit, System.Drawing.Imaging.EmfType type) => throw null;
                public Metafile(string fileName, System.IntPtr referenceHdc, System.Drawing.RectangleF frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit) => throw null;
                public Metafile(string fileName, System.IntPtr referenceHdc, System.Drawing.RectangleF frameRect) => throw null;
                public Metafile(string fileName, System.IntPtr referenceHdc, System.Drawing.Rectangle frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit, string description) => throw null;
                public Metafile(string fileName, System.IntPtr referenceHdc, System.Drawing.Rectangle frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit, System.Drawing.Imaging.EmfType type, string description) => throw null;
                public Metafile(string fileName, System.IntPtr referenceHdc, System.Drawing.Rectangle frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit, System.Drawing.Imaging.EmfType type) => throw null;
                public Metafile(string fileName, System.IntPtr referenceHdc, System.Drawing.Rectangle frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit) => throw null;
                public Metafile(string fileName, System.IntPtr referenceHdc, System.Drawing.Rectangle frameRect) => throw null;
                public Metafile(string fileName, System.IntPtr referenceHdc, System.Drawing.Imaging.EmfType type, string description) => throw null;
                public Metafile(string fileName, System.IntPtr referenceHdc, System.Drawing.Imaging.EmfType type) => throw null;
                public Metafile(string fileName, System.IntPtr referenceHdc) => throw null;
                public Metafile(System.IntPtr referenceHdc, System.Drawing.RectangleF frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit, System.Drawing.Imaging.EmfType type, string description) => throw null;
                public Metafile(System.IntPtr referenceHdc, System.Drawing.RectangleF frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit, System.Drawing.Imaging.EmfType type) => throw null;
                public Metafile(System.IntPtr referenceHdc, System.Drawing.RectangleF frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit) => throw null;
                public Metafile(System.IntPtr referenceHdc, System.Drawing.RectangleF frameRect) => throw null;
                public Metafile(System.IntPtr referenceHdc, System.Drawing.Rectangle frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit, System.Drawing.Imaging.EmfType type, string desc) => throw null;
                public Metafile(System.IntPtr referenceHdc, System.Drawing.Rectangle frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit, System.Drawing.Imaging.EmfType type) => throw null;
                public Metafile(System.IntPtr referenceHdc, System.Drawing.Rectangle frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit) => throw null;
                public Metafile(System.IntPtr referenceHdc, System.Drawing.Rectangle frameRect) => throw null;
                public Metafile(System.IntPtr referenceHdc, System.Drawing.Imaging.EmfType emfType, string description) => throw null;
                public Metafile(System.IntPtr referenceHdc, System.Drawing.Imaging.EmfType emfType) => throw null;
                public Metafile(System.IntPtr hmetafile, System.Drawing.Imaging.WmfPlaceableFileHeader wmfHeader, bool deleteWmf) => throw null;
                public Metafile(System.IntPtr hmetafile, System.Drawing.Imaging.WmfPlaceableFileHeader wmfHeader) => throw null;
                public Metafile(System.IntPtr henhmetafile, bool deleteEmf) => throw null;
                public Metafile(System.IO.Stream stream, System.IntPtr referenceHdc, System.Drawing.RectangleF frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit, System.Drawing.Imaging.EmfType type, string description) => throw null;
                public Metafile(System.IO.Stream stream, System.IntPtr referenceHdc, System.Drawing.RectangleF frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit, System.Drawing.Imaging.EmfType type) => throw null;
                public Metafile(System.IO.Stream stream, System.IntPtr referenceHdc, System.Drawing.RectangleF frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit) => throw null;
                public Metafile(System.IO.Stream stream, System.IntPtr referenceHdc, System.Drawing.RectangleF frameRect) => throw null;
                public Metafile(System.IO.Stream stream, System.IntPtr referenceHdc, System.Drawing.Rectangle frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit, System.Drawing.Imaging.EmfType type, string description) => throw null;
                public Metafile(System.IO.Stream stream, System.IntPtr referenceHdc, System.Drawing.Rectangle frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit, System.Drawing.Imaging.EmfType type) => throw null;
                public Metafile(System.IO.Stream stream, System.IntPtr referenceHdc, System.Drawing.Rectangle frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit) => throw null;
                public Metafile(System.IO.Stream stream, System.IntPtr referenceHdc, System.Drawing.Rectangle frameRect) => throw null;
                public Metafile(System.IO.Stream stream, System.IntPtr referenceHdc, System.Drawing.Imaging.EmfType type, string description) => throw null;
                public Metafile(System.IO.Stream stream, System.IntPtr referenceHdc, System.Drawing.Imaging.EmfType type) => throw null;
                public Metafile(System.IO.Stream stream, System.IntPtr referenceHdc) => throw null;
                public Metafile(System.IO.Stream stream) => throw null;
                public void PlayRecord(System.Drawing.Imaging.EmfPlusRecordType recordType, int flags, int dataSize, System.Byte[] data) => throw null;
            }

            // Generated from `System.Drawing.Imaging.MetafileFrameUnit` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum MetafileFrameUnit
            {
                Document,
                GdiCompatible,
                Inch,
                Millimeter,
                Pixel,
                Point,
            }

            // Generated from `System.Drawing.Imaging.MetafileHeader` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class MetafileHeader
            {
                public System.Drawing.Rectangle Bounds { get => throw null; }
                public float DpiX { get => throw null; }
                public float DpiY { get => throw null; }
                public int EmfPlusHeaderSize { get => throw null; }
                public bool IsDisplay() => throw null;
                public bool IsEmf() => throw null;
                public bool IsEmfOrEmfPlus() => throw null;
                public bool IsEmfPlus() => throw null;
                public bool IsEmfPlusDual() => throw null;
                public bool IsEmfPlusOnly() => throw null;
                public bool IsWmf() => throw null;
                public bool IsWmfPlaceable() => throw null;
                public int LogicalDpiX { get => throw null; }
                public int LogicalDpiY { get => throw null; }
                public int MetafileSize { get => throw null; }
                public System.Drawing.Imaging.MetafileType Type { get => throw null; }
                public int Version { get => throw null; }
                public System.Drawing.Imaging.MetaHeader WmfHeader { get => throw null; }
            }

            // Generated from `System.Drawing.Imaging.MetafileType` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum MetafileType
            {
                Emf,
                EmfPlusDual,
                EmfPlusOnly,
                Invalid,
                Wmf,
                WmfPlaceable,
            }

            // Generated from `System.Drawing.Imaging.PaletteFlags` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            [System.Flags]
            public enum PaletteFlags
            {
                GrayScale,
                Halftone,
                HasAlpha,
            }

            // Generated from `System.Drawing.Imaging.PixelFormat` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum PixelFormat
            {
                Alpha,
                Canonical,
                DontCare,
                Extended,
                Format16bppArgb1555,
                Format16bppGrayScale,
                Format16bppRgb555,
                Format16bppRgb565,
                Format1bppIndexed,
                Format24bppRgb,
                Format32bppArgb,
                Format32bppPArgb,
                Format32bppRgb,
                Format48bppRgb,
                Format4bppIndexed,
                Format64bppArgb,
                Format64bppPArgb,
                Format8bppIndexed,
                Gdi,
                Indexed,
                Max,
                PAlpha,
                Undefined,
            }

            // Generated from `System.Drawing.Imaging.PlayRecordCallback` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public delegate void PlayRecordCallback(System.Drawing.Imaging.EmfPlusRecordType recordType, int flags, int dataSize, System.IntPtr recordData);

            // Generated from `System.Drawing.Imaging.PropertyItem` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PropertyItem
            {
                public int Id { get => throw null; set => throw null; }
                public int Len { get => throw null; set => throw null; }
                public System.Int16 Type { get => throw null; set => throw null; }
                public System.Byte[] Value { get => throw null; set => throw null; }
            }

            // Generated from `System.Drawing.Imaging.WmfPlaceableFileHeader` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class WmfPlaceableFileHeader
            {
                public System.Int16 BboxBottom { get => throw null; set => throw null; }
                public System.Int16 BboxLeft { get => throw null; set => throw null; }
                public System.Int16 BboxRight { get => throw null; set => throw null; }
                public System.Int16 BboxTop { get => throw null; set => throw null; }
                public System.Int16 Checksum { get => throw null; set => throw null; }
                public System.Int16 Hmf { get => throw null; set => throw null; }
                public System.Int16 Inch { get => throw null; set => throw null; }
                public int Key { get => throw null; set => throw null; }
                public int Reserved { get => throw null; set => throw null; }
                public WmfPlaceableFileHeader() => throw null;
            }

        }
        namespace Printing
        {
            // Generated from `System.Drawing.Printing.Duplex` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum Duplex
            {
                Default,
                Horizontal,
                Simplex,
                Vertical,
            }

            // Generated from `System.Drawing.Printing.InvalidPrinterException` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class InvalidPrinterException : System.SystemException
            {
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public InvalidPrinterException(System.Drawing.Printing.PrinterSettings settings) => throw null;
                protected InvalidPrinterException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            }

            // Generated from `System.Drawing.Printing.Margins` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class Margins : System.ICloneable
            {
                public static bool operator !=(System.Drawing.Printing.Margins m1, System.Drawing.Printing.Margins m2) => throw null;
                public static bool operator ==(System.Drawing.Printing.Margins m1, System.Drawing.Printing.Margins m2) => throw null;
                public int Bottom { get => throw null; set => throw null; }
                public object Clone() => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public int Left { get => throw null; set => throw null; }
                public Margins(int left, int right, int top, int bottom) => throw null;
                public Margins() => throw null;
                public int Right { get => throw null; set => throw null; }
                public override string ToString() => throw null;
                public int Top { get => throw null; set => throw null; }
            }

            // Generated from `System.Drawing.Printing.PageSettings` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PageSettings : System.ICloneable
            {
                public System.Drawing.Rectangle Bounds { get => throw null; }
                public object Clone() => throw null;
                public bool Color { get => throw null; set => throw null; }
                public void CopyToHdevmode(System.IntPtr hdevmode) => throw null;
                public float HardMarginX { get => throw null; }
                public float HardMarginY { get => throw null; }
                public bool Landscape { get => throw null; set => throw null; }
                public System.Drawing.Printing.Margins Margins { get => throw null; set => throw null; }
                public PageSettings(System.Drawing.Printing.PrinterSettings printerSettings) => throw null;
                public PageSettings() => throw null;
                public System.Drawing.Printing.PaperSize PaperSize { get => throw null; set => throw null; }
                public System.Drawing.Printing.PaperSource PaperSource { get => throw null; set => throw null; }
                public System.Drawing.RectangleF PrintableArea { get => throw null; }
                public System.Drawing.Printing.PrinterResolution PrinterResolution { get => throw null; set => throw null; }
                public System.Drawing.Printing.PrinterSettings PrinterSettings { get => throw null; set => throw null; }
                public void SetHdevmode(System.IntPtr hdevmode) => throw null;
                public override string ToString() => throw null;
            }

            // Generated from `System.Drawing.Printing.PaperKind` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum PaperKind
            {
                A2,
                A3,
                A3Extra,
                A3ExtraTransverse,
                A3Rotated,
                A3Transverse,
                A4,
                A4Extra,
                A4Plus,
                A4Rotated,
                A4Small,
                A4Transverse,
                A5,
                A5Extra,
                A5Rotated,
                A5Transverse,
                A6,
                A6Rotated,
                APlus,
                B4,
                B4Envelope,
                B4JisRotated,
                B5,
                B5Envelope,
                B5Extra,
                B5JisRotated,
                B5Transverse,
                B6Envelope,
                B6Jis,
                B6JisRotated,
                BPlus,
                C3Envelope,
                C4Envelope,
                C5Envelope,
                C65Envelope,
                C6Envelope,
                CSheet,
                Custom,
                DLEnvelope,
                DSheet,
                ESheet,
                Executive,
                Folio,
                GermanLegalFanfold,
                GermanStandardFanfold,
                InviteEnvelope,
                IsoB4,
                ItalyEnvelope,
                JapaneseDoublePostcard,
                JapaneseDoublePostcardRotated,
                JapaneseEnvelopeChouNumber3,
                JapaneseEnvelopeChouNumber3Rotated,
                JapaneseEnvelopeChouNumber4,
                JapaneseEnvelopeChouNumber4Rotated,
                JapaneseEnvelopeKakuNumber2,
                JapaneseEnvelopeKakuNumber2Rotated,
                JapaneseEnvelopeKakuNumber3,
                JapaneseEnvelopeKakuNumber3Rotated,
                JapaneseEnvelopeYouNumber4,
                JapaneseEnvelopeYouNumber4Rotated,
                JapanesePostcard,
                JapanesePostcardRotated,
                Ledger,
                Legal,
                LegalExtra,
                Letter,
                LetterExtra,
                LetterExtraTransverse,
                LetterPlus,
                LetterRotated,
                LetterSmall,
                LetterTransverse,
                MonarchEnvelope,
                Note,
                Number10Envelope,
                Number11Envelope,
                Number12Envelope,
                Number14Envelope,
                Number9Envelope,
                PersonalEnvelope,
                Prc16K,
                Prc16KRotated,
                Prc32K,
                Prc32KBig,
                Prc32KBigRotated,
                Prc32KRotated,
                PrcEnvelopeNumber1,
                PrcEnvelopeNumber10,
                PrcEnvelopeNumber10Rotated,
                PrcEnvelopeNumber1Rotated,
                PrcEnvelopeNumber2,
                PrcEnvelopeNumber2Rotated,
                PrcEnvelopeNumber3,
                PrcEnvelopeNumber3Rotated,
                PrcEnvelopeNumber4,
                PrcEnvelopeNumber4Rotated,
                PrcEnvelopeNumber5,
                PrcEnvelopeNumber5Rotated,
                PrcEnvelopeNumber6,
                PrcEnvelopeNumber6Rotated,
                PrcEnvelopeNumber7,
                PrcEnvelopeNumber7Rotated,
                PrcEnvelopeNumber8,
                PrcEnvelopeNumber8Rotated,
                PrcEnvelopeNumber9,
                PrcEnvelopeNumber9Rotated,
                Quarto,
                Standard10x11,
                Standard10x14,
                Standard11x17,
                Standard12x11,
                Standard15x11,
                Standard9x11,
                Statement,
                Tabloid,
                TabloidExtra,
                USStandardFanfold,
            }

            // Generated from `System.Drawing.Printing.PaperSize` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PaperSize
            {
                public int Height { get => throw null; set => throw null; }
                public System.Drawing.Printing.PaperKind Kind { get => throw null; }
                public string PaperName { get => throw null; set => throw null; }
                public PaperSize(string name, int width, int height) => throw null;
                public PaperSize() => throw null;
                public int RawKind { get => throw null; set => throw null; }
                public override string ToString() => throw null;
                public int Width { get => throw null; set => throw null; }
            }

            // Generated from `System.Drawing.Printing.PaperSource` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PaperSource
            {
                public System.Drawing.Printing.PaperSourceKind Kind { get => throw null; }
                public PaperSource() => throw null;
                public int RawKind { get => throw null; set => throw null; }
                public string SourceName { get => throw null; set => throw null; }
                public override string ToString() => throw null;
            }

            // Generated from `System.Drawing.Printing.PaperSourceKind` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum PaperSourceKind
            {
                AutomaticFeed,
                Cassette,
                Custom,
                Envelope,
                FormSource,
                LargeCapacity,
                LargeFormat,
                Lower,
                Manual,
                ManualFeed,
                Middle,
                SmallFormat,
                TractorFeed,
                Upper,
            }

            // Generated from `System.Drawing.Printing.PreviewPageInfo` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PreviewPageInfo
            {
                public System.Drawing.Image Image { get => throw null; }
                public System.Drawing.Size PhysicalSize { get => throw null; }
                public PreviewPageInfo(System.Drawing.Image image, System.Drawing.Size physicalSize) => throw null;
            }

            // Generated from `System.Drawing.Printing.PreviewPrintController` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PreviewPrintController : System.Drawing.Printing.PrintController
            {
                public System.Drawing.Printing.PreviewPageInfo[] GetPreviewPageInfo() => throw null;
                public override bool IsPreview { get => throw null; }
                public override void OnEndPage(System.Drawing.Printing.PrintDocument document, System.Drawing.Printing.PrintPageEventArgs e) => throw null;
                public override void OnEndPrint(System.Drawing.Printing.PrintDocument document, System.Drawing.Printing.PrintEventArgs e) => throw null;
                public override System.Drawing.Graphics OnStartPage(System.Drawing.Printing.PrintDocument document, System.Drawing.Printing.PrintPageEventArgs e) => throw null;
                public override void OnStartPrint(System.Drawing.Printing.PrintDocument document, System.Drawing.Printing.PrintEventArgs e) => throw null;
                public PreviewPrintController() => throw null;
                public virtual bool UseAntiAlias { get => throw null; set => throw null; }
            }

            // Generated from `System.Drawing.Printing.PrintAction` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum PrintAction
            {
                PrintToFile,
                PrintToPreview,
                PrintToPrinter,
            }

            // Generated from `System.Drawing.Printing.PrintController` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public abstract class PrintController
            {
                public virtual bool IsPreview { get => throw null; }
                public virtual void OnEndPage(System.Drawing.Printing.PrintDocument document, System.Drawing.Printing.PrintPageEventArgs e) => throw null;
                public virtual void OnEndPrint(System.Drawing.Printing.PrintDocument document, System.Drawing.Printing.PrintEventArgs e) => throw null;
                public virtual System.Drawing.Graphics OnStartPage(System.Drawing.Printing.PrintDocument document, System.Drawing.Printing.PrintPageEventArgs e) => throw null;
                public virtual void OnStartPrint(System.Drawing.Printing.PrintDocument document, System.Drawing.Printing.PrintEventArgs e) => throw null;
                protected PrintController() => throw null;
            }

            // Generated from `System.Drawing.Printing.PrintDocument` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PrintDocument : System.ComponentModel.Component
            {
                public event System.Drawing.Printing.PrintEventHandler BeginPrint;
                public System.Drawing.Printing.PageSettings DefaultPageSettings { get => throw null; set => throw null; }
                public string DocumentName { get => throw null; set => throw null; }
                public event System.Drawing.Printing.PrintEventHandler EndPrint;
                protected virtual void OnBeginPrint(System.Drawing.Printing.PrintEventArgs e) => throw null;
                protected virtual void OnEndPrint(System.Drawing.Printing.PrintEventArgs e) => throw null;
                protected virtual void OnPrintPage(System.Drawing.Printing.PrintPageEventArgs e) => throw null;
                protected virtual void OnQueryPageSettings(System.Drawing.Printing.QueryPageSettingsEventArgs e) => throw null;
                public bool OriginAtMargins { get => throw null; set => throw null; }
                public void Print() => throw null;
                public System.Drawing.Printing.PrintController PrintController { get => throw null; set => throw null; }
                public PrintDocument() => throw null;
                public event System.Drawing.Printing.PrintPageEventHandler PrintPage;
                public System.Drawing.Printing.PrinterSettings PrinterSettings { get => throw null; set => throw null; }
                public event System.Drawing.Printing.QueryPageSettingsEventHandler QueryPageSettings;
                public override string ToString() => throw null;
            }

            // Generated from `System.Drawing.Printing.PrintEventArgs` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PrintEventArgs : System.ComponentModel.CancelEventArgs
            {
                public System.Drawing.Printing.PrintAction PrintAction { get => throw null; }
                public PrintEventArgs() => throw null;
            }

            // Generated from `System.Drawing.Printing.PrintEventHandler` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public delegate void PrintEventHandler(object sender, System.Drawing.Printing.PrintEventArgs e);

            // Generated from `System.Drawing.Printing.PrintPageEventArgs` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PrintPageEventArgs : System.EventArgs
            {
                public bool Cancel { get => throw null; set => throw null; }
                public System.Drawing.Graphics Graphics { get => throw null; }
                public bool HasMorePages { get => throw null; set => throw null; }
                public System.Drawing.Rectangle MarginBounds { get => throw null; }
                public System.Drawing.Rectangle PageBounds { get => throw null; }
                public System.Drawing.Printing.PageSettings PageSettings { get => throw null; }
                public PrintPageEventArgs(System.Drawing.Graphics graphics, System.Drawing.Rectangle marginBounds, System.Drawing.Rectangle pageBounds, System.Drawing.Printing.PageSettings pageSettings) => throw null;
            }

            // Generated from `System.Drawing.Printing.PrintPageEventHandler` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public delegate void PrintPageEventHandler(object sender, System.Drawing.Printing.PrintPageEventArgs e);

            // Generated from `System.Drawing.Printing.PrintRange` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum PrintRange
            {
                AllPages,
                CurrentPage,
                Selection,
                SomePages,
            }

            // Generated from `System.Drawing.Printing.PrinterResolution` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PrinterResolution
            {
                public System.Drawing.Printing.PrinterResolutionKind Kind { get => throw null; set => throw null; }
                public PrinterResolution() => throw null;
                public override string ToString() => throw null;
                public int X { get => throw null; set => throw null; }
                public int Y { get => throw null; set => throw null; }
            }

            // Generated from `System.Drawing.Printing.PrinterResolutionKind` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum PrinterResolutionKind
            {
                Custom,
                Draft,
                High,
                Low,
                Medium,
            }

            // Generated from `System.Drawing.Printing.PrinterSettings` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PrinterSettings : System.ICloneable
            {
                public bool CanDuplex { get => throw null; }
                public object Clone() => throw null;
                public bool Collate { get => throw null; set => throw null; }
                public System.Int16 Copies { get => throw null; set => throw null; }
                public System.Drawing.Graphics CreateMeasurementGraphics(bool honorOriginAtMargins) => throw null;
                public System.Drawing.Graphics CreateMeasurementGraphics(System.Drawing.Printing.PageSettings pageSettings, bool honorOriginAtMargins) => throw null;
                public System.Drawing.Graphics CreateMeasurementGraphics(System.Drawing.Printing.PageSettings pageSettings) => throw null;
                public System.Drawing.Graphics CreateMeasurementGraphics() => throw null;
                public System.Drawing.Printing.PageSettings DefaultPageSettings { get => throw null; }
                public System.Drawing.Printing.Duplex Duplex { get => throw null; set => throw null; }
                public int FromPage { get => throw null; set => throw null; }
                public System.IntPtr GetHdevmode(System.Drawing.Printing.PageSettings pageSettings) => throw null;
                public System.IntPtr GetHdevmode() => throw null;
                public System.IntPtr GetHdevnames() => throw null;
                public static System.Drawing.Printing.PrinterSettings.StringCollection InstalledPrinters { get => throw null; }
                public bool IsDefaultPrinter { get => throw null; }
                public bool IsDirectPrintingSupported(System.Drawing.Imaging.ImageFormat imageFormat) => throw null;
                public bool IsDirectPrintingSupported(System.Drawing.Image image) => throw null;
                public bool IsPlotter { get => throw null; }
                public bool IsValid { get => throw null; }
                public int LandscapeAngle { get => throw null; }
                public int MaximumCopies { get => throw null; }
                public int MaximumPage { get => throw null; set => throw null; }
                public int MinimumPage { get => throw null; set => throw null; }
                // Generated from `System.Drawing.Printing.PrinterSettings+PaperSizeCollection` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class PaperSizeCollection : System.Collections.IEnumerable, System.Collections.ICollection
                {
                    public int Add(System.Drawing.Printing.PaperSize paperSize) => throw null;
                    void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                    public void CopyTo(System.Drawing.Printing.PaperSize[] paperSizes, int index) => throw null;
                    public int Count { get => throw null; }
                    int System.Collections.ICollection.Count { get => throw null; }
                    public System.Collections.IEnumerator GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                    public virtual System.Drawing.Printing.PaperSize this[int index] { get => throw null; }
                    public PaperSizeCollection(System.Drawing.Printing.PaperSize[] array) => throw null;
                    object System.Collections.ICollection.SyncRoot { get => throw null; }
                }


                public System.Drawing.Printing.PrinterSettings.PaperSizeCollection PaperSizes { get => throw null; }
                // Generated from `System.Drawing.Printing.PrinterSettings+PaperSourceCollection` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class PaperSourceCollection : System.Collections.IEnumerable, System.Collections.ICollection
                {
                    public int Add(System.Drawing.Printing.PaperSource paperSource) => throw null;
                    void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                    public void CopyTo(System.Drawing.Printing.PaperSource[] paperSources, int index) => throw null;
                    public int Count { get => throw null; }
                    int System.Collections.ICollection.Count { get => throw null; }
                    public System.Collections.IEnumerator GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                    public virtual System.Drawing.Printing.PaperSource this[int index] { get => throw null; }
                    public PaperSourceCollection(System.Drawing.Printing.PaperSource[] array) => throw null;
                    object System.Collections.ICollection.SyncRoot { get => throw null; }
                }


                public System.Drawing.Printing.PrinterSettings.PaperSourceCollection PaperSources { get => throw null; }
                public string PrintFileName { get => throw null; set => throw null; }
                public System.Drawing.Printing.PrintRange PrintRange { get => throw null; set => throw null; }
                public bool PrintToFile { get => throw null; set => throw null; }
                public string PrinterName { get => throw null; set => throw null; }
                // Generated from `System.Drawing.Printing.PrinterSettings+PrinterResolutionCollection` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class PrinterResolutionCollection : System.Collections.IEnumerable, System.Collections.ICollection
                {
                    public int Add(System.Drawing.Printing.PrinterResolution printerResolution) => throw null;
                    void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                    public void CopyTo(System.Drawing.Printing.PrinterResolution[] printerResolutions, int index) => throw null;
                    public int Count { get => throw null; }
                    int System.Collections.ICollection.Count { get => throw null; }
                    public System.Collections.IEnumerator GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                    public virtual System.Drawing.Printing.PrinterResolution this[int index] { get => throw null; }
                    public PrinterResolutionCollection(System.Drawing.Printing.PrinterResolution[] array) => throw null;
                    object System.Collections.ICollection.SyncRoot { get => throw null; }
                }


                public System.Drawing.Printing.PrinterSettings.PrinterResolutionCollection PrinterResolutions { get => throw null; }
                public PrinterSettings() => throw null;
                public void SetHdevmode(System.IntPtr hdevmode) => throw null;
                public void SetHdevnames(System.IntPtr hdevnames) => throw null;
                // Generated from `System.Drawing.Printing.PrinterSettings+StringCollection` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class StringCollection : System.Collections.IEnumerable, System.Collections.ICollection
                {
                    public int Add(string value) => throw null;
                    void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                    public void CopyTo(string[] strings, int index) => throw null;
                    public int Count { get => throw null; }
                    int System.Collections.ICollection.Count { get => throw null; }
                    public System.Collections.IEnumerator GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                    public virtual string this[int index] { get => throw null; }
                    public StringCollection(string[] array) => throw null;
                    object System.Collections.ICollection.SyncRoot { get => throw null; }
                }


                public bool SupportsColor { get => throw null; }
                public int ToPage { get => throw null; set => throw null; }
                public override string ToString() => throw null;
            }

            // Generated from `System.Drawing.Printing.PrinterUnit` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum PrinterUnit
            {
                Display,
                HundredthsOfAMillimeter,
                TenthsOfAMillimeter,
                ThousandthsOfAnInch,
            }

            // Generated from `System.Drawing.Printing.PrinterUnitConvert` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PrinterUnitConvert
            {
                public static int Convert(int value, System.Drawing.Printing.PrinterUnit fromUnit, System.Drawing.Printing.PrinterUnit toUnit) => throw null;
                public static double Convert(double value, System.Drawing.Printing.PrinterUnit fromUnit, System.Drawing.Printing.PrinterUnit toUnit) => throw null;
                public static System.Drawing.Size Convert(System.Drawing.Size value, System.Drawing.Printing.PrinterUnit fromUnit, System.Drawing.Printing.PrinterUnit toUnit) => throw null;
                public static System.Drawing.Rectangle Convert(System.Drawing.Rectangle value, System.Drawing.Printing.PrinterUnit fromUnit, System.Drawing.Printing.PrinterUnit toUnit) => throw null;
                public static System.Drawing.Printing.Margins Convert(System.Drawing.Printing.Margins value, System.Drawing.Printing.PrinterUnit fromUnit, System.Drawing.Printing.PrinterUnit toUnit) => throw null;
                public static System.Drawing.Point Convert(System.Drawing.Point value, System.Drawing.Printing.PrinterUnit fromUnit, System.Drawing.Printing.PrinterUnit toUnit) => throw null;
            }

            // Generated from `System.Drawing.Printing.QueryPageSettingsEventArgs` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class QueryPageSettingsEventArgs : System.Drawing.Printing.PrintEventArgs
            {
                public System.Drawing.Printing.PageSettings PageSettings { get => throw null; set => throw null; }
                public QueryPageSettingsEventArgs(System.Drawing.Printing.PageSettings pageSettings) => throw null;
            }

            // Generated from `System.Drawing.Printing.QueryPageSettingsEventHandler` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public delegate void QueryPageSettingsEventHandler(object sender, System.Drawing.Printing.QueryPageSettingsEventArgs e);

            // Generated from `System.Drawing.Printing.StandardPrintController` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class StandardPrintController : System.Drawing.Printing.PrintController
            {
                public override void OnEndPage(System.Drawing.Printing.PrintDocument document, System.Drawing.Printing.PrintPageEventArgs e) => throw null;
                public override void OnEndPrint(System.Drawing.Printing.PrintDocument document, System.Drawing.Printing.PrintEventArgs e) => throw null;
                public override System.Drawing.Graphics OnStartPage(System.Drawing.Printing.PrintDocument document, System.Drawing.Printing.PrintPageEventArgs e) => throw null;
                public override void OnStartPrint(System.Drawing.Printing.PrintDocument document, System.Drawing.Printing.PrintEventArgs e) => throw null;
                public StandardPrintController() => throw null;
            }

        }
        namespace Text
        {
            // Generated from `System.Drawing.Text.FontCollection` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public abstract class FontCollection : System.IDisposable
            {
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public System.Drawing.FontFamily[] Families { get => throw null; }
                internal FontCollection() => throw null;
                // ERR: Stub generator didn't handle member: ~FontCollection
            }

            // Generated from `System.Drawing.Text.GenericFontFamilies` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum GenericFontFamilies
            {
                Monospace,
                SansSerif,
                Serif,
            }

            // Generated from `System.Drawing.Text.HotkeyPrefix` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum HotkeyPrefix
            {
                Hide,
                None,
                Show,
            }

            // Generated from `System.Drawing.Text.InstalledFontCollection` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class InstalledFontCollection : System.Drawing.Text.FontCollection
            {
                public InstalledFontCollection() => throw null;
            }

            // Generated from `System.Drawing.Text.PrivateFontCollection` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PrivateFontCollection : System.Drawing.Text.FontCollection
            {
                public void AddFontFile(string filename) => throw null;
                public void AddMemoryFont(System.IntPtr memory, int length) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public PrivateFontCollection() => throw null;
            }

            // Generated from `System.Drawing.Text.TextRenderingHint` in `System.Drawing.Common, Version=4.0.2.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum TextRenderingHint
            {
                AntiAlias,
                AntiAliasGridFit,
                ClearTypeGridFit,
                SingleBitPerPixel,
                SingleBitPerPixelGridFit,
                SystemDefault,
            }

        }
    }
}
