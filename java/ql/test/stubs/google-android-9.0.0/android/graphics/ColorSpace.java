// Generated automatically from android.graphics.ColorSpace for testing purposes

package android.graphics;

import java.util.function.DoubleUnaryOperator;

abstract public class ColorSpace
{
    public ColorSpace.Model getModel(){ return null; }
    public String getName(){ return null; }
    public String toString(){ return null; }
    public abstract boolean isWideGamut();
    public abstract float getMaxValue(int p0);
    public abstract float getMinValue(int p0);
    public abstract float[] fromXyz(float[] p0);
    public abstract float[] toXyz(float[] p0);
    public boolean equals(Object p0){ return false; }
    public boolean isSrgb(){ return false; }
    public float[] fromXyz(float p0, float p1, float p2){ return null; }
    public float[] toXyz(float p0, float p1, float p2){ return null; }
    public int getComponentCount(){ return 0; }
    public int getId(){ return 0; }
    public int hashCode(){ return 0; }
    public static ColorSpace adapt(ColorSpace p0, float[] p1){ return null; }
    public static ColorSpace adapt(ColorSpace p0, float[] p1, ColorSpace.Adaptation p2){ return null; }
    public static ColorSpace get(ColorSpace.Named p0){ return null; }
    public static ColorSpace match(float[] p0, ColorSpace.Rgb.TransferParameters p1){ return null; }
    public static ColorSpace.Connector connect(ColorSpace p0){ return null; }
    public static ColorSpace.Connector connect(ColorSpace p0, ColorSpace p1){ return null; }
    public static ColorSpace.Connector connect(ColorSpace p0, ColorSpace p1, ColorSpace.RenderIntent p2){ return null; }
    public static ColorSpace.Connector connect(ColorSpace p0, ColorSpace.RenderIntent p1){ return null; }
    public static float[] ILLUMINANT_A = null;
    public static float[] ILLUMINANT_B = null;
    public static float[] ILLUMINANT_C = null;
    public static float[] ILLUMINANT_D50 = null;
    public static float[] ILLUMINANT_D55 = null;
    public static float[] ILLUMINANT_D60 = null;
    public static float[] ILLUMINANT_D65 = null;
    public static float[] ILLUMINANT_D75 = null;
    public static float[] ILLUMINANT_E = null;
    public static float[] cctToXyz(int p0){ return null; }
    public static float[] chromaticAdaptation(ColorSpace.Adaptation p0, float[] p1, float[] p2){ return null; }
    public static int MAX_ID = 0;
    public static int MIN_ID = 0;
    static public class Connector
    {
        public ColorSpace getDestination(){ return null; }
        public ColorSpace getSource(){ return null; }
        public ColorSpace.RenderIntent getRenderIntent(){ return null; }
        public float[] transform(float p0, float p1, float p2){ return null; }
        public float[] transform(float[] p0){ return null; }
    }
    static public class Rgb extends ColorSpace
    {
        protected Rgb() {}
        public ColorSpace.Rgb.TransferParameters getTransferParameters(){ return null; }
        public DoubleUnaryOperator getEotf(){ return null; }
        public DoubleUnaryOperator getOetf(){ return null; }
        public Rgb(String p0, float[] p1, ColorSpace.Rgb.TransferParameters p2){}
        public Rgb(String p0, float[] p1, DoubleUnaryOperator p2, DoubleUnaryOperator p3){}
        public Rgb(String p0, float[] p1, double p2){}
        public Rgb(String p0, float[] p1, float[] p2, ColorSpace.Rgb.TransferParameters p3){}
        public Rgb(String p0, float[] p1, float[] p2, DoubleUnaryOperator p3, DoubleUnaryOperator p4, float p5, float p6){}
        public Rgb(String p0, float[] p1, float[] p2, double p3){}
        public boolean equals(Object p0){ return false; }
        public boolean isSrgb(){ return false; }
        public boolean isWideGamut(){ return false; }
        public float getMaxValue(int p0){ return 0; }
        public float getMinValue(int p0){ return 0; }
        public float[] fromLinear(float p0, float p1, float p2){ return null; }
        public float[] fromLinear(float[] p0){ return null; }
        public float[] fromXyz(float[] p0){ return null; }
        public float[] getInverseTransform(){ return null; }
        public float[] getInverseTransform(float[] p0){ return null; }
        public float[] getPrimaries(){ return null; }
        public float[] getPrimaries(float[] p0){ return null; }
        public float[] getTransform(){ return null; }
        public float[] getTransform(float[] p0){ return null; }
        public float[] getWhitePoint(){ return null; }
        public float[] getWhitePoint(float[] p0){ return null; }
        public float[] toLinear(float p0, float p1, float p2){ return null; }
        public float[] toLinear(float[] p0){ return null; }
        public float[] toXyz(float[] p0){ return null; }
        public int hashCode(){ return 0; }
        static public class TransferParameters
        {
            protected TransferParameters() {}
            public TransferParameters(double p0, double p1, double p2, double p3, double p4){}
            public TransferParameters(double p0, double p1, double p2, double p3, double p4, double p5, double p6){}
            public boolean equals(Object p0){ return false; }
            public final double a = 0;
            public final double b = 0;
            public final double c = 0;
            public final double d = 0;
            public final double e = 0;
            public final double f = 0;
            public final double g = 0;
            public int hashCode(){ return 0; }
        }
    }
    static public enum Adaptation
    {
        BRADFORD, CIECAT02, VON_KRIES;
        private Adaptation() {}
    }
    static public enum Model
    {
        CMYK, LAB, RGB, XYZ;
        private Model() {}
        public int getComponentCount(){ return 0; }
    }
    static public enum Named
    {
        ACES, ACESCG, ADOBE_RGB, BT2020, BT709, CIE_LAB, CIE_XYZ, DCI_P3, DISPLAY_P3, EXTENDED_SRGB, LINEAR_EXTENDED_SRGB, LINEAR_SRGB, NTSC_1953, PRO_PHOTO_RGB, SMPTE_C, SRGB;
        private Named() {}
    }
    static public enum RenderIntent
    {
        ABSOLUTE, PERCEPTUAL, RELATIVE, SATURATION;
        private RenderIntent() {}
    }
}
