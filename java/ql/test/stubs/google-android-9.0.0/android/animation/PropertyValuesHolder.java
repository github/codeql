// Generated automatically from android.animation.PropertyValuesHolder for testing purposes

package android.animation;

import android.animation.Keyframe;
import android.animation.TypeConverter;
import android.animation.TypeEvaluator;
import android.graphics.Path;
import android.graphics.PointF;
import android.util.Property;

public class PropertyValuesHolder implements Cloneable
{
    protected PropertyValuesHolder() {}
    public PropertyValuesHolder clone(){ return null; }
    public String getPropertyName(){ return null; }
    public String toString(){ return null; }
    public static <T, V> PropertyValuesHolder ofObject(Property<? extends Object, V> p0, TypeConverter<T, V> p1, TypeEvaluator<T> p2, T... p3){ return null; }
    public static <T> PropertyValuesHolder ofMultiFloat(String p0, TypeConverter<T, float[]> p1, TypeEvaluator<T> p2, Keyframe... p3){ return null; }
    public static <T> PropertyValuesHolder ofMultiInt(String p0, TypeConverter<T, int[]> p1, TypeEvaluator<T> p2, Keyframe... p3){ return null; }
    public static <V> PropertyValuesHolder ofMultiFloat(String p0, TypeConverter<V, float[]> p1, TypeEvaluator<V> p2, V... p3){ return null; }
    public static <V> PropertyValuesHolder ofMultiInt(String p0, TypeConverter<V, int[]> p1, TypeEvaluator<V> p2, V... p3){ return null; }
    public static <V> PropertyValuesHolder ofObject(Property p0, TypeEvaluator<V> p1, V... p2){ return null; }
    public static <V> PropertyValuesHolder ofObject(Property<? extends Object, V> p0, TypeConverter<PointF, V> p1, Path p2){ return null; }
    public static PropertyValuesHolder ofFloat(Property<? extends Object, Float> p0, float... p1){ return null; }
    public static PropertyValuesHolder ofFloat(String p0, float... p1){ return null; }
    public static PropertyValuesHolder ofInt(Property<? extends Object, Integer> p0, int... p1){ return null; }
    public static PropertyValuesHolder ofInt(String p0, int... p1){ return null; }
    public static PropertyValuesHolder ofKeyframe(Property p0, Keyframe... p1){ return null; }
    public static PropertyValuesHolder ofKeyframe(String p0, Keyframe... p1){ return null; }
    public static PropertyValuesHolder ofMultiFloat(String p0, Path p1){ return null; }
    public static PropertyValuesHolder ofMultiFloat(String p0, float[][] p1){ return null; }
    public static PropertyValuesHolder ofMultiInt(String p0, Path p1){ return null; }
    public static PropertyValuesHolder ofMultiInt(String p0, int[][] p1){ return null; }
    public static PropertyValuesHolder ofObject(String p0, TypeConverter<PointF, ? extends Object> p1, Path p2){ return null; }
    public static PropertyValuesHolder ofObject(String p0, TypeEvaluator p1, Object... p2){ return null; }
    public void setConverter(TypeConverter p0){}
    public void setEvaluator(TypeEvaluator p0){}
    public void setFloatValues(float... p0){}
    public void setIntValues(int... p0){}
    public void setKeyframes(Keyframe... p0){}
    public void setObjectValues(Object... p0){}
    public void setProperty(Property p0){}
    public void setPropertyName(String p0){}
}
