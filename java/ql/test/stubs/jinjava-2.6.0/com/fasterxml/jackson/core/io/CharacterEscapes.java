// Generated automatically from com.fasterxml.jackson.core.io.CharacterEscapes for testing purposes

package com.fasterxml.jackson.core.io;

import com.fasterxml.jackson.core.SerializableString;
import java.io.Serializable;

abstract public class CharacterEscapes implements Serializable
{
    public CharacterEscapes(){}
    public abstract SerializableString getEscapeSequence(int p0);
    public abstract int[] getEscapeCodesForAscii();
    public static int ESCAPE_CUSTOM = 0;
    public static int ESCAPE_NONE = 0;
    public static int ESCAPE_STANDARD = 0;
    public static int[] standardAsciiEscapesForJSON(){ return null; }
}
