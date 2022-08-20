// Generated automatically from android.content.SharedPreferences for testing purposes

package android.content;

import java.util.Map;
import java.util.Set;

public interface SharedPreferences
{
    Map<String, ? extends Object> getAll();
    Set<String> getStringSet(String p0, Set<String> p1);
    SharedPreferences.Editor edit();
    String getString(String p0, String p1);
    boolean contains(String p0);
    boolean getBoolean(String p0, boolean p1);
    float getFloat(String p0, float p1);
    int getInt(String p0, int p1);
    long getLong(String p0, long p1);
    static public interface Editor
    {
        SharedPreferences.Editor clear();
        SharedPreferences.Editor putBoolean(String p0, boolean p1);
        SharedPreferences.Editor putFloat(String p0, float p1);
        SharedPreferences.Editor putInt(String p0, int p1);
        SharedPreferences.Editor putLong(String p0, long p1);
        SharedPreferences.Editor putString(String p0, String p1);
        SharedPreferences.Editor putStringSet(String p0, Set<String> p1);
        SharedPreferences.Editor remove(String p0);
        boolean commit();
        void apply();
    }
    static public interface OnSharedPreferenceChangeListener
    {
        void onSharedPreferenceChanged(SharedPreferences p0, String p1);
    }
    void registerOnSharedPreferenceChangeListener(SharedPreferences.OnSharedPreferenceChangeListener p0);
    void unregisterOnSharedPreferenceChangeListener(SharedPreferences.OnSharedPreferenceChangeListener p0);
}
