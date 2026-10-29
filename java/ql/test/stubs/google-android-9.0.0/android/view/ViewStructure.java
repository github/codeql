// Generated automatically from android.view.ViewStructure for testing purposes

package android.view;

import android.graphics.Matrix;
import android.os.Bundle;
import android.os.LocaleList;
import android.util.Pair;
import android.view.autofill.AutofillId;
import android.view.autofill.AutofillValue;
import java.util.List;

abstract public class ViewStructure
{
    abstract static public class HtmlInfo
    {
        abstract static public class Builder
        {
            public Builder(){}
            public abstract ViewStructure.HtmlInfo build();
            public abstract ViewStructure.HtmlInfo.Builder addAttribute(String p0, String p1);
        }
        public HtmlInfo(){}
        public abstract List<Pair<String, String>> getAttributes();
        public abstract String getTag();
    }
    public ViewStructure(){}
    public abstract AutofillId getAutofillId();
    public abstract Bundle getExtras();
    public abstract CharSequence getHint();
    public abstract CharSequence getText();
    public abstract ViewStructure asyncNewChild(int p0);
    public abstract ViewStructure newChild(int p0);
    public abstract ViewStructure.HtmlInfo.Builder newHtmlInfoBuilder(String p0);
    public abstract boolean hasExtras();
    public abstract int addChildCount(int p0);
    public abstract int getChildCount();
    public abstract int getTextSelectionEnd();
    public abstract int getTextSelectionStart();
    public abstract void asyncCommit();
    public abstract void setAccessibilityFocused(boolean p0);
    public abstract void setActivated(boolean p0);
    public abstract void setAlpha(float p0);
    public abstract void setAutofillHints(String[] p0);
    public abstract void setAutofillId(AutofillId p0);
    public abstract void setAutofillId(AutofillId p0, int p1);
    public abstract void setAutofillOptions(CharSequence[] p0);
    public abstract void setAutofillType(int p0);
    public abstract void setAutofillValue(AutofillValue p0);
    public abstract void setCheckable(boolean p0);
    public abstract void setChecked(boolean p0);
    public abstract void setChildCount(int p0);
    public abstract void setClassName(String p0);
    public abstract void setClickable(boolean p0);
    public abstract void setContentDescription(CharSequence p0);
    public abstract void setContextClickable(boolean p0);
    public abstract void setDataIsSensitive(boolean p0);
    public abstract void setDimens(int p0, int p1, int p2, int p3, int p4, int p5);
    public abstract void setElevation(float p0);
    public abstract void setEnabled(boolean p0);
    public abstract void setFocusable(boolean p0);
    public abstract void setFocused(boolean p0);
    public abstract void setHint(CharSequence p0);
    public abstract void setHtmlInfo(ViewStructure.HtmlInfo p0);
    public abstract void setId(int p0, String p1, String p2, String p3);
    public abstract void setInputType(int p0);
    public abstract void setLocaleList(LocaleList p0);
    public abstract void setLongClickable(boolean p0);
    public abstract void setOpaque(boolean p0);
    public abstract void setSelected(boolean p0);
    public abstract void setText(CharSequence p0);
    public abstract void setText(CharSequence p0, int p1, int p2);
    public abstract void setTextLines(int[] p0, int[] p1);
    public abstract void setTextStyle(float p0, int p1, int p2, int p3);
    public abstract void setTransformation(Matrix p0);
    public abstract void setVisibility(int p0);
    public abstract void setWebDomain(String p0);
    public void setHintIdEntry(String p0){}
    public void setImportantForAutofill(int p0){}
    public void setMaxTextEms(int p0){}
    public void setMaxTextLength(int p0){}
    public void setMinTextEms(int p0){}
    public void setReceiveContentMimeTypes(String[] p0){}
    public void setTextIdEntry(String p0){}
}
