// Generated automatically from android.print.PrintAttributes for testing purposes

package android.print;

import android.content.pm.PackageManager;
import android.os.Parcel;
import android.os.Parcelable;

public class PrintAttributes implements Parcelable
{
    public PrintAttributes.Margins getMinMargins(){ return null; }
    public PrintAttributes.MediaSize getMediaSize(){ return null; }
    public PrintAttributes.Resolution getResolution(){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int describeContents(){ return 0; }
    public int getColorMode(){ return 0; }
    public int getDuplexMode(){ return 0; }
    public int hashCode(){ return 0; }
    public static Parcelable.Creator<PrintAttributes> CREATOR = null;
    public static int COLOR_MODE_COLOR = 0;
    public static int COLOR_MODE_MONOCHROME = 0;
    public static int DUPLEX_MODE_LONG_EDGE = 0;
    public static int DUPLEX_MODE_NONE = 0;
    public static int DUPLEX_MODE_SHORT_EDGE = 0;
    public void writeToParcel(Parcel p0, int p1){}
    static public class Margins
    {
        protected Margins() {}
        public Margins(int p0, int p1, int p2, int p3){}
        public String toString(){ return null; }
        public boolean equals(Object p0){ return false; }
        public int getBottomMils(){ return 0; }
        public int getLeftMils(){ return 0; }
        public int getRightMils(){ return 0; }
        public int getTopMils(){ return 0; }
        public int hashCode(){ return 0; }
        public static PrintAttributes.Margins NO_MARGINS = null;
    }
    static public class MediaSize
    {
        protected MediaSize() {}
        public MediaSize(String p0, String p1, int p2, int p3){}
        public PrintAttributes.MediaSize asLandscape(){ return null; }
        public PrintAttributes.MediaSize asPortrait(){ return null; }
        public String getId(){ return null; }
        public String getLabel(PackageManager p0){ return null; }
        public String toString(){ return null; }
        public boolean equals(Object p0){ return false; }
        public boolean isPortrait(){ return false; }
        public int getHeightMils(){ return 0; }
        public int getWidthMils(){ return 0; }
        public int hashCode(){ return 0; }
        public static PrintAttributes.MediaSize ANSI_C = null;
        public static PrintAttributes.MediaSize ANSI_D = null;
        public static PrintAttributes.MediaSize ANSI_E = null;
        public static PrintAttributes.MediaSize ANSI_F = null;
        public static PrintAttributes.MediaSize ISO_A0 = null;
        public static PrintAttributes.MediaSize ISO_A1 = null;
        public static PrintAttributes.MediaSize ISO_A10 = null;
        public static PrintAttributes.MediaSize ISO_A2 = null;
        public static PrintAttributes.MediaSize ISO_A3 = null;
        public static PrintAttributes.MediaSize ISO_A4 = null;
        public static PrintAttributes.MediaSize ISO_A5 = null;
        public static PrintAttributes.MediaSize ISO_A6 = null;
        public static PrintAttributes.MediaSize ISO_A7 = null;
        public static PrintAttributes.MediaSize ISO_A8 = null;
        public static PrintAttributes.MediaSize ISO_A9 = null;
        public static PrintAttributes.MediaSize ISO_B0 = null;
        public static PrintAttributes.MediaSize ISO_B1 = null;
        public static PrintAttributes.MediaSize ISO_B10 = null;
        public static PrintAttributes.MediaSize ISO_B2 = null;
        public static PrintAttributes.MediaSize ISO_B3 = null;
        public static PrintAttributes.MediaSize ISO_B4 = null;
        public static PrintAttributes.MediaSize ISO_B5 = null;
        public static PrintAttributes.MediaSize ISO_B6 = null;
        public static PrintAttributes.MediaSize ISO_B7 = null;
        public static PrintAttributes.MediaSize ISO_B8 = null;
        public static PrintAttributes.MediaSize ISO_B9 = null;
        public static PrintAttributes.MediaSize ISO_C0 = null;
        public static PrintAttributes.MediaSize ISO_C1 = null;
        public static PrintAttributes.MediaSize ISO_C10 = null;
        public static PrintAttributes.MediaSize ISO_C2 = null;
        public static PrintAttributes.MediaSize ISO_C3 = null;
        public static PrintAttributes.MediaSize ISO_C4 = null;
        public static PrintAttributes.MediaSize ISO_C5 = null;
        public static PrintAttributes.MediaSize ISO_C6 = null;
        public static PrintAttributes.MediaSize ISO_C7 = null;
        public static PrintAttributes.MediaSize ISO_C8 = null;
        public static PrintAttributes.MediaSize ISO_C9 = null;
        public static PrintAttributes.MediaSize JIS_B0 = null;
        public static PrintAttributes.MediaSize JIS_B1 = null;
        public static PrintAttributes.MediaSize JIS_B10 = null;
        public static PrintAttributes.MediaSize JIS_B2 = null;
        public static PrintAttributes.MediaSize JIS_B3 = null;
        public static PrintAttributes.MediaSize JIS_B4 = null;
        public static PrintAttributes.MediaSize JIS_B5 = null;
        public static PrintAttributes.MediaSize JIS_B6 = null;
        public static PrintAttributes.MediaSize JIS_B7 = null;
        public static PrintAttributes.MediaSize JIS_B8 = null;
        public static PrintAttributes.MediaSize JIS_B9 = null;
        public static PrintAttributes.MediaSize JIS_EXEC = null;
        public static PrintAttributes.MediaSize JPN_CHOU2 = null;
        public static PrintAttributes.MediaSize JPN_CHOU3 = null;
        public static PrintAttributes.MediaSize JPN_CHOU4 = null;
        public static PrintAttributes.MediaSize JPN_HAGAKI = null;
        public static PrintAttributes.MediaSize JPN_KAHU = null;
        public static PrintAttributes.MediaSize JPN_KAKU2 = null;
        public static PrintAttributes.MediaSize JPN_OE_PHOTO_L = null;
        public static PrintAttributes.MediaSize JPN_OUFUKU = null;
        public static PrintAttributes.MediaSize JPN_YOU4 = null;
        public static PrintAttributes.MediaSize NA_ARCH_A = null;
        public static PrintAttributes.MediaSize NA_ARCH_B = null;
        public static PrintAttributes.MediaSize NA_ARCH_C = null;
        public static PrintAttributes.MediaSize NA_ARCH_D = null;
        public static PrintAttributes.MediaSize NA_ARCH_E = null;
        public static PrintAttributes.MediaSize NA_ARCH_E1 = null;
        public static PrintAttributes.MediaSize NA_FOOLSCAP = null;
        public static PrintAttributes.MediaSize NA_GOVT_LETTER = null;
        public static PrintAttributes.MediaSize NA_INDEX_3X5 = null;
        public static PrintAttributes.MediaSize NA_INDEX_4X6 = null;
        public static PrintAttributes.MediaSize NA_INDEX_5X8 = null;
        public static PrintAttributes.MediaSize NA_JUNIOR_LEGAL = null;
        public static PrintAttributes.MediaSize NA_LEDGER = null;
        public static PrintAttributes.MediaSize NA_LEGAL = null;
        public static PrintAttributes.MediaSize NA_LETTER = null;
        public static PrintAttributes.MediaSize NA_MONARCH = null;
        public static PrintAttributes.MediaSize NA_QUARTO = null;
        public static PrintAttributes.MediaSize NA_SUPER_B = null;
        public static PrintAttributes.MediaSize NA_TABLOID = null;
        public static PrintAttributes.MediaSize OM_DAI_PA_KAI = null;
        public static PrintAttributes.MediaSize OM_JUURO_KU_KAI = null;
        public static PrintAttributes.MediaSize OM_PA_KAI = null;
        public static PrintAttributes.MediaSize PRC_1 = null;
        public static PrintAttributes.MediaSize PRC_10 = null;
        public static PrintAttributes.MediaSize PRC_16K = null;
        public static PrintAttributes.MediaSize PRC_2 = null;
        public static PrintAttributes.MediaSize PRC_3 = null;
        public static PrintAttributes.MediaSize PRC_4 = null;
        public static PrintAttributes.MediaSize PRC_5 = null;
        public static PrintAttributes.MediaSize PRC_6 = null;
        public static PrintAttributes.MediaSize PRC_7 = null;
        public static PrintAttributes.MediaSize PRC_8 = null;
        public static PrintAttributes.MediaSize PRC_9 = null;
        public static PrintAttributes.MediaSize ROC_16K = null;
        public static PrintAttributes.MediaSize ROC_8K = null;
        public static PrintAttributes.MediaSize UNKNOWN_LANDSCAPE = null;
        public static PrintAttributes.MediaSize UNKNOWN_PORTRAIT = null;
    }
    static public class Resolution
    {
        protected Resolution() {}
        public Resolution(String p0, String p1, int p2, int p3){}
        public String getId(){ return null; }
        public String getLabel(){ return null; }
        public String toString(){ return null; }
        public boolean equals(Object p0){ return false; }
        public int getHorizontalDpi(){ return 0; }
        public int getVerticalDpi(){ return 0; }
        public int hashCode(){ return 0; }
    }
}
