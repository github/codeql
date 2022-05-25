// Generated automatically from android.text.Editable for testing purposes

package android.text;

import android.text.GetChars;
import android.text.InputFilter;
import android.text.Spannable;

public interface Editable extends Appendable, CharSequence, GetChars, Spannable
{
    Editable append(CharSequence p0);
    Editable append(CharSequence p0, int p1, int p2);
    Editable append(char p0);
    Editable delete(int p0, int p1);
    Editable insert(int p0, CharSequence p1);
    Editable insert(int p0, CharSequence p1, int p2, int p3);
    Editable replace(int p0, int p1, CharSequence p2);
    Editable replace(int p0, int p1, CharSequence p2, int p3, int p4);
    InputFilter[] getFilters();
    static public class Factory
    {
        public Editable newEditable(CharSequence p0){ return null; }
        public Factory(){}
        public static Editable.Factory getInstance(){ return null; }
    }
    void clear();
    void clearSpans();
    void setFilters(InputFilter[] p0);
}
