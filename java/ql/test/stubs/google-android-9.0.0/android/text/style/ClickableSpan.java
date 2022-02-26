// Generated automatically from android.text.style.ClickableSpan for testing purposes

package android.text.style;

import android.text.TextPaint;
import android.text.style.CharacterStyle;
import android.text.style.UpdateAppearance;
import android.view.View;

abstract public class ClickableSpan extends CharacterStyle implements UpdateAppearance
{
    public ClickableSpan(){}
    public abstract void onClick(View p0);
    public void updateDrawState(TextPaint p0){}
}
