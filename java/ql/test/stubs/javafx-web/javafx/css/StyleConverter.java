// Generated automatically from javafx.css.StyleConverter for testing purposes

package javafx.css;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.util.List;
import java.util.Map;
import javafx.css.CssMetaData;
import javafx.css.ParsedValue;
import javafx.css.Styleable;
import javafx.geometry.Insets;
import javafx.scene.effect.Effect;
import javafx.scene.paint.Color;
import javafx.scene.paint.Paint;
import javafx.scene.text.Font;
import javafx.util.Duration;

public class StyleConverter<F, T>
{
    protected T getCachedValue(ParsedValue p0){ return null; }
    protected void cacheValue(ParsedValue p0, Object p1){}
    public StyleConverter(){}
    public T convert(Map<CssMetaData<? extends Styleable, ? extends Object>, Object> p0){ return null; }
    public T convert(ParsedValue<F, T> p0, Font p1){ return null; }
    public static <E extends java.lang.Enum<E>> StyleConverter<String, E> getEnumConverter(java.lang.Class<E> p0){ return null; }
    public static StyleConverter<? extends Object, ? extends Object> readBinary(DataInputStream p0, String[] p1){ return null; }
    public static StyleConverter<? extends Object, Duration> getDurationConverter(){ return null; }
    public static StyleConverter<? extends Object, Number> getSizeConverter(){ return null; }
    public static StyleConverter<ParsedValue<? extends Object, Paint>, Paint> getPaintConverter(){ return null; }
    public static StyleConverter<ParsedValue[], Effect> getEffectConverter(){ return null; }
    public static StyleConverter<ParsedValue[], Font> getFontConverter(){ return null; }
    public static StyleConverter<ParsedValue[], Insets> getInsetsConverter(){ return null; }
    public static StyleConverter<ParsedValue[], String> getUrlConverter(){ return null; }
    public static StyleConverter<String, Boolean> getBooleanConverter(){ return null; }
    public static StyleConverter<String, Color> getColorConverter(){ return null; }
    public static StyleConverter<String, String> getStringConverter(){ return null; }
    public static void clearCache(){}
    public void writeBinary(DataOutputStream p0, StyleConverter.StringStore p1){}
    static public class StringStore
    {
        public StringStore(){}
        public final List<String> strings = null;
        public int addString(String p0){ return 0; }
        public static String[] readBinary(DataInputStream p0){ return null; }
        public void writeBinary(DataOutputStream p0){}
    }
}
