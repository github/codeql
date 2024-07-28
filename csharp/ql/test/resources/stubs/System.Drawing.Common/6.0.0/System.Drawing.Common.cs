// This file contains auto-generated code.
// Generated from `System.Drawing.Common, Version=6.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`.
namespace System
{
    namespace Drawing
    {
        public sealed class Bitmap : System.Drawing.Image
        {
            public System.Drawing.Bitmap Clone(System.Drawing.Rectangle rect, System.Drawing.Imaging.PixelFormat format) => throw null;
            public System.Drawing.Bitmap Clone(System.Drawing.RectangleF rect, System.Drawing.Imaging.PixelFormat format) => throw null;
            public Bitmap(System.Drawing.Image original) => throw null;
            public Bitmap(System.Drawing.Image original, System.Drawing.Size newSize) => throw null;
            public Bitmap(System.Drawing.Image original, int width, int height) => throw null;
            public Bitmap(int width, int height) => throw null;
            public Bitmap(int width, int height, System.Drawing.Graphics g) => throw null;
            public Bitmap(int width, int height, System.Drawing.Imaging.PixelFormat format) => throw null;
            public Bitmap(int width, int height, int stride, System.Drawing.Imaging.PixelFormat format, nint scan0) => throw null;
            public Bitmap(System.IO.Stream stream) => throw null;
            public Bitmap(System.IO.Stream stream, bool useIcm) => throw null;
            public Bitmap(string filename) => throw null;
            public Bitmap(string filename, bool useIcm) => throw null;
            public Bitmap(System.Type type, string resource) => throw null;
            public static System.Drawing.Bitmap FromHicon(nint hicon) => throw null;
            public static System.Drawing.Bitmap FromResource(nint hinstance, string bitmapName) => throw null;
            public nint GetHbitmap() => throw null;
            public nint GetHbitmap(System.Drawing.Color background) => throw null;
            public nint GetHicon() => throw null;
            public System.Drawing.Color GetPixel(int x, int y) => throw null;
            public System.Drawing.Imaging.BitmapData LockBits(System.Drawing.Rectangle rect, System.Drawing.Imaging.ImageLockMode flags, System.Drawing.Imaging.PixelFormat format) => throw null;
            public System.Drawing.Imaging.BitmapData LockBits(System.Drawing.Rectangle rect, System.Drawing.Imaging.ImageLockMode flags, System.Drawing.Imaging.PixelFormat format, System.Drawing.Imaging.BitmapData bitmapData) => throw null;
            public void MakeTransparent() => throw null;
            public void MakeTransparent(System.Drawing.Color transparentColor) => throw null;
            public void SetPixel(int x, int y, System.Drawing.Color color) => throw null;
            public void SetResolution(float xDpi, float yDpi) => throw null;
            public void UnlockBits(System.Drawing.Imaging.BitmapData bitmapdata) => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)1)]
        public class BitmapSuffixInSameAssemblyAttribute : System.Attribute
        {
            public BitmapSuffixInSameAssemblyAttribute() => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)1)]
        public class BitmapSuffixInSatelliteAssemblyAttribute : System.Attribute
        {
            public BitmapSuffixInSatelliteAssemblyAttribute() => throw null;
        }
        public abstract class Brush : System.MarshalByRefObject, System.ICloneable, System.IDisposable
        {
            public abstract object Clone();
            protected Brush() => throw null;
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            protected void SetNativeBrush(nint brush) => throw null;
        }
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
        public sealed class BufferedGraphics : System.IDisposable
        {
            public void Dispose() => throw null;
            public System.Drawing.Graphics Graphics { get => throw null; }
            public void Render() => throw null;
            public void Render(System.Drawing.Graphics target) => throw null;
            public void Render(nint targetDC) => throw null;
        }
        public sealed class BufferedGraphicsContext : System.IDisposable
        {
            public System.Drawing.BufferedGraphics Allocate(System.Drawing.Graphics targetGraphics, System.Drawing.Rectangle targetRectangle) => throw null;
            public System.Drawing.BufferedGraphics Allocate(nint targetDC, System.Drawing.Rectangle targetRectangle) => throw null;
            public BufferedGraphicsContext() => throw null;
            public void Dispose() => throw null;
            public void Invalidate() => throw null;
            public System.Drawing.Size MaximumBuffer { get => throw null; set { } }
        }
        public static class BufferedGraphicsManager
        {
            public static System.Drawing.BufferedGraphicsContext Current { get => throw null; }
        }
        public struct CharacterRange
        {
            public CharacterRange(int First, int Length) => throw null;
            public override bool Equals(object obj) => throw null;
            public int First { get => throw null; set { } }
            public override int GetHashCode() => throw null;
            public int Length { get => throw null; set { } }
            public static bool operator ==(System.Drawing.CharacterRange cr1, System.Drawing.CharacterRange cr2) => throw null;
            public static bool operator !=(System.Drawing.CharacterRange cr1, System.Drawing.CharacterRange cr2) => throw null;
        }
        public enum ContentAlignment
        {
            TopLeft = 1,
            TopCenter = 2,
            TopRight = 4,
            MiddleLeft = 16,
            MiddleCenter = 32,
            MiddleRight = 64,
            BottomLeft = 256,
            BottomCenter = 512,
            BottomRight = 1024,
        }
        public enum CopyPixelOperation
        {
            NoMirrorBitmap = -2147483648,
            Blackness = 66,
            NotSourceErase = 1114278,
            NotSourceCopy = 3342344,
            SourceErase = 4457256,
            DestinationInvert = 5570569,
            PatInvert = 5898313,
            SourceInvert = 6684742,
            SourceAnd = 8913094,
            MergePaint = 12255782,
            MergeCopy = 12583114,
            SourceCopy = 13369376,
            SourcePaint = 15597702,
            PatCopy = 15728673,
            PatPaint = 16452105,
            Whiteness = 16711778,
            CaptureBlt = 1073741824,
        }
        namespace Design
        {
            public sealed class CategoryNameCollection : System.Collections.ReadOnlyCollectionBase
            {
                public bool Contains(string value) => throw null;
                public void CopyTo(string[] array, int index) => throw null;
                public CategoryNameCollection(System.Drawing.Design.CategoryNameCollection value) => throw null;
                public CategoryNameCollection(string[] value) => throw null;
                public int IndexOf(string value) => throw null;
                public string this[int index] { get => throw null; }
            }
        }
        namespace Drawing2D
        {
            public sealed class AdjustableArrowCap : System.Drawing.Drawing2D.CustomLineCap
            {
                public AdjustableArrowCap(float width, float height) : base(default(System.Drawing.Drawing2D.GraphicsPath), default(System.Drawing.Drawing2D.GraphicsPath)) => throw null;
                public AdjustableArrowCap(float width, float height, bool isFilled) : base(default(System.Drawing.Drawing2D.GraphicsPath), default(System.Drawing.Drawing2D.GraphicsPath)) => throw null;
                public bool Filled { get => throw null; set { } }
                public float Height { get => throw null; set { } }
                public float MiddleInset { get => throw null; set { } }
                public float Width { get => throw null; set { } }
            }
            public sealed class Blend
            {
                public Blend() => throw null;
                public Blend(int count) => throw null;
                public float[] Factors { get => throw null; set { } }
                public float[] Positions { get => throw null; set { } }
            }
            public sealed class ColorBlend
            {
                public System.Drawing.Color[] Colors { get => throw null; set { } }
                public ColorBlend() => throw null;
                public ColorBlend(int count) => throw null;
                public float[] Positions { get => throw null; set { } }
            }
            public enum CombineMode
            {
                Replace = 0,
                Intersect = 1,
                Union = 2,
                Xor = 3,
                Exclude = 4,
                Complement = 5,
            }
            public enum CompositingMode
            {
                SourceOver = 0,
                SourceCopy = 1,
            }
            public enum CompositingQuality
            {
                Invalid = -1,
                Default = 0,
                HighSpeed = 1,
                HighQuality = 2,
                GammaCorrected = 3,
                AssumeLinear = 4,
            }
            public enum CoordinateSpace
            {
                World = 0,
                Page = 1,
                Device = 2,
            }
            public class CustomLineCap : System.MarshalByRefObject, System.ICloneable, System.IDisposable
            {
                public System.Drawing.Drawing2D.LineCap BaseCap { get => throw null; set { } }
                public float BaseInset { get => throw null; set { } }
                public object Clone() => throw null;
                public CustomLineCap(System.Drawing.Drawing2D.GraphicsPath fillPath, System.Drawing.Drawing2D.GraphicsPath strokePath) => throw null;
                public CustomLineCap(System.Drawing.Drawing2D.GraphicsPath fillPath, System.Drawing.Drawing2D.GraphicsPath strokePath, System.Drawing.Drawing2D.LineCap baseCap) => throw null;
                public CustomLineCap(System.Drawing.Drawing2D.GraphicsPath fillPath, System.Drawing.Drawing2D.GraphicsPath strokePath, System.Drawing.Drawing2D.LineCap baseCap, float baseInset) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public void GetStrokeCaps(out System.Drawing.Drawing2D.LineCap startCap, out System.Drawing.Drawing2D.LineCap endCap) => throw null;
                public void SetStrokeCaps(System.Drawing.Drawing2D.LineCap startCap, System.Drawing.Drawing2D.LineCap endCap) => throw null;
                public System.Drawing.Drawing2D.LineJoin StrokeJoin { get => throw null; set { } }
                public float WidthScale { get => throw null; set { } }
            }
            public enum DashCap
            {
                Flat = 0,
                Round = 2,
                Triangle = 3,
            }
            public enum DashStyle
            {
                Solid = 0,
                Dash = 1,
                Dot = 2,
                DashDot = 3,
                DashDotDot = 4,
                Custom = 5,
            }
            public enum FillMode
            {
                Alternate = 0,
                Winding = 1,
            }
            public enum FlushIntention
            {
                Flush = 0,
                Sync = 1,
            }
            public sealed class GraphicsContainer : System.MarshalByRefObject
            {
            }
            public sealed class GraphicsPath : System.MarshalByRefObject, System.ICloneable, System.IDisposable
            {
                public void AddArc(System.Drawing.Rectangle rect, float startAngle, float sweepAngle) => throw null;
                public void AddArc(System.Drawing.RectangleF rect, float startAngle, float sweepAngle) => throw null;
                public void AddArc(int x, int y, int width, int height, float startAngle, float sweepAngle) => throw null;
                public void AddArc(float x, float y, float width, float height, float startAngle, float sweepAngle) => throw null;
                public void AddBezier(System.Drawing.Point pt1, System.Drawing.Point pt2, System.Drawing.Point pt3, System.Drawing.Point pt4) => throw null;
                public void AddBezier(System.Drawing.PointF pt1, System.Drawing.PointF pt2, System.Drawing.PointF pt3, System.Drawing.PointF pt4) => throw null;
                public void AddBezier(int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4) => throw null;
                public void AddBezier(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) => throw null;
                public void AddBeziers(System.Drawing.PointF[] points) => throw null;
                public void AddBeziers(params System.Drawing.Point[] points) => throw null;
                public void AddClosedCurve(System.Drawing.PointF[] points) => throw null;
                public void AddClosedCurve(System.Drawing.PointF[] points, float tension) => throw null;
                public void AddClosedCurve(System.Drawing.Point[] points) => throw null;
                public void AddClosedCurve(System.Drawing.Point[] points, float tension) => throw null;
                public void AddCurve(System.Drawing.PointF[] points) => throw null;
                public void AddCurve(System.Drawing.PointF[] points, int offset, int numberOfSegments, float tension) => throw null;
                public void AddCurve(System.Drawing.PointF[] points, float tension) => throw null;
                public void AddCurve(System.Drawing.Point[] points) => throw null;
                public void AddCurve(System.Drawing.Point[] points, int offset, int numberOfSegments, float tension) => throw null;
                public void AddCurve(System.Drawing.Point[] points, float tension) => throw null;
                public void AddEllipse(System.Drawing.Rectangle rect) => throw null;
                public void AddEllipse(System.Drawing.RectangleF rect) => throw null;
                public void AddEllipse(int x, int y, int width, int height) => throw null;
                public void AddEllipse(float x, float y, float width, float height) => throw null;
                public void AddLine(System.Drawing.Point pt1, System.Drawing.Point pt2) => throw null;
                public void AddLine(System.Drawing.PointF pt1, System.Drawing.PointF pt2) => throw null;
                public void AddLine(int x1, int y1, int x2, int y2) => throw null;
                public void AddLine(float x1, float y1, float x2, float y2) => throw null;
                public void AddLines(System.Drawing.PointF[] points) => throw null;
                public void AddLines(System.Drawing.Point[] points) => throw null;
                public void AddPath(System.Drawing.Drawing2D.GraphicsPath addingPath, bool connect) => throw null;
                public void AddPie(System.Drawing.Rectangle rect, float startAngle, float sweepAngle) => throw null;
                public void AddPie(int x, int y, int width, int height, float startAngle, float sweepAngle) => throw null;
                public void AddPie(float x, float y, float width, float height, float startAngle, float sweepAngle) => throw null;
                public void AddPolygon(System.Drawing.PointF[] points) => throw null;
                public void AddPolygon(System.Drawing.Point[] points) => throw null;
                public void AddRectangle(System.Drawing.Rectangle rect) => throw null;
                public void AddRectangle(System.Drawing.RectangleF rect) => throw null;
                public void AddRectangles(System.Drawing.RectangleF[] rects) => throw null;
                public void AddRectangles(System.Drawing.Rectangle[] rects) => throw null;
                public void AddString(string s, System.Drawing.FontFamily family, int style, float emSize, System.Drawing.Point origin, System.Drawing.StringFormat format) => throw null;
                public void AddString(string s, System.Drawing.FontFamily family, int style, float emSize, System.Drawing.PointF origin, System.Drawing.StringFormat format) => throw null;
                public void AddString(string s, System.Drawing.FontFamily family, int style, float emSize, System.Drawing.Rectangle layoutRect, System.Drawing.StringFormat format) => throw null;
                public void AddString(string s, System.Drawing.FontFamily family, int style, float emSize, System.Drawing.RectangleF layoutRect, System.Drawing.StringFormat format) => throw null;
                public void ClearMarkers() => throw null;
                public object Clone() => throw null;
                public void CloseAllFigures() => throw null;
                public void CloseFigure() => throw null;
                public GraphicsPath() => throw null;
                public GraphicsPath(System.Drawing.Drawing2D.FillMode fillMode) => throw null;
                public GraphicsPath(System.Drawing.PointF[] pts, byte[] types) => throw null;
                public GraphicsPath(System.Drawing.PointF[] pts, byte[] types, System.Drawing.Drawing2D.FillMode fillMode) => throw null;
                public GraphicsPath(System.Drawing.Point[] pts, byte[] types) => throw null;
                public GraphicsPath(System.Drawing.Point[] pts, byte[] types, System.Drawing.Drawing2D.FillMode fillMode) => throw null;
                public void Dispose() => throw null;
                public System.Drawing.Drawing2D.FillMode FillMode { get => throw null; set { } }
                public void Flatten() => throw null;
                public void Flatten(System.Drawing.Drawing2D.Matrix matrix) => throw null;
                public void Flatten(System.Drawing.Drawing2D.Matrix matrix, float flatness) => throw null;
                public System.Drawing.RectangleF GetBounds() => throw null;
                public System.Drawing.RectangleF GetBounds(System.Drawing.Drawing2D.Matrix matrix) => throw null;
                public System.Drawing.RectangleF GetBounds(System.Drawing.Drawing2D.Matrix matrix, System.Drawing.Pen pen) => throw null;
                public System.Drawing.PointF GetLastPoint() => throw null;
                public bool IsOutlineVisible(System.Drawing.Point point, System.Drawing.Pen pen) => throw null;
                public bool IsOutlineVisible(System.Drawing.Point pt, System.Drawing.Pen pen, System.Drawing.Graphics graphics) => throw null;
                public bool IsOutlineVisible(System.Drawing.PointF point, System.Drawing.Pen pen) => throw null;
                public bool IsOutlineVisible(System.Drawing.PointF pt, System.Drawing.Pen pen, System.Drawing.Graphics graphics) => throw null;
                public bool IsOutlineVisible(int x, int y, System.Drawing.Pen pen) => throw null;
                public bool IsOutlineVisible(int x, int y, System.Drawing.Pen pen, System.Drawing.Graphics graphics) => throw null;
                public bool IsOutlineVisible(float x, float y, System.Drawing.Pen pen) => throw null;
                public bool IsOutlineVisible(float x, float y, System.Drawing.Pen pen, System.Drawing.Graphics graphics) => throw null;
                public bool IsVisible(System.Drawing.Point point) => throw null;
                public bool IsVisible(System.Drawing.Point pt, System.Drawing.Graphics graphics) => throw null;
                public bool IsVisible(System.Drawing.PointF point) => throw null;
                public bool IsVisible(System.Drawing.PointF pt, System.Drawing.Graphics graphics) => throw null;
                public bool IsVisible(int x, int y) => throw null;
                public bool IsVisible(int x, int y, System.Drawing.Graphics graphics) => throw null;
                public bool IsVisible(float x, float y) => throw null;
                public bool IsVisible(float x, float y, System.Drawing.Graphics graphics) => throw null;
                public System.Drawing.Drawing2D.PathData PathData { get => throw null; }
                public System.Drawing.PointF[] PathPoints { get => throw null; }
                public byte[] PathTypes { get => throw null; }
                public int PointCount { get => throw null; }
                public void Reset() => throw null;
                public void Reverse() => throw null;
                public void SetMarkers() => throw null;
                public void StartFigure() => throw null;
                public void Transform(System.Drawing.Drawing2D.Matrix matrix) => throw null;
                public void Warp(System.Drawing.PointF[] destPoints, System.Drawing.RectangleF srcRect) => throw null;
                public void Warp(System.Drawing.PointF[] destPoints, System.Drawing.RectangleF srcRect, System.Drawing.Drawing2D.Matrix matrix) => throw null;
                public void Warp(System.Drawing.PointF[] destPoints, System.Drawing.RectangleF srcRect, System.Drawing.Drawing2D.Matrix matrix, System.Drawing.Drawing2D.WarpMode warpMode) => throw null;
                public void Warp(System.Drawing.PointF[] destPoints, System.Drawing.RectangleF srcRect, System.Drawing.Drawing2D.Matrix matrix, System.Drawing.Drawing2D.WarpMode warpMode, float flatness) => throw null;
                public void Widen(System.Drawing.Pen pen) => throw null;
                public void Widen(System.Drawing.Pen pen, System.Drawing.Drawing2D.Matrix matrix) => throw null;
                public void Widen(System.Drawing.Pen pen, System.Drawing.Drawing2D.Matrix matrix, float flatness) => throw null;
            }
            public sealed class GraphicsPathIterator : System.MarshalByRefObject, System.IDisposable
            {
                public int CopyData(ref System.Drawing.PointF[] points, ref byte[] types, int startIndex, int endIndex) => throw null;
                public int Count { get => throw null; }
                public GraphicsPathIterator(System.Drawing.Drawing2D.GraphicsPath path) => throw null;
                public void Dispose() => throw null;
                public int Enumerate(ref System.Drawing.PointF[] points, ref byte[] types) => throw null;
                public bool HasCurve() => throw null;
                public int NextMarker(System.Drawing.Drawing2D.GraphicsPath path) => throw null;
                public int NextMarker(out int startIndex, out int endIndex) => throw null;
                public int NextPathType(out byte pathType, out int startIndex, out int endIndex) => throw null;
                public int NextSubpath(System.Drawing.Drawing2D.GraphicsPath path, out bool isClosed) => throw null;
                public int NextSubpath(out int startIndex, out int endIndex, out bool isClosed) => throw null;
                public void Rewind() => throw null;
                public int SubpathCount { get => throw null; }
            }
            public sealed class GraphicsState : System.MarshalByRefObject
            {
            }
            public sealed class HatchBrush : System.Drawing.Brush
            {
                public System.Drawing.Color BackgroundColor { get => throw null; }
                public override object Clone() => throw null;
                public HatchBrush(System.Drawing.Drawing2D.HatchStyle hatchstyle, System.Drawing.Color foreColor) => throw null;
                public HatchBrush(System.Drawing.Drawing2D.HatchStyle hatchstyle, System.Drawing.Color foreColor, System.Drawing.Color backColor) => throw null;
                public System.Drawing.Color ForegroundColor { get => throw null; }
                public System.Drawing.Drawing2D.HatchStyle HatchStyle { get => throw null; }
            }
            public enum HatchStyle
            {
                Horizontal = 0,
                Min = 0,
                Vertical = 1,
                ForwardDiagonal = 2,
                BackwardDiagonal = 3,
                Cross = 4,
                LargeGrid = 4,
                Max = 4,
                DiagonalCross = 5,
                Percent05 = 6,
                Percent10 = 7,
                Percent20 = 8,
                Percent25 = 9,
                Percent30 = 10,
                Percent40 = 11,
                Percent50 = 12,
                Percent60 = 13,
                Percent70 = 14,
                Percent75 = 15,
                Percent80 = 16,
                Percent90 = 17,
                LightDownwardDiagonal = 18,
                LightUpwardDiagonal = 19,
                DarkDownwardDiagonal = 20,
                DarkUpwardDiagonal = 21,
                WideDownwardDiagonal = 22,
                WideUpwardDiagonal = 23,
                LightVertical = 24,
                LightHorizontal = 25,
                NarrowVertical = 26,
                NarrowHorizontal = 27,
                DarkVertical = 28,
                DarkHorizontal = 29,
                DashedDownwardDiagonal = 30,
                DashedUpwardDiagonal = 31,
                DashedHorizontal = 32,
                DashedVertical = 33,
                SmallConfetti = 34,
                LargeConfetti = 35,
                ZigZag = 36,
                Wave = 37,
                DiagonalBrick = 38,
                HorizontalBrick = 39,
                Weave = 40,
                Plaid = 41,
                Divot = 42,
                DottedGrid = 43,
                DottedDiamond = 44,
                Shingle = 45,
                Trellis = 46,
                Sphere = 47,
                SmallGrid = 48,
                SmallCheckerBoard = 49,
                LargeCheckerBoard = 50,
                OutlinedDiamond = 51,
                SolidDiamond = 52,
            }
            public enum InterpolationMode
            {
                Invalid = -1,
                Default = 0,
                Low = 1,
                High = 2,
                Bilinear = 3,
                Bicubic = 4,
                NearestNeighbor = 5,
                HighQualityBilinear = 6,
                HighQualityBicubic = 7,
            }
            public sealed class LinearGradientBrush : System.Drawing.Brush
            {
                public System.Drawing.Drawing2D.Blend Blend { get => throw null; set { } }
                public override object Clone() => throw null;
                public LinearGradientBrush(System.Drawing.Point point1, System.Drawing.Point point2, System.Drawing.Color color1, System.Drawing.Color color2) => throw null;
                public LinearGradientBrush(System.Drawing.PointF point1, System.Drawing.PointF point2, System.Drawing.Color color1, System.Drawing.Color color2) => throw null;
                public LinearGradientBrush(System.Drawing.Rectangle rect, System.Drawing.Color color1, System.Drawing.Color color2, System.Drawing.Drawing2D.LinearGradientMode linearGradientMode) => throw null;
                public LinearGradientBrush(System.Drawing.Rectangle rect, System.Drawing.Color color1, System.Drawing.Color color2, float angle) => throw null;
                public LinearGradientBrush(System.Drawing.Rectangle rect, System.Drawing.Color color1, System.Drawing.Color color2, float angle, bool isAngleScaleable) => throw null;
                public LinearGradientBrush(System.Drawing.RectangleF rect, System.Drawing.Color color1, System.Drawing.Color color2, System.Drawing.Drawing2D.LinearGradientMode linearGradientMode) => throw null;
                public LinearGradientBrush(System.Drawing.RectangleF rect, System.Drawing.Color color1, System.Drawing.Color color2, float angle) => throw null;
                public LinearGradientBrush(System.Drawing.RectangleF rect, System.Drawing.Color color1, System.Drawing.Color color2, float angle, bool isAngleScaleable) => throw null;
                public bool GammaCorrection { get => throw null; set { } }
                public System.Drawing.Drawing2D.ColorBlend InterpolationColors { get => throw null; set { } }
                public System.Drawing.Color[] LinearColors { get => throw null; set { } }
                public void MultiplyTransform(System.Drawing.Drawing2D.Matrix matrix) => throw null;
                public void MultiplyTransform(System.Drawing.Drawing2D.Matrix matrix, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
                public System.Drawing.RectangleF Rectangle { get => throw null; }
                public void ResetTransform() => throw null;
                public void RotateTransform(float angle) => throw null;
                public void RotateTransform(float angle, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
                public void ScaleTransform(float sx, float sy) => throw null;
                public void ScaleTransform(float sx, float sy, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
                public void SetBlendTriangularShape(float focus) => throw null;
                public void SetBlendTriangularShape(float focus, float scale) => throw null;
                public void SetSigmaBellShape(float focus) => throw null;
                public void SetSigmaBellShape(float focus, float scale) => throw null;
                public System.Drawing.Drawing2D.Matrix Transform { get => throw null; set { } }
                public void TranslateTransform(float dx, float dy) => throw null;
                public void TranslateTransform(float dx, float dy, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
                public System.Drawing.Drawing2D.WrapMode WrapMode { get => throw null; set { } }
            }
            public enum LinearGradientMode
            {
                Horizontal = 0,
                Vertical = 1,
                ForwardDiagonal = 2,
                BackwardDiagonal = 3,
            }
            public enum LineCap
            {
                Flat = 0,
                Square = 1,
                Round = 2,
                Triangle = 3,
                NoAnchor = 16,
                SquareAnchor = 17,
                RoundAnchor = 18,
                DiamondAnchor = 19,
                ArrowAnchor = 20,
                AnchorMask = 240,
                Custom = 255,
            }
            public enum LineJoin
            {
                Miter = 0,
                Bevel = 1,
                Round = 2,
                MiterClipped = 3,
            }
            public sealed class Matrix : System.MarshalByRefObject, System.IDisposable
            {
                public System.Drawing.Drawing2D.Matrix Clone() => throw null;
                public Matrix() => throw null;
                public Matrix(System.Drawing.Rectangle rect, System.Drawing.Point[] plgpts) => throw null;
                public Matrix(System.Drawing.RectangleF rect, System.Drawing.PointF[] plgpts) => throw null;
                public Matrix(float m11, float m12, float m21, float m22, float dx, float dy) => throw null;
                public Matrix(System.Numerics.Matrix3x2 matrix) => throw null;
                public void Dispose() => throw null;
                public float[] Elements { get => throw null; }
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public void Invert() => throw null;
                public bool IsIdentity { get => throw null; }
                public bool IsInvertible { get => throw null; }
                public System.Numerics.Matrix3x2 MatrixElements { get => throw null; set { } }
                public void Multiply(System.Drawing.Drawing2D.Matrix matrix) => throw null;
                public void Multiply(System.Drawing.Drawing2D.Matrix matrix, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
                public float OffsetX { get => throw null; }
                public float OffsetY { get => throw null; }
                public void Reset() => throw null;
                public void Rotate(float angle) => throw null;
                public void Rotate(float angle, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
                public void RotateAt(float angle, System.Drawing.PointF point) => throw null;
                public void RotateAt(float angle, System.Drawing.PointF point, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
                public void Scale(float scaleX, float scaleY) => throw null;
                public void Scale(float scaleX, float scaleY, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
                public void Shear(float shearX, float shearY) => throw null;
                public void Shear(float shearX, float shearY, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
                public void TransformPoints(System.Drawing.PointF[] pts) => throw null;
                public void TransformPoints(System.Drawing.Point[] pts) => throw null;
                public void TransformVectors(System.Drawing.PointF[] pts) => throw null;
                public void TransformVectors(System.Drawing.Point[] pts) => throw null;
                public void Translate(float offsetX, float offsetY) => throw null;
                public void Translate(float offsetX, float offsetY, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
                public void VectorTransformPoints(System.Drawing.Point[] pts) => throw null;
            }
            public enum MatrixOrder
            {
                Prepend = 0,
                Append = 1,
            }
            public sealed class PathData
            {
                public PathData() => throw null;
                public System.Drawing.PointF[] Points { get => throw null; set { } }
                public byte[] Types { get => throw null; set { } }
            }
            public sealed class PathGradientBrush : System.Drawing.Brush
            {
                public System.Drawing.Drawing2D.Blend Blend { get => throw null; set { } }
                public System.Drawing.Color CenterColor { get => throw null; set { } }
                public System.Drawing.PointF CenterPoint { get => throw null; set { } }
                public override object Clone() => throw null;
                public PathGradientBrush(System.Drawing.Drawing2D.GraphicsPath path) => throw null;
                public PathGradientBrush(System.Drawing.PointF[] points) => throw null;
                public PathGradientBrush(System.Drawing.PointF[] points, System.Drawing.Drawing2D.WrapMode wrapMode) => throw null;
                public PathGradientBrush(System.Drawing.Point[] points) => throw null;
                public PathGradientBrush(System.Drawing.Point[] points, System.Drawing.Drawing2D.WrapMode wrapMode) => throw null;
                public System.Drawing.PointF FocusScales { get => throw null; set { } }
                public System.Drawing.Drawing2D.ColorBlend InterpolationColors { get => throw null; set { } }
                public void MultiplyTransform(System.Drawing.Drawing2D.Matrix matrix) => throw null;
                public void MultiplyTransform(System.Drawing.Drawing2D.Matrix matrix, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
                public System.Drawing.RectangleF Rectangle { get => throw null; }
                public void ResetTransform() => throw null;
                public void RotateTransform(float angle) => throw null;
                public void RotateTransform(float angle, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
                public void ScaleTransform(float sx, float sy) => throw null;
                public void ScaleTransform(float sx, float sy, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
                public void SetBlendTriangularShape(float focus) => throw null;
                public void SetBlendTriangularShape(float focus, float scale) => throw null;
                public void SetSigmaBellShape(float focus) => throw null;
                public void SetSigmaBellShape(float focus, float scale) => throw null;
                public System.Drawing.Color[] SurroundColors { get => throw null; set { } }
                public System.Drawing.Drawing2D.Matrix Transform { get => throw null; set { } }
                public void TranslateTransform(float dx, float dy) => throw null;
                public void TranslateTransform(float dx, float dy, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
                public System.Drawing.Drawing2D.WrapMode WrapMode { get => throw null; set { } }
            }
            public enum PathPointType
            {
                Start = 0,
                Line = 1,
                Bezier = 3,
                Bezier3 = 3,
                PathTypeMask = 7,
                DashMode = 16,
                PathMarker = 32,
                CloseSubpath = 128,
            }
            public enum PenAlignment
            {
                Center = 0,
                Inset = 1,
                Outset = 2,
                Left = 3,
                Right = 4,
            }
            public enum PenType
            {
                SolidColor = 0,
                HatchFill = 1,
                TextureFill = 2,
                PathGradient = 3,
                LinearGradient = 4,
            }
            public enum PixelOffsetMode
            {
                Invalid = -1,
                Default = 0,
                HighSpeed = 1,
                HighQuality = 2,
                None = 3,
                Half = 4,
            }
            public enum QualityMode
            {
                Invalid = -1,
                Default = 0,
                Low = 1,
                High = 2,
            }
            public sealed class RegionData
            {
                public byte[] Data { get => throw null; set { } }
            }
            public enum SmoothingMode
            {
                Invalid = -1,
                Default = 0,
                HighSpeed = 1,
                HighQuality = 2,
                None = 3,
                AntiAlias = 4,
            }
            public enum WarpMode
            {
                Perspective = 0,
                Bilinear = 1,
            }
            public enum WrapMode
            {
                Tile = 0,
                TileFlipX = 1,
                TileFlipY = 2,
                TileFlipXY = 3,
                Clamp = 4,
            }
        }
        public sealed class Font : System.MarshalByRefObject, System.ICloneable, System.IDisposable, System.Runtime.Serialization.ISerializable
        {
            public bool Bold { get => throw null; }
            public object Clone() => throw null;
            public Font(System.Drawing.Font prototype, System.Drawing.FontStyle newStyle) => throw null;
            public Font(System.Drawing.FontFamily family, float emSize) => throw null;
            public Font(System.Drawing.FontFamily family, float emSize, System.Drawing.FontStyle style) => throw null;
            public Font(System.Drawing.FontFamily family, float emSize, System.Drawing.FontStyle style, System.Drawing.GraphicsUnit unit) => throw null;
            public Font(System.Drawing.FontFamily family, float emSize, System.Drawing.FontStyle style, System.Drawing.GraphicsUnit unit, byte gdiCharSet) => throw null;
            public Font(System.Drawing.FontFamily family, float emSize, System.Drawing.FontStyle style, System.Drawing.GraphicsUnit unit, byte gdiCharSet, bool gdiVerticalFont) => throw null;
            public Font(System.Drawing.FontFamily family, float emSize, System.Drawing.GraphicsUnit unit) => throw null;
            public Font(string familyName, float emSize) => throw null;
            public Font(string familyName, float emSize, System.Drawing.FontStyle style) => throw null;
            public Font(string familyName, float emSize, System.Drawing.FontStyle style, System.Drawing.GraphicsUnit unit) => throw null;
            public Font(string familyName, float emSize, System.Drawing.FontStyle style, System.Drawing.GraphicsUnit unit, byte gdiCharSet) => throw null;
            public Font(string familyName, float emSize, System.Drawing.FontStyle style, System.Drawing.GraphicsUnit unit, byte gdiCharSet, bool gdiVerticalFont) => throw null;
            public Font(string familyName, float emSize, System.Drawing.GraphicsUnit unit) => throw null;
            public void Dispose() => throw null;
            public override bool Equals(object obj) => throw null;
            public System.Drawing.FontFamily FontFamily { get => throw null; }
            public static System.Drawing.Font FromHdc(nint hdc) => throw null;
            public static System.Drawing.Font FromHfont(nint hfont) => throw null;
            public static System.Drawing.Font FromLogFont(object lf) => throw null;
            public static System.Drawing.Font FromLogFont(object lf, nint hdc) => throw null;
            public byte GdiCharSet { get => throw null; }
            public bool GdiVerticalFont { get => throw null; }
            public override int GetHashCode() => throw null;
            public float GetHeight() => throw null;
            public float GetHeight(System.Drawing.Graphics graphics) => throw null;
            public float GetHeight(float dpi) => throw null;
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
            public nint ToHfont() => throw null;
            public void ToLogFont(object logFont) => throw null;
            public void ToLogFont(object logFont, System.Drawing.Graphics graphics) => throw null;
            public override string ToString() => throw null;
            public bool Underline { get => throw null; }
            public System.Drawing.GraphicsUnit Unit { get => throw null; }
        }
        public class FontConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public override object CreateInstance(System.ComponentModel.ITypeDescriptorContext context, System.Collections.IDictionary propertyValues) => throw null;
            public FontConverter() => throw null;
            public sealed class FontNameConverter : System.ComponentModel.TypeConverter, System.IDisposable
            {
                public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
                public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
                public FontNameConverter() => throw null;
                void System.IDisposable.Dispose() => throw null;
                public override System.ComponentModel.TypeConverter.StandardValuesCollection GetStandardValues(System.ComponentModel.ITypeDescriptorContext context) => throw null;
                public override bool GetStandardValuesExclusive(System.ComponentModel.ITypeDescriptorContext context) => throw null;
                public override bool GetStandardValuesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            }
            public class FontUnitConverter : System.ComponentModel.EnumConverter
            {
                public FontUnitConverter() : base(default(System.Type)) => throw null;
                public override System.ComponentModel.TypeConverter.StandardValuesCollection GetStandardValues(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            }
            public override bool GetCreateInstanceSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override System.ComponentModel.PropertyDescriptorCollection GetProperties(System.ComponentModel.ITypeDescriptorContext context, object value, System.Attribute[] attributes) => throw null;
            public override bool GetPropertiesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
        }
        public sealed class FontFamily : System.MarshalByRefObject, System.IDisposable
        {
            public FontFamily(System.Drawing.Text.GenericFontFamilies genericFamily) => throw null;
            public FontFamily(string name) => throw null;
            public FontFamily(string name, System.Drawing.Text.FontCollection fontCollection) => throw null;
            public void Dispose() => throw null;
            public override bool Equals(object obj) => throw null;
            public static System.Drawing.FontFamily[] Families { get => throw null; }
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
        }
        [System.Flags]
        public enum FontStyle
        {
            Regular = 0,
            Bold = 1,
            Italic = 2,
            Underline = 4,
            Strikeout = 8,
        }
        public sealed class Graphics : System.MarshalByRefObject, System.Drawing.IDeviceContext, System.IDisposable
        {
            public void AddMetafileComment(byte[] data) => throw null;
            public System.Drawing.Drawing2D.GraphicsContainer BeginContainer() => throw null;
            public System.Drawing.Drawing2D.GraphicsContainer BeginContainer(System.Drawing.Rectangle dstrect, System.Drawing.Rectangle srcrect, System.Drawing.GraphicsUnit unit) => throw null;
            public System.Drawing.Drawing2D.GraphicsContainer BeginContainer(System.Drawing.RectangleF dstrect, System.Drawing.RectangleF srcrect, System.Drawing.GraphicsUnit unit) => throw null;
            public void Clear(System.Drawing.Color color) => throw null;
            public System.Drawing.Region Clip { get => throw null; set { } }
            public System.Drawing.RectangleF ClipBounds { get => throw null; }
            public System.Drawing.Drawing2D.CompositingMode CompositingMode { get => throw null; set { } }
            public System.Drawing.Drawing2D.CompositingQuality CompositingQuality { get => throw null; set { } }
            public void CopyFromScreen(System.Drawing.Point upperLeftSource, System.Drawing.Point upperLeftDestination, System.Drawing.Size blockRegionSize) => throw null;
            public void CopyFromScreen(System.Drawing.Point upperLeftSource, System.Drawing.Point upperLeftDestination, System.Drawing.Size blockRegionSize, System.Drawing.CopyPixelOperation copyPixelOperation) => throw null;
            public void CopyFromScreen(int sourceX, int sourceY, int destinationX, int destinationY, System.Drawing.Size blockRegionSize) => throw null;
            public void CopyFromScreen(int sourceX, int sourceY, int destinationX, int destinationY, System.Drawing.Size blockRegionSize, System.Drawing.CopyPixelOperation copyPixelOperation) => throw null;
            public void Dispose() => throw null;
            public float DpiX { get => throw null; }
            public float DpiY { get => throw null; }
            public void DrawArc(System.Drawing.Pen pen, System.Drawing.Rectangle rect, float startAngle, float sweepAngle) => throw null;
            public void DrawArc(System.Drawing.Pen pen, System.Drawing.RectangleF rect, float startAngle, float sweepAngle) => throw null;
            public void DrawArc(System.Drawing.Pen pen, int x, int y, int width, int height, int startAngle, int sweepAngle) => throw null;
            public void DrawArc(System.Drawing.Pen pen, float x, float y, float width, float height, float startAngle, float sweepAngle) => throw null;
            public void DrawBezier(System.Drawing.Pen pen, System.Drawing.Point pt1, System.Drawing.Point pt2, System.Drawing.Point pt3, System.Drawing.Point pt4) => throw null;
            public void DrawBezier(System.Drawing.Pen pen, System.Drawing.PointF pt1, System.Drawing.PointF pt2, System.Drawing.PointF pt3, System.Drawing.PointF pt4) => throw null;
            public void DrawBezier(System.Drawing.Pen pen, float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) => throw null;
            public void DrawBeziers(System.Drawing.Pen pen, System.Drawing.PointF[] points) => throw null;
            public void DrawBeziers(System.Drawing.Pen pen, System.Drawing.Point[] points) => throw null;
            public void DrawClosedCurve(System.Drawing.Pen pen, System.Drawing.PointF[] points) => throw null;
            public void DrawClosedCurve(System.Drawing.Pen pen, System.Drawing.PointF[] points, float tension, System.Drawing.Drawing2D.FillMode fillmode) => throw null;
            public void DrawClosedCurve(System.Drawing.Pen pen, System.Drawing.Point[] points) => throw null;
            public void DrawClosedCurve(System.Drawing.Pen pen, System.Drawing.Point[] points, float tension, System.Drawing.Drawing2D.FillMode fillmode) => throw null;
            public void DrawCurve(System.Drawing.Pen pen, System.Drawing.PointF[] points) => throw null;
            public void DrawCurve(System.Drawing.Pen pen, System.Drawing.PointF[] points, int offset, int numberOfSegments) => throw null;
            public void DrawCurve(System.Drawing.Pen pen, System.Drawing.PointF[] points, int offset, int numberOfSegments, float tension) => throw null;
            public void DrawCurve(System.Drawing.Pen pen, System.Drawing.PointF[] points, float tension) => throw null;
            public void DrawCurve(System.Drawing.Pen pen, System.Drawing.Point[] points) => throw null;
            public void DrawCurve(System.Drawing.Pen pen, System.Drawing.Point[] points, int offset, int numberOfSegments, float tension) => throw null;
            public void DrawCurve(System.Drawing.Pen pen, System.Drawing.Point[] points, float tension) => throw null;
            public void DrawEllipse(System.Drawing.Pen pen, System.Drawing.Rectangle rect) => throw null;
            public void DrawEllipse(System.Drawing.Pen pen, System.Drawing.RectangleF rect) => throw null;
            public void DrawEllipse(System.Drawing.Pen pen, int x, int y, int width, int height) => throw null;
            public void DrawEllipse(System.Drawing.Pen pen, float x, float y, float width, float height) => throw null;
            public void DrawIcon(System.Drawing.Icon icon, System.Drawing.Rectangle targetRect) => throw null;
            public void DrawIcon(System.Drawing.Icon icon, int x, int y) => throw null;
            public void DrawIconUnstretched(System.Drawing.Icon icon, System.Drawing.Rectangle targetRect) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Point point) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.PointF point) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.PointF[] destPoints) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.PointF[] destPoints, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit srcUnit) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.PointF[] destPoints, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.PointF[] destPoints, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Imaging.ImageAttributes imageAttr, System.Drawing.Graphics.DrawImageAbort callback) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.PointF[] destPoints, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Imaging.ImageAttributes imageAttr, System.Drawing.Graphics.DrawImageAbort callback, int callbackData) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Point[] destPoints) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Point[] destPoints, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit srcUnit) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Point[] destPoints, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Point[] destPoints, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Imaging.ImageAttributes imageAttr, System.Drawing.Graphics.DrawImageAbort callback) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Point[] destPoints, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Imaging.ImageAttributes imageAttr, System.Drawing.Graphics.DrawImageAbort callback, int callbackData) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Rectangle rect) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Rectangle destRect, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit srcUnit) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Rectangle destRect, int srcX, int srcY, int srcWidth, int srcHeight, System.Drawing.GraphicsUnit srcUnit) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Rectangle destRect, int srcX, int srcY, int srcWidth, int srcHeight, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Rectangle destRect, int srcX, int srcY, int srcWidth, int srcHeight, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Imaging.ImageAttributes imageAttr, System.Drawing.Graphics.DrawImageAbort callback) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Rectangle destRect, int srcX, int srcY, int srcWidth, int srcHeight, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Imaging.ImageAttributes imageAttrs, System.Drawing.Graphics.DrawImageAbort callback, nint callbackData) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Rectangle destRect, float srcX, float srcY, float srcWidth, float srcHeight, System.Drawing.GraphicsUnit srcUnit) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Rectangle destRect, float srcX, float srcY, float srcWidth, float srcHeight, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Imaging.ImageAttributes imageAttrs) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Rectangle destRect, float srcX, float srcY, float srcWidth, float srcHeight, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Imaging.ImageAttributes imageAttrs, System.Drawing.Graphics.DrawImageAbort callback) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.Rectangle destRect, float srcX, float srcY, float srcWidth, float srcHeight, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Imaging.ImageAttributes imageAttrs, System.Drawing.Graphics.DrawImageAbort callback, nint callbackData) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.RectangleF rect) => throw null;
            public void DrawImage(System.Drawing.Image image, System.Drawing.RectangleF destRect, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit srcUnit) => throw null;
            public void DrawImage(System.Drawing.Image image, int x, int y) => throw null;
            public void DrawImage(System.Drawing.Image image, int x, int y, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit srcUnit) => throw null;
            public void DrawImage(System.Drawing.Image image, int x, int y, int width, int height) => throw null;
            public void DrawImage(System.Drawing.Image image, float x, float y) => throw null;
            public void DrawImage(System.Drawing.Image image, float x, float y, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit srcUnit) => throw null;
            public void DrawImage(System.Drawing.Image image, float x, float y, float width, float height) => throw null;
            public delegate bool DrawImageAbort(nint callbackdata);
            public void DrawImageUnscaled(System.Drawing.Image image, System.Drawing.Point point) => throw null;
            public void DrawImageUnscaled(System.Drawing.Image image, System.Drawing.Rectangle rect) => throw null;
            public void DrawImageUnscaled(System.Drawing.Image image, int x, int y) => throw null;
            public void DrawImageUnscaled(System.Drawing.Image image, int x, int y, int width, int height) => throw null;
            public void DrawImageUnscaledAndClipped(System.Drawing.Image image, System.Drawing.Rectangle rect) => throw null;
            public void DrawLine(System.Drawing.Pen pen, System.Drawing.Point pt1, System.Drawing.Point pt2) => throw null;
            public void DrawLine(System.Drawing.Pen pen, System.Drawing.PointF pt1, System.Drawing.PointF pt2) => throw null;
            public void DrawLine(System.Drawing.Pen pen, int x1, int y1, int x2, int y2) => throw null;
            public void DrawLine(System.Drawing.Pen pen, float x1, float y1, float x2, float y2) => throw null;
            public void DrawLines(System.Drawing.Pen pen, System.Drawing.PointF[] points) => throw null;
            public void DrawLines(System.Drawing.Pen pen, System.Drawing.Point[] points) => throw null;
            public void DrawPath(System.Drawing.Pen pen, System.Drawing.Drawing2D.GraphicsPath path) => throw null;
            public void DrawPie(System.Drawing.Pen pen, System.Drawing.Rectangle rect, float startAngle, float sweepAngle) => throw null;
            public void DrawPie(System.Drawing.Pen pen, System.Drawing.RectangleF rect, float startAngle, float sweepAngle) => throw null;
            public void DrawPie(System.Drawing.Pen pen, int x, int y, int width, int height, int startAngle, int sweepAngle) => throw null;
            public void DrawPie(System.Drawing.Pen pen, float x, float y, float width, float height, float startAngle, float sweepAngle) => throw null;
            public void DrawPolygon(System.Drawing.Pen pen, System.Drawing.PointF[] points) => throw null;
            public void DrawPolygon(System.Drawing.Pen pen, System.Drawing.Point[] points) => throw null;
            public void DrawRectangle(System.Drawing.Pen pen, System.Drawing.Rectangle rect) => throw null;
            public void DrawRectangle(System.Drawing.Pen pen, int x, int y, int width, int height) => throw null;
            public void DrawRectangle(System.Drawing.Pen pen, float x, float y, float width, float height) => throw null;
            public void DrawRectangles(System.Drawing.Pen pen, System.Drawing.RectangleF[] rects) => throw null;
            public void DrawRectangles(System.Drawing.Pen pen, System.Drawing.Rectangle[] rects) => throw null;
            public void DrawString(string s, System.Drawing.Font font, System.Drawing.Brush brush, System.Drawing.PointF point) => throw null;
            public void DrawString(string s, System.Drawing.Font font, System.Drawing.Brush brush, System.Drawing.PointF point, System.Drawing.StringFormat format) => throw null;
            public void DrawString(string s, System.Drawing.Font font, System.Drawing.Brush brush, System.Drawing.RectangleF layoutRectangle) => throw null;
            public void DrawString(string s, System.Drawing.Font font, System.Drawing.Brush brush, System.Drawing.RectangleF layoutRectangle, System.Drawing.StringFormat format) => throw null;
            public void DrawString(string s, System.Drawing.Font font, System.Drawing.Brush brush, float x, float y) => throw null;
            public void DrawString(string s, System.Drawing.Font font, System.Drawing.Brush brush, float x, float y, System.Drawing.StringFormat format) => throw null;
            public void EndContainer(System.Drawing.Drawing2D.GraphicsContainer container) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Point destPoint, System.Drawing.Graphics.EnumerateMetafileProc callback) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Point destPoint, System.Drawing.Graphics.EnumerateMetafileProc callback, nint callbackData) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Point destPoint, System.Drawing.Graphics.EnumerateMetafileProc callback, nint callbackData, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Point destPoint, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Graphics.EnumerateMetafileProc callback) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Point destPoint, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Graphics.EnumerateMetafileProc callback, nint callbackData) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Point destPoint, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit unit, System.Drawing.Graphics.EnumerateMetafileProc callback, nint callbackData, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.PointF destPoint, System.Drawing.Graphics.EnumerateMetafileProc callback) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.PointF destPoint, System.Drawing.Graphics.EnumerateMetafileProc callback, nint callbackData) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.PointF destPoint, System.Drawing.Graphics.EnumerateMetafileProc callback, nint callbackData, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.PointF destPoint, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Graphics.EnumerateMetafileProc callback) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.PointF destPoint, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Graphics.EnumerateMetafileProc callback, nint callbackData) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.PointF destPoint, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit unit, System.Drawing.Graphics.EnumerateMetafileProc callback, nint callbackData, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.PointF[] destPoints, System.Drawing.Graphics.EnumerateMetafileProc callback) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.PointF[] destPoints, System.Drawing.Graphics.EnumerateMetafileProc callback, nint callbackData) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.PointF[] destPoints, System.Drawing.Graphics.EnumerateMetafileProc callback, nint callbackData, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.PointF[] destPoints, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Graphics.EnumerateMetafileProc callback) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.PointF[] destPoints, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Graphics.EnumerateMetafileProc callback, nint callbackData) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.PointF[] destPoints, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit unit, System.Drawing.Graphics.EnumerateMetafileProc callback, nint callbackData, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Point[] destPoints, System.Drawing.Graphics.EnumerateMetafileProc callback) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Point[] destPoints, System.Drawing.Graphics.EnumerateMetafileProc callback, nint callbackData) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Point[] destPoints, System.Drawing.Graphics.EnumerateMetafileProc callback, nint callbackData, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Point[] destPoints, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Graphics.EnumerateMetafileProc callback) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Point[] destPoints, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Graphics.EnumerateMetafileProc callback, nint callbackData) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Point[] destPoints, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit unit, System.Drawing.Graphics.EnumerateMetafileProc callback, nint callbackData, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Rectangle destRect, System.Drawing.Graphics.EnumerateMetafileProc callback) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Rectangle destRect, System.Drawing.Graphics.EnumerateMetafileProc callback, nint callbackData) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Rectangle destRect, System.Drawing.Graphics.EnumerateMetafileProc callback, nint callbackData, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Rectangle destRect, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Graphics.EnumerateMetafileProc callback) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Rectangle destRect, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Graphics.EnumerateMetafileProc callback, nint callbackData) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.Rectangle destRect, System.Drawing.Rectangle srcRect, System.Drawing.GraphicsUnit unit, System.Drawing.Graphics.EnumerateMetafileProc callback, nint callbackData, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.RectangleF destRect, System.Drawing.Graphics.EnumerateMetafileProc callback) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.RectangleF destRect, System.Drawing.Graphics.EnumerateMetafileProc callback, nint callbackData) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.RectangleF destRect, System.Drawing.Graphics.EnumerateMetafileProc callback, nint callbackData, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.RectangleF destRect, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Graphics.EnumerateMetafileProc callback) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.RectangleF destRect, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit srcUnit, System.Drawing.Graphics.EnumerateMetafileProc callback, nint callbackData) => throw null;
            public void EnumerateMetafile(System.Drawing.Imaging.Metafile metafile, System.Drawing.RectangleF destRect, System.Drawing.RectangleF srcRect, System.Drawing.GraphicsUnit unit, System.Drawing.Graphics.EnumerateMetafileProc callback, nint callbackData, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public delegate bool EnumerateMetafileProc(System.Drawing.Imaging.EmfPlusRecordType recordType, int flags, int dataSize, nint data, System.Drawing.Imaging.PlayRecordCallback callbackData);
            public void ExcludeClip(System.Drawing.Rectangle rect) => throw null;
            public void ExcludeClip(System.Drawing.Region region) => throw null;
            public void FillClosedCurve(System.Drawing.Brush brush, System.Drawing.PointF[] points) => throw null;
            public void FillClosedCurve(System.Drawing.Brush brush, System.Drawing.PointF[] points, System.Drawing.Drawing2D.FillMode fillmode) => throw null;
            public void FillClosedCurve(System.Drawing.Brush brush, System.Drawing.PointF[] points, System.Drawing.Drawing2D.FillMode fillmode, float tension) => throw null;
            public void FillClosedCurve(System.Drawing.Brush brush, System.Drawing.Point[] points) => throw null;
            public void FillClosedCurve(System.Drawing.Brush brush, System.Drawing.Point[] points, System.Drawing.Drawing2D.FillMode fillmode) => throw null;
            public void FillClosedCurve(System.Drawing.Brush brush, System.Drawing.Point[] points, System.Drawing.Drawing2D.FillMode fillmode, float tension) => throw null;
            public void FillEllipse(System.Drawing.Brush brush, System.Drawing.Rectangle rect) => throw null;
            public void FillEllipse(System.Drawing.Brush brush, System.Drawing.RectangleF rect) => throw null;
            public void FillEllipse(System.Drawing.Brush brush, int x, int y, int width, int height) => throw null;
            public void FillEllipse(System.Drawing.Brush brush, float x, float y, float width, float height) => throw null;
            public void FillPath(System.Drawing.Brush brush, System.Drawing.Drawing2D.GraphicsPath path) => throw null;
            public void FillPie(System.Drawing.Brush brush, System.Drawing.Rectangle rect, float startAngle, float sweepAngle) => throw null;
            public void FillPie(System.Drawing.Brush brush, int x, int y, int width, int height, int startAngle, int sweepAngle) => throw null;
            public void FillPie(System.Drawing.Brush brush, float x, float y, float width, float height, float startAngle, float sweepAngle) => throw null;
            public void FillPolygon(System.Drawing.Brush brush, System.Drawing.PointF[] points) => throw null;
            public void FillPolygon(System.Drawing.Brush brush, System.Drawing.PointF[] points, System.Drawing.Drawing2D.FillMode fillMode) => throw null;
            public void FillPolygon(System.Drawing.Brush brush, System.Drawing.Point[] points) => throw null;
            public void FillPolygon(System.Drawing.Brush brush, System.Drawing.Point[] points, System.Drawing.Drawing2D.FillMode fillMode) => throw null;
            public void FillRectangle(System.Drawing.Brush brush, System.Drawing.Rectangle rect) => throw null;
            public void FillRectangle(System.Drawing.Brush brush, System.Drawing.RectangleF rect) => throw null;
            public void FillRectangle(System.Drawing.Brush brush, int x, int y, int width, int height) => throw null;
            public void FillRectangle(System.Drawing.Brush brush, float x, float y, float width, float height) => throw null;
            public void FillRectangles(System.Drawing.Brush brush, System.Drawing.RectangleF[] rects) => throw null;
            public void FillRectangles(System.Drawing.Brush brush, System.Drawing.Rectangle[] rects) => throw null;
            public void FillRegion(System.Drawing.Brush brush, System.Drawing.Region region) => throw null;
            public void Flush() => throw null;
            public void Flush(System.Drawing.Drawing2D.FlushIntention intention) => throw null;
            public static System.Drawing.Graphics FromHdc(nint hdc) => throw null;
            public static System.Drawing.Graphics FromHdc(nint hdc, nint hdevice) => throw null;
            public static System.Drawing.Graphics FromHdcInternal(nint hdc) => throw null;
            public static System.Drawing.Graphics FromHwnd(nint hwnd) => throw null;
            public static System.Drawing.Graphics FromHwndInternal(nint hwnd) => throw null;
            public static System.Drawing.Graphics FromImage(System.Drawing.Image image) => throw null;
            public object GetContextInfo() => throw null;
            public void GetContextInfo(out System.Drawing.PointF offset) => throw null;
            public void GetContextInfo(out System.Drawing.PointF offset, out System.Drawing.Region clip) => throw null;
            public static nint GetHalftonePalette() => throw null;
            public nint GetHdc() => throw null;
            public System.Drawing.Color GetNearestColor(System.Drawing.Color color) => throw null;
            public System.Drawing.Drawing2D.InterpolationMode InterpolationMode { get => throw null; set { } }
            public void IntersectClip(System.Drawing.Rectangle rect) => throw null;
            public void IntersectClip(System.Drawing.RectangleF rect) => throw null;
            public void IntersectClip(System.Drawing.Region region) => throw null;
            public bool IsClipEmpty { get => throw null; }
            public bool IsVisible(System.Drawing.Point point) => throw null;
            public bool IsVisible(System.Drawing.PointF point) => throw null;
            public bool IsVisible(System.Drawing.Rectangle rect) => throw null;
            public bool IsVisible(System.Drawing.RectangleF rect) => throw null;
            public bool IsVisible(int x, int y) => throw null;
            public bool IsVisible(int x, int y, int width, int height) => throw null;
            public bool IsVisible(float x, float y) => throw null;
            public bool IsVisible(float x, float y, float width, float height) => throw null;
            public bool IsVisibleClipEmpty { get => throw null; }
            public System.Drawing.Region[] MeasureCharacterRanges(string text, System.Drawing.Font font, System.Drawing.RectangleF layoutRect, System.Drawing.StringFormat stringFormat) => throw null;
            public System.Drawing.SizeF MeasureString(string text, System.Drawing.Font font) => throw null;
            public System.Drawing.SizeF MeasureString(string text, System.Drawing.Font font, System.Drawing.PointF origin, System.Drawing.StringFormat stringFormat) => throw null;
            public System.Drawing.SizeF MeasureString(string text, System.Drawing.Font font, System.Drawing.SizeF layoutArea) => throw null;
            public System.Drawing.SizeF MeasureString(string text, System.Drawing.Font font, System.Drawing.SizeF layoutArea, System.Drawing.StringFormat stringFormat) => throw null;
            public System.Drawing.SizeF MeasureString(string text, System.Drawing.Font font, System.Drawing.SizeF layoutArea, System.Drawing.StringFormat stringFormat, out int charactersFitted, out int linesFilled) => throw null;
            public System.Drawing.SizeF MeasureString(string text, System.Drawing.Font font, int width) => throw null;
            public System.Drawing.SizeF MeasureString(string text, System.Drawing.Font font, int width, System.Drawing.StringFormat format) => throw null;
            public void MultiplyTransform(System.Drawing.Drawing2D.Matrix matrix) => throw null;
            public void MultiplyTransform(System.Drawing.Drawing2D.Matrix matrix, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
            public float PageScale { get => throw null; set { } }
            public System.Drawing.GraphicsUnit PageUnit { get => throw null; set { } }
            public System.Drawing.Drawing2D.PixelOffsetMode PixelOffsetMode { get => throw null; set { } }
            public void ReleaseHdc() => throw null;
            public void ReleaseHdc(nint hdc) => throw null;
            public void ReleaseHdcInternal(nint hdc) => throw null;
            public System.Drawing.Point RenderingOrigin { get => throw null; set { } }
            public void ResetClip() => throw null;
            public void ResetTransform() => throw null;
            public void Restore(System.Drawing.Drawing2D.GraphicsState gstate) => throw null;
            public void RotateTransform(float angle) => throw null;
            public void RotateTransform(float angle, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
            public System.Drawing.Drawing2D.GraphicsState Save() => throw null;
            public void ScaleTransform(float sx, float sy) => throw null;
            public void ScaleTransform(float sx, float sy, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
            public void SetClip(System.Drawing.Drawing2D.GraphicsPath path) => throw null;
            public void SetClip(System.Drawing.Drawing2D.GraphicsPath path, System.Drawing.Drawing2D.CombineMode combineMode) => throw null;
            public void SetClip(System.Drawing.Graphics g) => throw null;
            public void SetClip(System.Drawing.Graphics g, System.Drawing.Drawing2D.CombineMode combineMode) => throw null;
            public void SetClip(System.Drawing.Rectangle rect) => throw null;
            public void SetClip(System.Drawing.Rectangle rect, System.Drawing.Drawing2D.CombineMode combineMode) => throw null;
            public void SetClip(System.Drawing.RectangleF rect) => throw null;
            public void SetClip(System.Drawing.RectangleF rect, System.Drawing.Drawing2D.CombineMode combineMode) => throw null;
            public void SetClip(System.Drawing.Region region, System.Drawing.Drawing2D.CombineMode combineMode) => throw null;
            public System.Drawing.Drawing2D.SmoothingMode SmoothingMode { get => throw null; set { } }
            public int TextContrast { get => throw null; set { } }
            public System.Drawing.Text.TextRenderingHint TextRenderingHint { get => throw null; set { } }
            public System.Drawing.Drawing2D.Matrix Transform { get => throw null; set { } }
            public System.Numerics.Matrix3x2 TransformElements { get => throw null; set { } }
            public void TransformPoints(System.Drawing.Drawing2D.CoordinateSpace destSpace, System.Drawing.Drawing2D.CoordinateSpace srcSpace, System.Drawing.PointF[] pts) => throw null;
            public void TransformPoints(System.Drawing.Drawing2D.CoordinateSpace destSpace, System.Drawing.Drawing2D.CoordinateSpace srcSpace, System.Drawing.Point[] pts) => throw null;
            public void TranslateClip(int dx, int dy) => throw null;
            public void TranslateClip(float dx, float dy) => throw null;
            public void TranslateTransform(float dx, float dy) => throw null;
            public void TranslateTransform(float dx, float dy, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
            public System.Drawing.RectangleF VisibleClipBounds { get => throw null; }
        }
        public enum GraphicsUnit
        {
            World = 0,
            Display = 1,
            Pixel = 2,
            Point = 3,
            Inch = 4,
            Document = 5,
            Millimeter = 6,
        }
        public sealed class Icon : System.MarshalByRefObject, System.ICloneable, System.IDisposable, System.Runtime.Serialization.ISerializable
        {
            public object Clone() => throw null;
            public Icon(System.Drawing.Icon original, System.Drawing.Size size) => throw null;
            public Icon(System.Drawing.Icon original, int width, int height) => throw null;
            public Icon(System.IO.Stream stream) => throw null;
            public Icon(System.IO.Stream stream, System.Drawing.Size size) => throw null;
            public Icon(System.IO.Stream stream, int width, int height) => throw null;
            public Icon(string fileName) => throw null;
            public Icon(string fileName, System.Drawing.Size size) => throw null;
            public Icon(string fileName, int width, int height) => throw null;
            public Icon(System.Type type, string resource) => throw null;
            public void Dispose() => throw null;
            public static System.Drawing.Icon ExtractAssociatedIcon(string filePath) => throw null;
            public static System.Drawing.Icon FromHandle(nint handle) => throw null;
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo si, System.Runtime.Serialization.StreamingContext context) => throw null;
            public nint Handle { get => throw null; }
            public int Height { get => throw null; }
            public void Save(System.IO.Stream outputStream) => throw null;
            public System.Drawing.Size Size { get => throw null; }
            public System.Drawing.Bitmap ToBitmap() => throw null;
            public override string ToString() => throw null;
            public int Width { get => throw null; }
        }
        public class IconConverter : System.ComponentModel.ExpandableObjectConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public IconConverter() => throw null;
        }
        public interface IDeviceContext : System.IDisposable
        {
            nint GetHdc();
            void ReleaseHdc();
        }
        public abstract class Image : System.MarshalByRefObject, System.ICloneable, System.IDisposable, System.Runtime.Serialization.ISerializable
        {
            public object Clone() => throw null;
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            public int Flags { get => throw null; }
            public System.Guid[] FrameDimensionsList { get => throw null; }
            public static System.Drawing.Image FromFile(string filename) => throw null;
            public static System.Drawing.Image FromFile(string filename, bool useEmbeddedColorManagement) => throw null;
            public static System.Drawing.Bitmap FromHbitmap(nint hbitmap) => throw null;
            public static System.Drawing.Bitmap FromHbitmap(nint hbitmap, nint hpalette) => throw null;
            public static System.Drawing.Image FromStream(System.IO.Stream stream) => throw null;
            public static System.Drawing.Image FromStream(System.IO.Stream stream, bool useEmbeddedColorManagement) => throw null;
            public static System.Drawing.Image FromStream(System.IO.Stream stream, bool useEmbeddedColorManagement, bool validateImageData) => throw null;
            public System.Drawing.RectangleF GetBounds(ref System.Drawing.GraphicsUnit pageUnit) => throw null;
            public System.Drawing.Imaging.EncoderParameters GetEncoderParameterList(System.Guid encoder) => throw null;
            public int GetFrameCount(System.Drawing.Imaging.FrameDimension dimension) => throw null;
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo si, System.Runtime.Serialization.StreamingContext context) => throw null;
            public static int GetPixelFormatSize(System.Drawing.Imaging.PixelFormat pixfmt) => throw null;
            public System.Drawing.Imaging.PropertyItem GetPropertyItem(int propid) => throw null;
            public System.Drawing.Image GetThumbnailImage(int thumbWidth, int thumbHeight, System.Drawing.Image.GetThumbnailImageAbort callback, nint callbackData) => throw null;
            public delegate bool GetThumbnailImageAbort();
            public int Height { get => throw null; }
            public float HorizontalResolution { get => throw null; }
            public static bool IsAlphaPixelFormat(System.Drawing.Imaging.PixelFormat pixfmt) => throw null;
            public static bool IsCanonicalPixelFormat(System.Drawing.Imaging.PixelFormat pixfmt) => throw null;
            public static bool IsExtendedPixelFormat(System.Drawing.Imaging.PixelFormat pixfmt) => throw null;
            public System.Drawing.Imaging.ColorPalette Palette { get => throw null; set { } }
            public System.Drawing.SizeF PhysicalDimension { get => throw null; }
            public System.Drawing.Imaging.PixelFormat PixelFormat { get => throw null; }
            public int[] PropertyIdList { get => throw null; }
            public System.Drawing.Imaging.PropertyItem[] PropertyItems { get => throw null; }
            public System.Drawing.Imaging.ImageFormat RawFormat { get => throw null; }
            public void RemovePropertyItem(int propid) => throw null;
            public void RotateFlip(System.Drawing.RotateFlipType rotateFlipType) => throw null;
            public void Save(System.IO.Stream stream, System.Drawing.Imaging.ImageCodecInfo encoder, System.Drawing.Imaging.EncoderParameters encoderParams) => throw null;
            public void Save(System.IO.Stream stream, System.Drawing.Imaging.ImageFormat format) => throw null;
            public void Save(string filename) => throw null;
            public void Save(string filename, System.Drawing.Imaging.ImageCodecInfo encoder, System.Drawing.Imaging.EncoderParameters encoderParams) => throw null;
            public void Save(string filename, System.Drawing.Imaging.ImageFormat format) => throw null;
            public void SaveAdd(System.Drawing.Image image, System.Drawing.Imaging.EncoderParameters encoderParams) => throw null;
            public void SaveAdd(System.Drawing.Imaging.EncoderParameters encoderParams) => throw null;
            public int SelectActiveFrame(System.Drawing.Imaging.FrameDimension dimension, int frameIndex) => throw null;
            public void SetPropertyItem(System.Drawing.Imaging.PropertyItem propitem) => throw null;
            public System.Drawing.Size Size { get => throw null; }
            public object Tag { get => throw null; set { } }
            public float VerticalResolution { get => throw null; }
            public int Width { get => throw null; }
        }
        public sealed class ImageAnimator
        {
            public static void Animate(System.Drawing.Image image, System.EventHandler onFrameChangedHandler) => throw null;
            public static bool CanAnimate(System.Drawing.Image image) => throw null;
            public static void StopAnimate(System.Drawing.Image image, System.EventHandler onFrameChangedHandler) => throw null;
            public static void UpdateFrames() => throw null;
            public static void UpdateFrames(System.Drawing.Image image) => throw null;
        }
        public class ImageConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public ImageConverter() => throw null;
            public override System.ComponentModel.PropertyDescriptorCollection GetProperties(System.ComponentModel.ITypeDescriptorContext context, object value, System.Attribute[] attributes) => throw null;
            public override bool GetPropertiesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
        }
        public class ImageFormatConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public ImageFormatConverter() => throw null;
            public override System.ComponentModel.TypeConverter.StandardValuesCollection GetStandardValues(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override bool GetStandardValuesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
        }
        namespace Imaging
        {
            public sealed class BitmapData
            {
                public BitmapData() => throw null;
                public int Height { get => throw null; set { } }
                public System.Drawing.Imaging.PixelFormat PixelFormat { get => throw null; set { } }
                public int Reserved { get => throw null; set { } }
                public nint Scan0 { get => throw null; set { } }
                public int Stride { get => throw null; set { } }
                public int Width { get => throw null; set { } }
            }
            public enum ColorAdjustType
            {
                Default = 0,
                Bitmap = 1,
                Brush = 2,
                Pen = 3,
                Text = 4,
                Count = 5,
                Any = 6,
            }
            public enum ColorChannelFlag
            {
                ColorChannelC = 0,
                ColorChannelM = 1,
                ColorChannelY = 2,
                ColorChannelK = 3,
                ColorChannelLast = 4,
            }
            public sealed class ColorMap
            {
                public ColorMap() => throw null;
                public System.Drawing.Color NewColor { get => throw null; set { } }
                public System.Drawing.Color OldColor { get => throw null; set { } }
            }
            public enum ColorMapType
            {
                Default = 0,
                Brush = 1,
            }
            public sealed class ColorMatrix
            {
                public ColorMatrix() => throw null;
                public ColorMatrix(float[][] newColorMatrix) => throw null;
                public float Matrix00 { get => throw null; set { } }
                public float Matrix01 { get => throw null; set { } }
                public float Matrix02 { get => throw null; set { } }
                public float Matrix03 { get => throw null; set { } }
                public float Matrix04 { get => throw null; set { } }
                public float Matrix10 { get => throw null; set { } }
                public float Matrix11 { get => throw null; set { } }
                public float Matrix12 { get => throw null; set { } }
                public float Matrix13 { get => throw null; set { } }
                public float Matrix14 { get => throw null; set { } }
                public float Matrix20 { get => throw null; set { } }
                public float Matrix21 { get => throw null; set { } }
                public float Matrix22 { get => throw null; set { } }
                public float Matrix23 { get => throw null; set { } }
                public float Matrix24 { get => throw null; set { } }
                public float Matrix30 { get => throw null; set { } }
                public float Matrix31 { get => throw null; set { } }
                public float Matrix32 { get => throw null; set { } }
                public float Matrix33 { get => throw null; set { } }
                public float Matrix34 { get => throw null; set { } }
                public float Matrix40 { get => throw null; set { } }
                public float Matrix41 { get => throw null; set { } }
                public float Matrix42 { get => throw null; set { } }
                public float Matrix43 { get => throw null; set { } }
                public float Matrix44 { get => throw null; set { } }
                public float this[int row, int column] { get => throw null; set { } }
            }
            public enum ColorMatrixFlag
            {
                Default = 0,
                SkipGrays = 1,
                AltGrays = 2,
            }
            public enum ColorMode
            {
                Argb32Mode = 0,
                Argb64Mode = 1,
            }
            public sealed class ColorPalette
            {
                public System.Drawing.Color[] Entries { get => throw null; }
                public int Flags { get => throw null; }
            }
            public enum EmfPlusRecordType
            {
                EmfHeader = 1,
                EmfMin = 1,
                EmfPolyBezier = 2,
                EmfPolygon = 3,
                EmfPolyline = 4,
                EmfPolyBezierTo = 5,
                EmfPolyLineTo = 6,
                EmfPolyPolyline = 7,
                EmfPolyPolygon = 8,
                EmfSetWindowExtEx = 9,
                EmfSetWindowOrgEx = 10,
                EmfSetViewportExtEx = 11,
                EmfSetViewportOrgEx = 12,
                EmfSetBrushOrgEx = 13,
                EmfEof = 14,
                EmfSetPixelV = 15,
                EmfSetMapperFlags = 16,
                EmfSetMapMode = 17,
                EmfSetBkMode = 18,
                EmfSetPolyFillMode = 19,
                EmfSetROP2 = 20,
                EmfSetStretchBltMode = 21,
                EmfSetTextAlign = 22,
                EmfSetColorAdjustment = 23,
                EmfSetTextColor = 24,
                EmfSetBkColor = 25,
                EmfOffsetClipRgn = 26,
                EmfMoveToEx = 27,
                EmfSetMetaRgn = 28,
                EmfExcludeClipRect = 29,
                EmfIntersectClipRect = 30,
                EmfScaleViewportExtEx = 31,
                EmfScaleWindowExtEx = 32,
                EmfSaveDC = 33,
                EmfRestoreDC = 34,
                EmfSetWorldTransform = 35,
                EmfModifyWorldTransform = 36,
                EmfSelectObject = 37,
                EmfCreatePen = 38,
                EmfCreateBrushIndirect = 39,
                EmfDeleteObject = 40,
                EmfAngleArc = 41,
                EmfEllipse = 42,
                EmfRectangle = 43,
                EmfRoundRect = 44,
                EmfRoundArc = 45,
                EmfChord = 46,
                EmfPie = 47,
                EmfSelectPalette = 48,
                EmfCreatePalette = 49,
                EmfSetPaletteEntries = 50,
                EmfResizePalette = 51,
                EmfRealizePalette = 52,
                EmfExtFloodFill = 53,
                EmfLineTo = 54,
                EmfArcTo = 55,
                EmfPolyDraw = 56,
                EmfSetArcDirection = 57,
                EmfSetMiterLimit = 58,
                EmfBeginPath = 59,
                EmfEndPath = 60,
                EmfCloseFigure = 61,
                EmfFillPath = 62,
                EmfStrokeAndFillPath = 63,
                EmfStrokePath = 64,
                EmfFlattenPath = 65,
                EmfWidenPath = 66,
                EmfSelectClipPath = 67,
                EmfAbortPath = 68,
                EmfReserved069 = 69,
                EmfGdiComment = 70,
                EmfFillRgn = 71,
                EmfFrameRgn = 72,
                EmfInvertRgn = 73,
                EmfPaintRgn = 74,
                EmfExtSelectClipRgn = 75,
                EmfBitBlt = 76,
                EmfStretchBlt = 77,
                EmfMaskBlt = 78,
                EmfPlgBlt = 79,
                EmfSetDIBitsToDevice = 80,
                EmfStretchDIBits = 81,
                EmfExtCreateFontIndirect = 82,
                EmfExtTextOutA = 83,
                EmfExtTextOutW = 84,
                EmfPolyBezier16 = 85,
                EmfPolygon16 = 86,
                EmfPolyline16 = 87,
                EmfPolyBezierTo16 = 88,
                EmfPolylineTo16 = 89,
                EmfPolyPolyline16 = 90,
                EmfPolyPolygon16 = 91,
                EmfPolyDraw16 = 92,
                EmfCreateMonoBrush = 93,
                EmfCreateDibPatternBrushPt = 94,
                EmfExtCreatePen = 95,
                EmfPolyTextOutA = 96,
                EmfPolyTextOutW = 97,
                EmfSetIcmMode = 98,
                EmfCreateColorSpace = 99,
                EmfSetColorSpace = 100,
                EmfDeleteColorSpace = 101,
                EmfGlsRecord = 102,
                EmfGlsBoundedRecord = 103,
                EmfPixelFormat = 104,
                EmfDrawEscape = 105,
                EmfExtEscape = 106,
                EmfStartDoc = 107,
                EmfSmallTextOut = 108,
                EmfForceUfiMapping = 109,
                EmfNamedEscpae = 110,
                EmfColorCorrectPalette = 111,
                EmfSetIcmProfileA = 112,
                EmfSetIcmProfileW = 113,
                EmfAlphaBlend = 114,
                EmfSetLayout = 115,
                EmfTransparentBlt = 116,
                EmfReserved117 = 117,
                EmfGradientFill = 118,
                EmfSetLinkedUfis = 119,
                EmfSetTextJustification = 120,
                EmfColorMatchToTargetW = 121,
                EmfCreateColorSpaceW = 122,
                EmfMax = 122,
                EmfPlusRecordBase = 16384,
                Invalid = 16384,
                Header = 16385,
                Min = 16385,
                EndOfFile = 16386,
                Comment = 16387,
                GetDC = 16388,
                MultiFormatStart = 16389,
                MultiFormatSection = 16390,
                MultiFormatEnd = 16391,
                Object = 16392,
                Clear = 16393,
                FillRects = 16394,
                DrawRects = 16395,
                FillPolygon = 16396,
                DrawLines = 16397,
                FillEllipse = 16398,
                DrawEllipse = 16399,
                FillPie = 16400,
                DrawPie = 16401,
                DrawArc = 16402,
                FillRegion = 16403,
                FillPath = 16404,
                DrawPath = 16405,
                FillClosedCurve = 16406,
                DrawClosedCurve = 16407,
                DrawCurve = 16408,
                DrawBeziers = 16409,
                DrawImage = 16410,
                DrawImagePoints = 16411,
                DrawString = 16412,
                SetRenderingOrigin = 16413,
                SetAntiAliasMode = 16414,
                SetTextRenderingHint = 16415,
                SetTextContrast = 16416,
                SetInterpolationMode = 16417,
                SetPixelOffsetMode = 16418,
                SetCompositingMode = 16419,
                SetCompositingQuality = 16420,
                Save = 16421,
                Restore = 16422,
                BeginContainer = 16423,
                BeginContainerNoParams = 16424,
                EndContainer = 16425,
                SetWorldTransform = 16426,
                ResetWorldTransform = 16427,
                MultiplyWorldTransform = 16428,
                TranslateWorldTransform = 16429,
                ScaleWorldTransform = 16430,
                RotateWorldTransform = 16431,
                SetPageTransform = 16432,
                ResetClip = 16433,
                SetClipRect = 16434,
                SetClipPath = 16435,
                SetClipRegion = 16436,
                OffsetClip = 16437,
                DrawDriverString = 16438,
                Max = 16438,
                Total = 16439,
                WmfRecordBase = 65536,
                WmfSaveDC = 65566,
                WmfRealizePalette = 65589,
                WmfSetPalEntries = 65591,
                WmfCreatePalette = 65783,
                WmfSetBkMode = 65794,
                WmfSetMapMode = 65795,
                WmfSetROP2 = 65796,
                WmfSetRelAbs = 65797,
                WmfSetPolyFillMode = 65798,
                WmfSetStretchBltMode = 65799,
                WmfSetTextCharExtra = 65800,
                WmfRestoreDC = 65831,
                WmfInvertRegion = 65834,
                WmfPaintRegion = 65835,
                WmfSelectClipRegion = 65836,
                WmfSelectObject = 65837,
                WmfSetTextAlign = 65838,
                WmfResizePalette = 65849,
                WmfDibCreatePatternBrush = 65858,
                WmfSetLayout = 65865,
                WmfDeleteObject = 66032,
                WmfCreatePatternBrush = 66041,
                WmfSetBkColor = 66049,
                WmfSetTextColor = 66057,
                WmfSetTextJustification = 66058,
                WmfSetWindowOrg = 66059,
                WmfSetWindowExt = 66060,
                WmfSetViewportOrg = 66061,
                WmfSetViewportExt = 66062,
                WmfOffsetWindowOrg = 66063,
                WmfOffsetViewportOrg = 66065,
                WmfLineTo = 66067,
                WmfMoveTo = 66068,
                WmfOffsetCilpRgn = 66080,
                WmfFillRegion = 66088,
                WmfSetMapperFlags = 66097,
                WmfSelectPalette = 66100,
                WmfCreatePenIndirect = 66298,
                WmfCreateFontIndirect = 66299,
                WmfCreateBrushIndirect = 66300,
                WmfPolygon = 66340,
                WmfPolyline = 66341,
                WmfScaleWindowExt = 66576,
                WmfScaleViewportExt = 66578,
                WmfExcludeClipRect = 66581,
                WmfIntersectClipRect = 66582,
                WmfEllipse = 66584,
                WmfFloodFill = 66585,
                WmfRectangle = 66587,
                WmfSetPixel = 66591,
                WmfFrameRegion = 66601,
                WmfAnimatePalette = 66614,
                WmfTextOut = 66849,
                WmfPolyPolygon = 66872,
                WmfExtFloodFill = 66888,
                WmfRoundRect = 67100,
                WmfPatBlt = 67101,
                WmfEscape = 67110,
                WmfCreateRegion = 67327,
                WmfArc = 67607,
                WmfPie = 67610,
                WmfChord = 67632,
                WmfBitBlt = 67874,
                WmfDibBitBlt = 67904,
                WmfExtTextOut = 68146,
                WmfStretchBlt = 68387,
                WmfDibStretchBlt = 68417,
                WmfSetDibToDev = 68915,
                WmfStretchDib = 69443,
            }
            public enum EmfType
            {
                EmfOnly = 3,
                EmfPlusOnly = 4,
                EmfPlusDual = 5,
            }
            public sealed class Encoder
            {
                public static readonly System.Drawing.Imaging.Encoder ChrominanceTable;
                public static readonly System.Drawing.Imaging.Encoder ColorDepth;
                public static readonly System.Drawing.Imaging.Encoder ColorSpace;
                public static readonly System.Drawing.Imaging.Encoder Compression;
                public Encoder(System.Guid guid) => throw null;
                public System.Guid Guid { get => throw null; }
                public static readonly System.Drawing.Imaging.Encoder ImageItems;
                public static readonly System.Drawing.Imaging.Encoder LuminanceTable;
                public static readonly System.Drawing.Imaging.Encoder Quality;
                public static readonly System.Drawing.Imaging.Encoder RenderMethod;
                public static readonly System.Drawing.Imaging.Encoder SaveAsCmyk;
                public static readonly System.Drawing.Imaging.Encoder SaveFlag;
                public static readonly System.Drawing.Imaging.Encoder ScanMethod;
                public static readonly System.Drawing.Imaging.Encoder Transformation;
                public static readonly System.Drawing.Imaging.Encoder Version;
            }
            public sealed class EncoderParameter : System.IDisposable
            {
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, byte value) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, byte value, bool undefined) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, byte[] value) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, byte[] value, bool undefined) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, short value) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, short[] value) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, int numberValues, System.Drawing.Imaging.EncoderParameterValueType type, nint value) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, int numerator, int denominator) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, int NumberOfValues, int Type, int Value) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, int numerator1, int demoninator1, int numerator2, int demoninator2) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, int[] numerator, int[] denominator) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, int[] numerator1, int[] denominator1, int[] numerator2, int[] denominator2) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, long value) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, long rangebegin, long rangeend) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, long[] value) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, long[] rangebegin, long[] rangeend) => throw null;
                public EncoderParameter(System.Drawing.Imaging.Encoder encoder, string value) => throw null;
                public void Dispose() => throw null;
                public System.Drawing.Imaging.Encoder Encoder { get => throw null; set { } }
                public int NumberOfValues { get => throw null; }
                public System.Drawing.Imaging.EncoderParameterValueType Type { get => throw null; }
                public System.Drawing.Imaging.EncoderParameterValueType ValueType { get => throw null; }
            }
            public sealed class EncoderParameters : System.IDisposable
            {
                public EncoderParameters() => throw null;
                public EncoderParameters(int count) => throw null;
                public void Dispose() => throw null;
                public System.Drawing.Imaging.EncoderParameter[] Param { get => throw null; set { } }
            }
            public enum EncoderParameterValueType
            {
                ValueTypeByte = 1,
                ValueTypeAscii = 2,
                ValueTypeShort = 3,
                ValueTypeLong = 4,
                ValueTypeRational = 5,
                ValueTypeLongRange = 6,
                ValueTypeUndefined = 7,
                ValueTypeRationalRange = 8,
                ValueTypePointer = 9,
            }
            public enum EncoderValue
            {
                ColorTypeCMYK = 0,
                ColorTypeYCCK = 1,
                CompressionLZW = 2,
                CompressionCCITT3 = 3,
                CompressionCCITT4 = 4,
                CompressionRle = 5,
                CompressionNone = 6,
                ScanMethodInterlaced = 7,
                ScanMethodNonInterlaced = 8,
                VersionGif87 = 9,
                VersionGif89 = 10,
                RenderProgressive = 11,
                RenderNonProgressive = 12,
                TransformRotate90 = 13,
                TransformRotate180 = 14,
                TransformRotate270 = 15,
                TransformFlipHorizontal = 16,
                TransformFlipVertical = 17,
                MultiFrame = 18,
                LastFrame = 19,
                Flush = 20,
                FrameDimensionTime = 21,
                FrameDimensionResolution = 22,
                FrameDimensionPage = 23,
            }
            public sealed class FrameDimension
            {
                public FrameDimension(System.Guid guid) => throw null;
                public override bool Equals(object o) => throw null;
                public override int GetHashCode() => throw null;
                public System.Guid Guid { get => throw null; }
                public static System.Drawing.Imaging.FrameDimension Page { get => throw null; }
                public static System.Drawing.Imaging.FrameDimension Resolution { get => throw null; }
                public static System.Drawing.Imaging.FrameDimension Time { get => throw null; }
                public override string ToString() => throw null;
            }
            public sealed class ImageAttributes : System.ICloneable, System.IDisposable
            {
                public void ClearBrushRemapTable() => throw null;
                public void ClearColorKey() => throw null;
                public void ClearColorKey(System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void ClearColorMatrix() => throw null;
                public void ClearColorMatrix(System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void ClearGamma() => throw null;
                public void ClearGamma(System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void ClearNoOp() => throw null;
                public void ClearNoOp(System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void ClearOutputChannel() => throw null;
                public void ClearOutputChannel(System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void ClearOutputChannelColorProfile() => throw null;
                public void ClearOutputChannelColorProfile(System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void ClearRemapTable() => throw null;
                public void ClearRemapTable(System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void ClearThreshold() => throw null;
                public void ClearThreshold(System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public object Clone() => throw null;
                public ImageAttributes() => throw null;
                public void Dispose() => throw null;
                public void GetAdjustedPalette(System.Drawing.Imaging.ColorPalette palette, System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void SetBrushRemapTable(System.Drawing.Imaging.ColorMap[] map) => throw null;
                public void SetColorKey(System.Drawing.Color colorLow, System.Drawing.Color colorHigh) => throw null;
                public void SetColorKey(System.Drawing.Color colorLow, System.Drawing.Color colorHigh, System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void SetColorMatrices(System.Drawing.Imaging.ColorMatrix newColorMatrix, System.Drawing.Imaging.ColorMatrix grayMatrix) => throw null;
                public void SetColorMatrices(System.Drawing.Imaging.ColorMatrix newColorMatrix, System.Drawing.Imaging.ColorMatrix grayMatrix, System.Drawing.Imaging.ColorMatrixFlag flags) => throw null;
                public void SetColorMatrices(System.Drawing.Imaging.ColorMatrix newColorMatrix, System.Drawing.Imaging.ColorMatrix grayMatrix, System.Drawing.Imaging.ColorMatrixFlag mode, System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void SetColorMatrix(System.Drawing.Imaging.ColorMatrix newColorMatrix) => throw null;
                public void SetColorMatrix(System.Drawing.Imaging.ColorMatrix newColorMatrix, System.Drawing.Imaging.ColorMatrixFlag flags) => throw null;
                public void SetColorMatrix(System.Drawing.Imaging.ColorMatrix newColorMatrix, System.Drawing.Imaging.ColorMatrixFlag mode, System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void SetGamma(float gamma) => throw null;
                public void SetGamma(float gamma, System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void SetNoOp() => throw null;
                public void SetNoOp(System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void SetOutputChannel(System.Drawing.Imaging.ColorChannelFlag flags) => throw null;
                public void SetOutputChannel(System.Drawing.Imaging.ColorChannelFlag flags, System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void SetOutputChannelColorProfile(string colorProfileFilename) => throw null;
                public void SetOutputChannelColorProfile(string colorProfileFilename, System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void SetRemapTable(System.Drawing.Imaging.ColorMap[] map) => throw null;
                public void SetRemapTable(System.Drawing.Imaging.ColorMap[] map, System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void SetThreshold(float threshold) => throw null;
                public void SetThreshold(float threshold, System.Drawing.Imaging.ColorAdjustType type) => throw null;
                public void SetWrapMode(System.Drawing.Drawing2D.WrapMode mode) => throw null;
                public void SetWrapMode(System.Drawing.Drawing2D.WrapMode mode, System.Drawing.Color color) => throw null;
                public void SetWrapMode(System.Drawing.Drawing2D.WrapMode mode, System.Drawing.Color color, bool clamp) => throw null;
            }
            [System.Flags]
            public enum ImageCodecFlags
            {
                Encoder = 1,
                Decoder = 2,
                SupportBitmap = 4,
                SupportVector = 8,
                SeekableEncode = 16,
                BlockingDecode = 32,
                Builtin = 65536,
                System = 131072,
                User = 262144,
            }
            public sealed class ImageCodecInfo
            {
                public System.Guid Clsid { get => throw null; set { } }
                public string CodecName { get => throw null; set { } }
                public string DllName { get => throw null; set { } }
                public string FilenameExtension { get => throw null; set { } }
                public System.Drawing.Imaging.ImageCodecFlags Flags { get => throw null; set { } }
                public string FormatDescription { get => throw null; set { } }
                public System.Guid FormatID { get => throw null; set { } }
                public static System.Drawing.Imaging.ImageCodecInfo[] GetImageDecoders() => throw null;
                public static System.Drawing.Imaging.ImageCodecInfo[] GetImageEncoders() => throw null;
                public string MimeType { get => throw null; set { } }
                public byte[][] SignatureMasks { get => throw null; set { } }
                public byte[][] SignaturePatterns { get => throw null; set { } }
                public int Version { get => throw null; set { } }
            }
            [System.Flags]
            public enum ImageFlags
            {
                None = 0,
                Scalable = 1,
                HasAlpha = 2,
                HasTranslucent = 4,
                PartiallyScalable = 8,
                ColorSpaceRgb = 16,
                ColorSpaceCmyk = 32,
                ColorSpaceGray = 64,
                ColorSpaceYcbcr = 128,
                ColorSpaceYcck = 256,
                HasRealDpi = 4096,
                HasRealPixelSize = 8192,
                ReadOnly = 65536,
                Caching = 131072,
            }
            public sealed class ImageFormat
            {
                public static System.Drawing.Imaging.ImageFormat Bmp { get => throw null; }
                public ImageFormat(System.Guid guid) => throw null;
                public static System.Drawing.Imaging.ImageFormat Emf { get => throw null; }
                public override bool Equals(object o) => throw null;
                public static System.Drawing.Imaging.ImageFormat Exif { get => throw null; }
                public override int GetHashCode() => throw null;
                public static System.Drawing.Imaging.ImageFormat Gif { get => throw null; }
                public System.Guid Guid { get => throw null; }
                public static System.Drawing.Imaging.ImageFormat Icon { get => throw null; }
                public static System.Drawing.Imaging.ImageFormat Jpeg { get => throw null; }
                public static System.Drawing.Imaging.ImageFormat MemoryBmp { get => throw null; }
                public static System.Drawing.Imaging.ImageFormat Png { get => throw null; }
                public static System.Drawing.Imaging.ImageFormat Tiff { get => throw null; }
                public override string ToString() => throw null;
                public static System.Drawing.Imaging.ImageFormat Wmf { get => throw null; }
            }
            public enum ImageLockMode
            {
                ReadOnly = 1,
                WriteOnly = 2,
                ReadWrite = 3,
                UserInputBuffer = 4,
            }
            public sealed class Metafile : System.Drawing.Image
            {
                public Metafile(nint henhmetafile, bool deleteEmf) => throw null;
                public Metafile(nint referenceHdc, System.Drawing.Imaging.EmfType emfType) => throw null;
                public Metafile(nint referenceHdc, System.Drawing.Imaging.EmfType emfType, string description) => throw null;
                public Metafile(nint hmetafile, System.Drawing.Imaging.WmfPlaceableFileHeader wmfHeader) => throw null;
                public Metafile(nint hmetafile, System.Drawing.Imaging.WmfPlaceableFileHeader wmfHeader, bool deleteWmf) => throw null;
                public Metafile(nint referenceHdc, System.Drawing.Rectangle frameRect) => throw null;
                public Metafile(nint referenceHdc, System.Drawing.Rectangle frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit) => throw null;
                public Metafile(nint referenceHdc, System.Drawing.Rectangle frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit, System.Drawing.Imaging.EmfType type) => throw null;
                public Metafile(nint referenceHdc, System.Drawing.Rectangle frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit, System.Drawing.Imaging.EmfType type, string desc) => throw null;
                public Metafile(nint referenceHdc, System.Drawing.RectangleF frameRect) => throw null;
                public Metafile(nint referenceHdc, System.Drawing.RectangleF frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit) => throw null;
                public Metafile(nint referenceHdc, System.Drawing.RectangleF frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit, System.Drawing.Imaging.EmfType type) => throw null;
                public Metafile(nint referenceHdc, System.Drawing.RectangleF frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit, System.Drawing.Imaging.EmfType type, string description) => throw null;
                public Metafile(System.IO.Stream stream) => throw null;
                public Metafile(System.IO.Stream stream, nint referenceHdc) => throw null;
                public Metafile(System.IO.Stream stream, nint referenceHdc, System.Drawing.Imaging.EmfType type) => throw null;
                public Metafile(System.IO.Stream stream, nint referenceHdc, System.Drawing.Imaging.EmfType type, string description) => throw null;
                public Metafile(System.IO.Stream stream, nint referenceHdc, System.Drawing.Rectangle frameRect) => throw null;
                public Metafile(System.IO.Stream stream, nint referenceHdc, System.Drawing.Rectangle frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit) => throw null;
                public Metafile(System.IO.Stream stream, nint referenceHdc, System.Drawing.Rectangle frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit, System.Drawing.Imaging.EmfType type) => throw null;
                public Metafile(System.IO.Stream stream, nint referenceHdc, System.Drawing.Rectangle frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit, System.Drawing.Imaging.EmfType type, string description) => throw null;
                public Metafile(System.IO.Stream stream, nint referenceHdc, System.Drawing.RectangleF frameRect) => throw null;
                public Metafile(System.IO.Stream stream, nint referenceHdc, System.Drawing.RectangleF frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit) => throw null;
                public Metafile(System.IO.Stream stream, nint referenceHdc, System.Drawing.RectangleF frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit, System.Drawing.Imaging.EmfType type) => throw null;
                public Metafile(System.IO.Stream stream, nint referenceHdc, System.Drawing.RectangleF frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit, System.Drawing.Imaging.EmfType type, string description) => throw null;
                public Metafile(string filename) => throw null;
                public Metafile(string fileName, nint referenceHdc) => throw null;
                public Metafile(string fileName, nint referenceHdc, System.Drawing.Imaging.EmfType type) => throw null;
                public Metafile(string fileName, nint referenceHdc, System.Drawing.Imaging.EmfType type, string description) => throw null;
                public Metafile(string fileName, nint referenceHdc, System.Drawing.Rectangle frameRect) => throw null;
                public Metafile(string fileName, nint referenceHdc, System.Drawing.Rectangle frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit) => throw null;
                public Metafile(string fileName, nint referenceHdc, System.Drawing.Rectangle frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit, System.Drawing.Imaging.EmfType type) => throw null;
                public Metafile(string fileName, nint referenceHdc, System.Drawing.Rectangle frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit, System.Drawing.Imaging.EmfType type, string description) => throw null;
                public Metafile(string fileName, nint referenceHdc, System.Drawing.Rectangle frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit, string description) => throw null;
                public Metafile(string fileName, nint referenceHdc, System.Drawing.RectangleF frameRect) => throw null;
                public Metafile(string fileName, nint referenceHdc, System.Drawing.RectangleF frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit) => throw null;
                public Metafile(string fileName, nint referenceHdc, System.Drawing.RectangleF frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit, System.Drawing.Imaging.EmfType type) => throw null;
                public Metafile(string fileName, nint referenceHdc, System.Drawing.RectangleF frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit, System.Drawing.Imaging.EmfType type, string description) => throw null;
                public Metafile(string fileName, nint referenceHdc, System.Drawing.RectangleF frameRect, System.Drawing.Imaging.MetafileFrameUnit frameUnit, string desc) => throw null;
                public nint GetHenhmetafile() => throw null;
                public System.Drawing.Imaging.MetafileHeader GetMetafileHeader() => throw null;
                public static System.Drawing.Imaging.MetafileHeader GetMetafileHeader(nint henhmetafile) => throw null;
                public static System.Drawing.Imaging.MetafileHeader GetMetafileHeader(nint hmetafile, System.Drawing.Imaging.WmfPlaceableFileHeader wmfHeader) => throw null;
                public static System.Drawing.Imaging.MetafileHeader GetMetafileHeader(System.IO.Stream stream) => throw null;
                public static System.Drawing.Imaging.MetafileHeader GetMetafileHeader(string fileName) => throw null;
                public void PlayRecord(System.Drawing.Imaging.EmfPlusRecordType recordType, int flags, int dataSize, byte[] data) => throw null;
            }
            public enum MetafileFrameUnit
            {
                Pixel = 2,
                Point = 3,
                Inch = 4,
                Document = 5,
                Millimeter = 6,
                GdiCompatible = 7,
            }
            public sealed class MetafileHeader
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
            public enum MetafileType
            {
                Invalid = 0,
                Wmf = 1,
                WmfPlaceable = 2,
                Emf = 3,
                EmfPlusOnly = 4,
                EmfPlusDual = 5,
            }
            public sealed class MetaHeader
            {
                public MetaHeader() => throw null;
                public short HeaderSize { get => throw null; set { } }
                public int MaxRecord { get => throw null; set { } }
                public short NoObjects { get => throw null; set { } }
                public short NoParameters { get => throw null; set { } }
                public int Size { get => throw null; set { } }
                public short Type { get => throw null; set { } }
                public short Version { get => throw null; set { } }
            }
            [System.Flags]
            public enum PaletteFlags
            {
                HasAlpha = 1,
                GrayScale = 2,
                Halftone = 4,
            }
            public enum PixelFormat
            {
                DontCare = 0,
                Undefined = 0,
                Max = 15,
                Indexed = 65536,
                Gdi = 131072,
                Format16bppRgb555 = 135173,
                Format16bppRgb565 = 135174,
                Format24bppRgb = 137224,
                Format32bppRgb = 139273,
                Format1bppIndexed = 196865,
                Format4bppIndexed = 197634,
                Format8bppIndexed = 198659,
                Alpha = 262144,
                Format16bppArgb1555 = 397319,
                PAlpha = 524288,
                Format32bppPArgb = 925707,
                Extended = 1048576,
                Format16bppGrayScale = 1052676,
                Format48bppRgb = 1060876,
                Format64bppPArgb = 1851406,
                Canonical = 2097152,
                Format32bppArgb = 2498570,
                Format64bppArgb = 3424269,
            }
            public delegate void PlayRecordCallback(System.Drawing.Imaging.EmfPlusRecordType recordType, int flags, int dataSize, nint recordData);
            public sealed class PropertyItem
            {
                public int Id { get => throw null; set { } }
                public int Len { get => throw null; set { } }
                public short Type { get => throw null; set { } }
                public byte[] Value { get => throw null; set { } }
            }
            public sealed class WmfPlaceableFileHeader
            {
                public short BboxBottom { get => throw null; set { } }
                public short BboxLeft { get => throw null; set { } }
                public short BboxRight { get => throw null; set { } }
                public short BboxTop { get => throw null; set { } }
                public short Checksum { get => throw null; set { } }
                public WmfPlaceableFileHeader() => throw null;
                public short Hmf { get => throw null; set { } }
                public short Inch { get => throw null; set { } }
                public int Key { get => throw null; set { } }
                public int Reserved { get => throw null; set { } }
            }
        }
        public sealed class Pen : System.MarshalByRefObject, System.ICloneable, System.IDisposable
        {
            public System.Drawing.Drawing2D.PenAlignment Alignment { get => throw null; set { } }
            public System.Drawing.Brush Brush { get => throw null; set { } }
            public object Clone() => throw null;
            public System.Drawing.Color Color { get => throw null; set { } }
            public float[] CompoundArray { get => throw null; set { } }
            public Pen(System.Drawing.Brush brush) => throw null;
            public Pen(System.Drawing.Brush brush, float width) => throw null;
            public Pen(System.Drawing.Color color) => throw null;
            public Pen(System.Drawing.Color color, float width) => throw null;
            public System.Drawing.Drawing2D.CustomLineCap CustomEndCap { get => throw null; set { } }
            public System.Drawing.Drawing2D.CustomLineCap CustomStartCap { get => throw null; set { } }
            public System.Drawing.Drawing2D.DashCap DashCap { get => throw null; set { } }
            public float DashOffset { get => throw null; set { } }
            public float[] DashPattern { get => throw null; set { } }
            public System.Drawing.Drawing2D.DashStyle DashStyle { get => throw null; set { } }
            public void Dispose() => throw null;
            public System.Drawing.Drawing2D.LineCap EndCap { get => throw null; set { } }
            public System.Drawing.Drawing2D.LineJoin LineJoin { get => throw null; set { } }
            public float MiterLimit { get => throw null; set { } }
            public void MultiplyTransform(System.Drawing.Drawing2D.Matrix matrix) => throw null;
            public void MultiplyTransform(System.Drawing.Drawing2D.Matrix matrix, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
            public System.Drawing.Drawing2D.PenType PenType { get => throw null; }
            public void ResetTransform() => throw null;
            public void RotateTransform(float angle) => throw null;
            public void RotateTransform(float angle, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
            public void ScaleTransform(float sx, float sy) => throw null;
            public void ScaleTransform(float sx, float sy, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
            public void SetLineCap(System.Drawing.Drawing2D.LineCap startCap, System.Drawing.Drawing2D.LineCap endCap, System.Drawing.Drawing2D.DashCap dashCap) => throw null;
            public System.Drawing.Drawing2D.LineCap StartCap { get => throw null; set { } }
            public System.Drawing.Drawing2D.Matrix Transform { get => throw null; set { } }
            public void TranslateTransform(float dx, float dy) => throw null;
            public void TranslateTransform(float dx, float dy, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
            public float Width { get => throw null; set { } }
        }
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
        namespace Printing
        {
            public enum Duplex
            {
                Default = -1,
                Simplex = 1,
                Vertical = 2,
                Horizontal = 3,
            }
            public class InvalidPrinterException : System.SystemException
            {
                public InvalidPrinterException(System.Drawing.Printing.PrinterSettings settings) => throw null;
                protected InvalidPrinterException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            }
            public class Margins : System.ICloneable
            {
                public int Bottom { get => throw null; set { } }
                public object Clone() => throw null;
                public Margins() => throw null;
                public Margins(int left, int right, int top, int bottom) => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public int Left { get => throw null; set { } }
                public static bool operator ==(System.Drawing.Printing.Margins m1, System.Drawing.Printing.Margins m2) => throw null;
                public static bool operator !=(System.Drawing.Printing.Margins m1, System.Drawing.Printing.Margins m2) => throw null;
                public int Right { get => throw null; set { } }
                public int Top { get => throw null; set { } }
                public override string ToString() => throw null;
            }
            public class MarginsConverter : System.ComponentModel.ExpandableObjectConverter
            {
                public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
                public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
                public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
                public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
                public override object CreateInstance(System.ComponentModel.ITypeDescriptorContext context, System.Collections.IDictionary propertyValues) => throw null;
                public MarginsConverter() => throw null;
                public override bool GetCreateInstanceSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            }
            public class PageSettings : System.ICloneable
            {
                public System.Drawing.Rectangle Bounds { get => throw null; }
                public object Clone() => throw null;
                public bool Color { get => throw null; set { } }
                public void CopyToHdevmode(nint hdevmode) => throw null;
                public PageSettings() => throw null;
                public PageSettings(System.Drawing.Printing.PrinterSettings printerSettings) => throw null;
                public float HardMarginX { get => throw null; }
                public float HardMarginY { get => throw null; }
                public bool Landscape { get => throw null; set { } }
                public System.Drawing.Printing.Margins Margins { get => throw null; set { } }
                public System.Drawing.Printing.PaperSize PaperSize { get => throw null; set { } }
                public System.Drawing.Printing.PaperSource PaperSource { get => throw null; set { } }
                public System.Drawing.RectangleF PrintableArea { get => throw null; }
                public System.Drawing.Printing.PrinterResolution PrinterResolution { get => throw null; set { } }
                public System.Drawing.Printing.PrinterSettings PrinterSettings { get => throw null; set { } }
                public void SetHdevmode(nint hdevmode) => throw null;
                public override string ToString() => throw null;
            }
            public enum PaperKind
            {
                Custom = 0,
                Letter = 1,
                LetterSmall = 2,
                Tabloid = 3,
                Ledger = 4,
                Legal = 5,
                Statement = 6,
                Executive = 7,
                A3 = 8,
                A4 = 9,
                A4Small = 10,
                A5 = 11,
                B4 = 12,
                B5 = 13,
                Folio = 14,
                Quarto = 15,
                Standard10x14 = 16,
                Standard11x17 = 17,
                Note = 18,
                Number9Envelope = 19,
                Number10Envelope = 20,
                Number11Envelope = 21,
                Number12Envelope = 22,
                Number14Envelope = 23,
                CSheet = 24,
                DSheet = 25,
                ESheet = 26,
                DLEnvelope = 27,
                C5Envelope = 28,
                C3Envelope = 29,
                C4Envelope = 30,
                C6Envelope = 31,
                C65Envelope = 32,
                B4Envelope = 33,
                B5Envelope = 34,
                B6Envelope = 35,
                ItalyEnvelope = 36,
                MonarchEnvelope = 37,
                PersonalEnvelope = 38,
                USStandardFanfold = 39,
                GermanStandardFanfold = 40,
                GermanLegalFanfold = 41,
                IsoB4 = 42,
                JapanesePostcard = 43,
                Standard9x11 = 44,
                Standard10x11 = 45,
                Standard15x11 = 46,
                InviteEnvelope = 47,
                LetterExtra = 50,
                LegalExtra = 51,
                TabloidExtra = 52,
                A4Extra = 53,
                LetterTransverse = 54,
                A4Transverse = 55,
                LetterExtraTransverse = 56,
                APlus = 57,
                BPlus = 58,
                LetterPlus = 59,
                A4Plus = 60,
                A5Transverse = 61,
                B5Transverse = 62,
                A3Extra = 63,
                A5Extra = 64,
                B5Extra = 65,
                A2 = 66,
                A3Transverse = 67,
                A3ExtraTransverse = 68,
                JapaneseDoublePostcard = 69,
                A6 = 70,
                JapaneseEnvelopeKakuNumber2 = 71,
                JapaneseEnvelopeKakuNumber3 = 72,
                JapaneseEnvelopeChouNumber3 = 73,
                JapaneseEnvelopeChouNumber4 = 74,
                LetterRotated = 75,
                A3Rotated = 76,
                A4Rotated = 77,
                A5Rotated = 78,
                B4JisRotated = 79,
                B5JisRotated = 80,
                JapanesePostcardRotated = 81,
                JapaneseDoublePostcardRotated = 82,
                A6Rotated = 83,
                JapaneseEnvelopeKakuNumber2Rotated = 84,
                JapaneseEnvelopeKakuNumber3Rotated = 85,
                JapaneseEnvelopeChouNumber3Rotated = 86,
                JapaneseEnvelopeChouNumber4Rotated = 87,
                B6Jis = 88,
                B6JisRotated = 89,
                Standard12x11 = 90,
                JapaneseEnvelopeYouNumber4 = 91,
                JapaneseEnvelopeYouNumber4Rotated = 92,
                Prc16K = 93,
                Prc32K = 94,
                Prc32KBig = 95,
                PrcEnvelopeNumber1 = 96,
                PrcEnvelopeNumber2 = 97,
                PrcEnvelopeNumber3 = 98,
                PrcEnvelopeNumber4 = 99,
                PrcEnvelopeNumber5 = 100,
                PrcEnvelopeNumber6 = 101,
                PrcEnvelopeNumber7 = 102,
                PrcEnvelopeNumber8 = 103,
                PrcEnvelopeNumber9 = 104,
                PrcEnvelopeNumber10 = 105,
                Prc16KRotated = 106,
                Prc32KRotated = 107,
                Prc32KBigRotated = 108,
                PrcEnvelopeNumber1Rotated = 109,
                PrcEnvelopeNumber2Rotated = 110,
                PrcEnvelopeNumber3Rotated = 111,
                PrcEnvelopeNumber4Rotated = 112,
                PrcEnvelopeNumber5Rotated = 113,
                PrcEnvelopeNumber6Rotated = 114,
                PrcEnvelopeNumber7Rotated = 115,
                PrcEnvelopeNumber8Rotated = 116,
                PrcEnvelopeNumber9Rotated = 117,
                PrcEnvelopeNumber10Rotated = 118,
            }
            public class PaperSize
            {
                public PaperSize() => throw null;
                public PaperSize(string name, int width, int height) => throw null;
                public int Height { get => throw null; set { } }
                public System.Drawing.Printing.PaperKind Kind { get => throw null; }
                public string PaperName { get => throw null; set { } }
                public int RawKind { get => throw null; set { } }
                public override string ToString() => throw null;
                public int Width { get => throw null; set { } }
            }
            public class PaperSource
            {
                public PaperSource() => throw null;
                public System.Drawing.Printing.PaperSourceKind Kind { get => throw null; }
                public int RawKind { get => throw null; set { } }
                public string SourceName { get => throw null; set { } }
                public override string ToString() => throw null;
            }
            public enum PaperSourceKind
            {
                Upper = 1,
                Lower = 2,
                Middle = 3,
                Manual = 4,
                Envelope = 5,
                ManualFeed = 6,
                AutomaticFeed = 7,
                TractorFeed = 8,
                SmallFormat = 9,
                LargeFormat = 10,
                LargeCapacity = 11,
                Cassette = 14,
                FormSource = 15,
                Custom = 257,
            }
            public sealed class PreviewPageInfo
            {
                public PreviewPageInfo(System.Drawing.Image image, System.Drawing.Size physicalSize) => throw null;
                public System.Drawing.Image Image { get => throw null; }
                public System.Drawing.Size PhysicalSize { get => throw null; }
            }
            public class PreviewPrintController : System.Drawing.Printing.PrintController
            {
                public PreviewPrintController() => throw null;
                public System.Drawing.Printing.PreviewPageInfo[] GetPreviewPageInfo() => throw null;
                public override bool IsPreview { get => throw null; }
                public override void OnEndPage(System.Drawing.Printing.PrintDocument document, System.Drawing.Printing.PrintPageEventArgs e) => throw null;
                public override void OnEndPrint(System.Drawing.Printing.PrintDocument document, System.Drawing.Printing.PrintEventArgs e) => throw null;
                public override System.Drawing.Graphics OnStartPage(System.Drawing.Printing.PrintDocument document, System.Drawing.Printing.PrintPageEventArgs e) => throw null;
                public override void OnStartPrint(System.Drawing.Printing.PrintDocument document, System.Drawing.Printing.PrintEventArgs e) => throw null;
                public virtual bool UseAntiAlias { get => throw null; set { } }
            }
            public enum PrintAction
            {
                PrintToFile = 0,
                PrintToPreview = 1,
                PrintToPrinter = 2,
            }
            public abstract class PrintController
            {
                protected PrintController() => throw null;
                public virtual bool IsPreview { get => throw null; }
                public virtual void OnEndPage(System.Drawing.Printing.PrintDocument document, System.Drawing.Printing.PrintPageEventArgs e) => throw null;
                public virtual void OnEndPrint(System.Drawing.Printing.PrintDocument document, System.Drawing.Printing.PrintEventArgs e) => throw null;
                public virtual System.Drawing.Graphics OnStartPage(System.Drawing.Printing.PrintDocument document, System.Drawing.Printing.PrintPageEventArgs e) => throw null;
                public virtual void OnStartPrint(System.Drawing.Printing.PrintDocument document, System.Drawing.Printing.PrintEventArgs e) => throw null;
            }
            public class PrintDocument : System.ComponentModel.Component
            {
                public event System.Drawing.Printing.PrintEventHandler BeginPrint;
                public PrintDocument() => throw null;
                public System.Drawing.Printing.PageSettings DefaultPageSettings { get => throw null; set { } }
                public string DocumentName { get => throw null; set { } }
                public event System.Drawing.Printing.PrintEventHandler EndPrint;
                protected virtual void OnBeginPrint(System.Drawing.Printing.PrintEventArgs e) => throw null;
                protected virtual void OnEndPrint(System.Drawing.Printing.PrintEventArgs e) => throw null;
                protected virtual void OnPrintPage(System.Drawing.Printing.PrintPageEventArgs e) => throw null;
                protected virtual void OnQueryPageSettings(System.Drawing.Printing.QueryPageSettingsEventArgs e) => throw null;
                public bool OriginAtMargins { get => throw null; set { } }
                public void Print() => throw null;
                public System.Drawing.Printing.PrintController PrintController { get => throw null; set { } }
                public System.Drawing.Printing.PrinterSettings PrinterSettings { get => throw null; set { } }
                public event System.Drawing.Printing.PrintPageEventHandler PrintPage;
                public event System.Drawing.Printing.QueryPageSettingsEventHandler QueryPageSettings;
                public override string ToString() => throw null;
            }
            public class PrinterResolution
            {
                public PrinterResolution() => throw null;
                public System.Drawing.Printing.PrinterResolutionKind Kind { get => throw null; set { } }
                public override string ToString() => throw null;
                public int X { get => throw null; set { } }
                public int Y { get => throw null; set { } }
            }
            public enum PrinterResolutionKind
            {
                High = -4,
                Medium = -3,
                Low = -2,
                Draft = -1,
                Custom = 0,
            }
            public class PrinterSettings : System.ICloneable
            {
                public bool CanDuplex { get => throw null; }
                public object Clone() => throw null;
                public bool Collate { get => throw null; set { } }
                public short Copies { get => throw null; set { } }
                public System.Drawing.Graphics CreateMeasurementGraphics() => throw null;
                public System.Drawing.Graphics CreateMeasurementGraphics(bool honorOriginAtMargins) => throw null;
                public System.Drawing.Graphics CreateMeasurementGraphics(System.Drawing.Printing.PageSettings pageSettings) => throw null;
                public System.Drawing.Graphics CreateMeasurementGraphics(System.Drawing.Printing.PageSettings pageSettings, bool honorOriginAtMargins) => throw null;
                public PrinterSettings() => throw null;
                public System.Drawing.Printing.PageSettings DefaultPageSettings { get => throw null; }
                public System.Drawing.Printing.Duplex Duplex { get => throw null; set { } }
                public int FromPage { get => throw null; set { } }
                public nint GetHdevmode() => throw null;
                public nint GetHdevmode(System.Drawing.Printing.PageSettings pageSettings) => throw null;
                public nint GetHdevnames() => throw null;
                public static System.Drawing.Printing.PrinterSettings.StringCollection InstalledPrinters { get => throw null; }
                public bool IsDefaultPrinter { get => throw null; }
                public bool IsDirectPrintingSupported(System.Drawing.Image image) => throw null;
                public bool IsDirectPrintingSupported(System.Drawing.Imaging.ImageFormat imageFormat) => throw null;
                public bool IsPlotter { get => throw null; }
                public bool IsValid { get => throw null; }
                public int LandscapeAngle { get => throw null; }
                public int MaximumCopies { get => throw null; }
                public int MaximumPage { get => throw null; set { } }
                public int MinimumPage { get => throw null; set { } }
                public class PaperSizeCollection : System.Collections.ICollection, System.Collections.IEnumerable
                {
                    public int Add(System.Drawing.Printing.PaperSize paperSize) => throw null;
                    public void CopyTo(System.Drawing.Printing.PaperSize[] paperSizes, int index) => throw null;
                    void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                    public int Count { get => throw null; }
                    int System.Collections.ICollection.Count { get => throw null; }
                    public PaperSizeCollection(System.Drawing.Printing.PaperSize[] array) => throw null;
                    public System.Collections.IEnumerator GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                    object System.Collections.ICollection.SyncRoot { get => throw null; }
                    public virtual System.Drawing.Printing.PaperSize this[int index] { get => throw null; }
                }
                public System.Drawing.Printing.PrinterSettings.PaperSizeCollection PaperSizes { get => throw null; }
                public class PaperSourceCollection : System.Collections.ICollection, System.Collections.IEnumerable
                {
                    public int Add(System.Drawing.Printing.PaperSource paperSource) => throw null;
                    public void CopyTo(System.Drawing.Printing.PaperSource[] paperSources, int index) => throw null;
                    void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                    public int Count { get => throw null; }
                    int System.Collections.ICollection.Count { get => throw null; }
                    public PaperSourceCollection(System.Drawing.Printing.PaperSource[] array) => throw null;
                    public System.Collections.IEnumerator GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                    object System.Collections.ICollection.SyncRoot { get => throw null; }
                    public virtual System.Drawing.Printing.PaperSource this[int index] { get => throw null; }
                }
                public System.Drawing.Printing.PrinterSettings.PaperSourceCollection PaperSources { get => throw null; }
                public string PrinterName { get => throw null; set { } }
                public class PrinterResolutionCollection : System.Collections.ICollection, System.Collections.IEnumerable
                {
                    public int Add(System.Drawing.Printing.PrinterResolution printerResolution) => throw null;
                    public void CopyTo(System.Drawing.Printing.PrinterResolution[] printerResolutions, int index) => throw null;
                    void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                    public int Count { get => throw null; }
                    int System.Collections.ICollection.Count { get => throw null; }
                    public PrinterResolutionCollection(System.Drawing.Printing.PrinterResolution[] array) => throw null;
                    public System.Collections.IEnumerator GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                    object System.Collections.ICollection.SyncRoot { get => throw null; }
                    public virtual System.Drawing.Printing.PrinterResolution this[int index] { get => throw null; }
                }
                public System.Drawing.Printing.PrinterSettings.PrinterResolutionCollection PrinterResolutions { get => throw null; }
                public string PrintFileName { get => throw null; set { } }
                public System.Drawing.Printing.PrintRange PrintRange { get => throw null; set { } }
                public bool PrintToFile { get => throw null; set { } }
                public void SetHdevmode(nint hdevmode) => throw null;
                public void SetHdevnames(nint hdevnames) => throw null;
                public class StringCollection : System.Collections.ICollection, System.Collections.IEnumerable
                {
                    public int Add(string value) => throw null;
                    public void CopyTo(string[] strings, int index) => throw null;
                    void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                    public int Count { get => throw null; }
                    int System.Collections.ICollection.Count { get => throw null; }
                    public StringCollection(string[] array) => throw null;
                    public System.Collections.IEnumerator GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                    object System.Collections.ICollection.SyncRoot { get => throw null; }
                    public virtual string this[int index] { get => throw null; }
                }
                public bool SupportsColor { get => throw null; }
                public int ToPage { get => throw null; set { } }
                public override string ToString() => throw null;
            }
            public enum PrinterUnit
            {
                Display = 0,
                ThousandthsOfAnInch = 1,
                HundredthsOfAMillimeter = 2,
                TenthsOfAMillimeter = 3,
            }
            public sealed class PrinterUnitConvert
            {
                public static double Convert(double value, System.Drawing.Printing.PrinterUnit fromUnit, System.Drawing.Printing.PrinterUnit toUnit) => throw null;
                public static System.Drawing.Point Convert(System.Drawing.Point value, System.Drawing.Printing.PrinterUnit fromUnit, System.Drawing.Printing.PrinterUnit toUnit) => throw null;
                public static System.Drawing.Printing.Margins Convert(System.Drawing.Printing.Margins value, System.Drawing.Printing.PrinterUnit fromUnit, System.Drawing.Printing.PrinterUnit toUnit) => throw null;
                public static System.Drawing.Rectangle Convert(System.Drawing.Rectangle value, System.Drawing.Printing.PrinterUnit fromUnit, System.Drawing.Printing.PrinterUnit toUnit) => throw null;
                public static System.Drawing.Size Convert(System.Drawing.Size value, System.Drawing.Printing.PrinterUnit fromUnit, System.Drawing.Printing.PrinterUnit toUnit) => throw null;
                public static int Convert(int value, System.Drawing.Printing.PrinterUnit fromUnit, System.Drawing.Printing.PrinterUnit toUnit) => throw null;
            }
            public class PrintEventArgs : System.ComponentModel.CancelEventArgs
            {
                public PrintEventArgs() => throw null;
                public System.Drawing.Printing.PrintAction PrintAction { get => throw null; }
            }
            public delegate void PrintEventHandler(object sender, System.Drawing.Printing.PrintEventArgs e);
            public class PrintPageEventArgs : System.EventArgs
            {
                public bool Cancel { get => throw null; set { } }
                public PrintPageEventArgs(System.Drawing.Graphics graphics, System.Drawing.Rectangle marginBounds, System.Drawing.Rectangle pageBounds, System.Drawing.Printing.PageSettings pageSettings) => throw null;
                public System.Drawing.Graphics Graphics { get => throw null; }
                public bool HasMorePages { get => throw null; set { } }
                public System.Drawing.Rectangle MarginBounds { get => throw null; }
                public System.Drawing.Rectangle PageBounds { get => throw null; }
                public System.Drawing.Printing.PageSettings PageSettings { get => throw null; }
            }
            public delegate void PrintPageEventHandler(object sender, System.Drawing.Printing.PrintPageEventArgs e);
            public enum PrintRange
            {
                AllPages = 0,
                Selection = 1,
                SomePages = 2,
                CurrentPage = 4194304,
            }
            public class QueryPageSettingsEventArgs : System.Drawing.Printing.PrintEventArgs
            {
                public QueryPageSettingsEventArgs(System.Drawing.Printing.PageSettings pageSettings) => throw null;
                public System.Drawing.Printing.PageSettings PageSettings { get => throw null; set { } }
            }
            public delegate void QueryPageSettingsEventHandler(object sender, System.Drawing.Printing.QueryPageSettingsEventArgs e);
            public class StandardPrintController : System.Drawing.Printing.PrintController
            {
                public StandardPrintController() => throw null;
                public override void OnEndPage(System.Drawing.Printing.PrintDocument document, System.Drawing.Printing.PrintPageEventArgs e) => throw null;
                public override void OnEndPrint(System.Drawing.Printing.PrintDocument document, System.Drawing.Printing.PrintEventArgs e) => throw null;
                public override System.Drawing.Graphics OnStartPage(System.Drawing.Printing.PrintDocument document, System.Drawing.Printing.PrintPageEventArgs e) => throw null;
                public override void OnStartPrint(System.Drawing.Printing.PrintDocument document, System.Drawing.Printing.PrintEventArgs e) => throw null;
            }
        }
        public sealed class Region : System.MarshalByRefObject, System.IDisposable
        {
            public System.Drawing.Region Clone() => throw null;
            public void Complement(System.Drawing.Drawing2D.GraphicsPath path) => throw null;
            public void Complement(System.Drawing.Rectangle rect) => throw null;
            public void Complement(System.Drawing.RectangleF rect) => throw null;
            public void Complement(System.Drawing.Region region) => throw null;
            public Region() => throw null;
            public Region(System.Drawing.Drawing2D.GraphicsPath path) => throw null;
            public Region(System.Drawing.Drawing2D.RegionData rgnData) => throw null;
            public Region(System.Drawing.Rectangle rect) => throw null;
            public Region(System.Drawing.RectangleF rect) => throw null;
            public void Dispose() => throw null;
            public bool Equals(System.Drawing.Region region, System.Drawing.Graphics g) => throw null;
            public void Exclude(System.Drawing.Drawing2D.GraphicsPath path) => throw null;
            public void Exclude(System.Drawing.Rectangle rect) => throw null;
            public void Exclude(System.Drawing.RectangleF rect) => throw null;
            public void Exclude(System.Drawing.Region region) => throw null;
            public static System.Drawing.Region FromHrgn(nint hrgn) => throw null;
            public System.Drawing.RectangleF GetBounds(System.Drawing.Graphics g) => throw null;
            public nint GetHrgn(System.Drawing.Graphics g) => throw null;
            public System.Drawing.Drawing2D.RegionData GetRegionData() => throw null;
            public System.Drawing.RectangleF[] GetRegionScans(System.Drawing.Drawing2D.Matrix matrix) => throw null;
            public void Intersect(System.Drawing.Drawing2D.GraphicsPath path) => throw null;
            public void Intersect(System.Drawing.Rectangle rect) => throw null;
            public void Intersect(System.Drawing.RectangleF rect) => throw null;
            public void Intersect(System.Drawing.Region region) => throw null;
            public bool IsEmpty(System.Drawing.Graphics g) => throw null;
            public bool IsInfinite(System.Drawing.Graphics g) => throw null;
            public bool IsVisible(System.Drawing.Point point) => throw null;
            public bool IsVisible(System.Drawing.Point point, System.Drawing.Graphics g) => throw null;
            public bool IsVisible(System.Drawing.PointF point) => throw null;
            public bool IsVisible(System.Drawing.PointF point, System.Drawing.Graphics g) => throw null;
            public bool IsVisible(System.Drawing.Rectangle rect) => throw null;
            public bool IsVisible(System.Drawing.Rectangle rect, System.Drawing.Graphics g) => throw null;
            public bool IsVisible(System.Drawing.RectangleF rect) => throw null;
            public bool IsVisible(System.Drawing.RectangleF rect, System.Drawing.Graphics g) => throw null;
            public bool IsVisible(int x, int y, System.Drawing.Graphics g) => throw null;
            public bool IsVisible(int x, int y, int width, int height) => throw null;
            public bool IsVisible(int x, int y, int width, int height, System.Drawing.Graphics g) => throw null;
            public bool IsVisible(float x, float y) => throw null;
            public bool IsVisible(float x, float y, System.Drawing.Graphics g) => throw null;
            public bool IsVisible(float x, float y, float width, float height) => throw null;
            public bool IsVisible(float x, float y, float width, float height, System.Drawing.Graphics g) => throw null;
            public void MakeEmpty() => throw null;
            public void MakeInfinite() => throw null;
            public void ReleaseHrgn(nint regionHandle) => throw null;
            public void Transform(System.Drawing.Drawing2D.Matrix matrix) => throw null;
            public void Translate(int dx, int dy) => throw null;
            public void Translate(float dx, float dy) => throw null;
            public void Union(System.Drawing.Drawing2D.GraphicsPath path) => throw null;
            public void Union(System.Drawing.Rectangle rect) => throw null;
            public void Union(System.Drawing.RectangleF rect) => throw null;
            public void Union(System.Drawing.Region region) => throw null;
            public void Xor(System.Drawing.Drawing2D.GraphicsPath path) => throw null;
            public void Xor(System.Drawing.Rectangle rect) => throw null;
            public void Xor(System.Drawing.RectangleF rect) => throw null;
            public void Xor(System.Drawing.Region region) => throw null;
        }
        public enum RotateFlipType
        {
            Rotate180FlipXY = 0,
            RotateNoneFlipNone = 0,
            Rotate270FlipXY = 1,
            Rotate90FlipNone = 1,
            Rotate180FlipNone = 2,
            RotateNoneFlipXY = 2,
            Rotate270FlipNone = 3,
            Rotate90FlipXY = 3,
            Rotate180FlipY = 4,
            RotateNoneFlipX = 4,
            Rotate270FlipY = 5,
            Rotate90FlipX = 5,
            Rotate180FlipX = 6,
            RotateNoneFlipY = 6,
            Rotate270FlipX = 7,
            Rotate90FlipY = 7,
        }
        public sealed class SolidBrush : System.Drawing.Brush
        {
            public override object Clone() => throw null;
            public System.Drawing.Color Color { get => throw null; set { } }
            public SolidBrush(System.Drawing.Color color) => throw null;
            protected override void Dispose(bool disposing) => throw null;
        }
        public enum StringAlignment
        {
            Near = 0,
            Center = 1,
            Far = 2,
        }
        public enum StringDigitSubstitute
        {
            User = 0,
            None = 1,
            National = 2,
            Traditional = 3,
        }
        public sealed class StringFormat : System.MarshalByRefObject, System.ICloneable, System.IDisposable
        {
            public System.Drawing.StringAlignment Alignment { get => throw null; set { } }
            public object Clone() => throw null;
            public StringFormat() => throw null;
            public StringFormat(System.Drawing.StringFormat format) => throw null;
            public StringFormat(System.Drawing.StringFormatFlags options) => throw null;
            public StringFormat(System.Drawing.StringFormatFlags options, int language) => throw null;
            public int DigitSubstitutionLanguage { get => throw null; }
            public System.Drawing.StringDigitSubstitute DigitSubstitutionMethod { get => throw null; }
            public void Dispose() => throw null;
            public System.Drawing.StringFormatFlags FormatFlags { get => throw null; set { } }
            public static System.Drawing.StringFormat GenericDefault { get => throw null; }
            public static System.Drawing.StringFormat GenericTypographic { get => throw null; }
            public float[] GetTabStops(out float firstTabOffset) => throw null;
            public System.Drawing.Text.HotkeyPrefix HotkeyPrefix { get => throw null; set { } }
            public System.Drawing.StringAlignment LineAlignment { get => throw null; set { } }
            public void SetDigitSubstitution(int language, System.Drawing.StringDigitSubstitute substitute) => throw null;
            public void SetMeasurableCharacterRanges(System.Drawing.CharacterRange[] ranges) => throw null;
            public void SetTabStops(float firstTabOffset, float[] tabStops) => throw null;
            public override string ToString() => throw null;
            public System.Drawing.StringTrimming Trimming { get => throw null; set { } }
        }
        [System.Flags]
        public enum StringFormatFlags
        {
            DirectionRightToLeft = 1,
            DirectionVertical = 2,
            FitBlackBox = 4,
            DisplayFormatControl = 32,
            NoFontFallback = 1024,
            MeasureTrailingSpaces = 2048,
            NoWrap = 4096,
            LineLimit = 8192,
            NoClip = 16384,
        }
        public enum StringTrimming
        {
            None = 0,
            Character = 1,
            Word = 2,
            EllipsisCharacter = 3,
            EllipsisWord = 4,
            EllipsisPath = 5,
        }
        public enum StringUnit
        {
            World = 0,
            Display = 1,
            Pixel = 2,
            Point = 3,
            Inch = 4,
            Document = 5,
            Millimeter = 6,
            Em = 32,
        }
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
        namespace Text
        {
            public abstract class FontCollection : System.IDisposable
            {
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public System.Drawing.FontFamily[] Families { get => throw null; }
            }
            public enum GenericFontFamilies
            {
                Serif = 0,
                SansSerif = 1,
                Monospace = 2,
            }
            public enum HotkeyPrefix
            {
                None = 0,
                Show = 1,
                Hide = 2,
            }
            public sealed class InstalledFontCollection : System.Drawing.Text.FontCollection
            {
                public InstalledFontCollection() => throw null;
            }
            public sealed class PrivateFontCollection : System.Drawing.Text.FontCollection
            {
                public void AddFontFile(string filename) => throw null;
                public void AddMemoryFont(nint memory, int length) => throw null;
                public PrivateFontCollection() => throw null;
                protected override void Dispose(bool disposing) => throw null;
            }
            public enum TextRenderingHint
            {
                SystemDefault = 0,
                SingleBitPerPixelGridFit = 1,
                SingleBitPerPixel = 2,
                AntiAliasGridFit = 3,
                AntiAlias = 4,
                ClearTypeGridFit = 5,
            }
        }
        public sealed class TextureBrush : System.Drawing.Brush
        {
            public override object Clone() => throw null;
            public TextureBrush(System.Drawing.Image bitmap) => throw null;
            public TextureBrush(System.Drawing.Image image, System.Drawing.Drawing2D.WrapMode wrapMode) => throw null;
            public TextureBrush(System.Drawing.Image image, System.Drawing.Drawing2D.WrapMode wrapMode, System.Drawing.Rectangle dstRect) => throw null;
            public TextureBrush(System.Drawing.Image image, System.Drawing.Drawing2D.WrapMode wrapMode, System.Drawing.RectangleF dstRect) => throw null;
            public TextureBrush(System.Drawing.Image image, System.Drawing.Rectangle dstRect) => throw null;
            public TextureBrush(System.Drawing.Image image, System.Drawing.Rectangle dstRect, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public TextureBrush(System.Drawing.Image image, System.Drawing.RectangleF dstRect) => throw null;
            public TextureBrush(System.Drawing.Image image, System.Drawing.RectangleF dstRect, System.Drawing.Imaging.ImageAttributes imageAttr) => throw null;
            public System.Drawing.Image Image { get => throw null; }
            public void MultiplyTransform(System.Drawing.Drawing2D.Matrix matrix) => throw null;
            public void MultiplyTransform(System.Drawing.Drawing2D.Matrix matrix, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
            public void ResetTransform() => throw null;
            public void RotateTransform(float angle) => throw null;
            public void RotateTransform(float angle, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
            public void ScaleTransform(float sx, float sy) => throw null;
            public void ScaleTransform(float sx, float sy, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
            public System.Drawing.Drawing2D.Matrix Transform { get => throw null; set { } }
            public void TranslateTransform(float dx, float dy) => throw null;
            public void TranslateTransform(float dx, float dy, System.Drawing.Drawing2D.MatrixOrder order) => throw null;
            public System.Drawing.Drawing2D.WrapMode WrapMode { get => throw null; set { } }
        }
        [System.AttributeUsage((System.AttributeTargets)4)]
        public class ToolboxBitmapAttribute : System.Attribute
        {
            public ToolboxBitmapAttribute(string imageFile) => throw null;
            public ToolboxBitmapAttribute(System.Type t) => throw null;
            public ToolboxBitmapAttribute(System.Type t, string name) => throw null;
            public static readonly System.Drawing.ToolboxBitmapAttribute Default;
            public override bool Equals(object value) => throw null;
            public override int GetHashCode() => throw null;
            public System.Drawing.Image GetImage(object component) => throw null;
            public System.Drawing.Image GetImage(object component, bool large) => throw null;
            public System.Drawing.Image GetImage(System.Type type) => throw null;
            public System.Drawing.Image GetImage(System.Type type, bool large) => throw null;
            public System.Drawing.Image GetImage(System.Type type, string imgName, bool large) => throw null;
            public static System.Drawing.Image GetImageFromResource(System.Type t, string imageName, bool large) => throw null;
        }
    }
}
