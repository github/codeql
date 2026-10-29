// Generated automatically from android.view.KeyCharacterMap for testing purposes

package android.view;

import android.os.Parcel;
import android.os.Parcelable;
import android.view.KeyEvent;

public class KeyCharacterMap implements Parcelable
{
    protected KeyCharacterMap() {}
    protected void finalize(){}
    public KeyEvent[] getEvents(char[] p0){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean getKeyData(int p0, KeyCharacterMap.KeyData p1){ return false; }
    public boolean isPrintingKey(int p0){ return false; }
    public char getDisplayLabel(int p0){ return '0'; }
    public char getMatch(int p0, char[] p1){ return '0'; }
    public char getMatch(int p0, char[] p1, int p2){ return '0'; }
    public char getNumber(int p0){ return '0'; }
    public int describeContents(){ return 0; }
    public int get(int p0, int p1){ return 0; }
    public int getKeyboardType(){ return 0; }
    public int getModifierBehavior(){ return 0; }
    public static KeyCharacterMap load(int p0){ return null; }
    public static Parcelable.Creator<KeyCharacterMap> CREATOR = null;
    public static boolean deviceHasKey(int p0){ return false; }
    public static boolean[] deviceHasKeys(int[] p0){ return null; }
    public static char HEX_INPUT = '0';
    public static char PICKER_DIALOG_INPUT = '0';
    public static int ALPHA = 0;
    public static int BUILT_IN_KEYBOARD = 0;
    public static int COMBINING_ACCENT = 0;
    public static int COMBINING_ACCENT_MASK = 0;
    public static int FULL = 0;
    public static int MODIFIER_BEHAVIOR_CHORDED = 0;
    public static int MODIFIER_BEHAVIOR_CHORDED_OR_TOGGLED = 0;
    public static int NUMERIC = 0;
    public static int PREDICTIVE = 0;
    public static int SPECIAL_FUNCTION = 0;
    public static int VIRTUAL_KEYBOARD = 0;
    public static int getDeadChar(int p0, int p1){ return 0; }
    public void writeToParcel(Parcel p0, int p1){}
    static public class KeyData
    {
        public KeyData(){}
        public char displayLabel = '0';
        public char number = '0';
        public char[] meta = null;
        public static int META_LENGTH = 0;
    }
}
