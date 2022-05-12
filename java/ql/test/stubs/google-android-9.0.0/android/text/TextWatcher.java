// Generated automatically from android.text.TextWatcher for testing purposes

package android.text;

import android.text.Editable;
import android.text.NoCopySpan;

public interface TextWatcher extends NoCopySpan
{
    void afterTextChanged(Editable p0);
    void beforeTextChanged(CharSequence p0, int p1, int p2, int p3);
    void onTextChanged(CharSequence p0, int p1, int p2, int p3);
}
