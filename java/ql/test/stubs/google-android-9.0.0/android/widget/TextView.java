// Generated automatically from android.widget.TextView for testing purposes

package android.widget;

import android.content.Context;
import android.content.res.ColorStateList;
import android.content.res.Configuration;
import android.graphics.BlendMode;
import android.graphics.Canvas;
import android.graphics.PorterDuff;
import android.graphics.Rect;
import android.graphics.Typeface;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.os.LocaleList;
import android.os.Parcelable;
import android.text.Editable;
import android.text.InputFilter;
import android.text.Layout;
import android.text.PrecomputedText;
import android.text.Spannable;
import android.text.TextDirectionHeuristic;
import android.text.TextPaint;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.text.method.KeyListener;
import android.text.method.MovementMethod;
import android.text.method.TransformationMethod;
import android.text.style.URLSpan;
import android.util.AttributeSet;
import android.view.ActionMode;
import android.view.ContentInfo;
import android.view.ContextMenu;
import android.view.DragEvent;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.PointerIcon;
import android.view.View;
import android.view.ViewTreeObserver;
import android.view.accessibility.AccessibilityEvent;
import android.view.accessibility.AccessibilityNodeInfo;
import android.view.autofill.AutofillValue;
import android.view.inputmethod.CompletionInfo;
import android.view.inputmethod.CorrectionInfo;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.ExtractedText;
import android.view.inputmethod.ExtractedTextRequest;
import android.view.inputmethod.InputConnection;
import android.view.textclassifier.TextClassifier;
import android.view.translation.ViewTranslationRequest;
import android.widget.Scroller;
import java.util.ArrayList;
import java.util.Locale;
import java.util.function.Consumer;

public class TextView extends View implements ViewTreeObserver.OnPreDrawListener
{
    protected TextView() {}
    protected MovementMethod getDefaultMovementMethod(){ return null; }
    protected boolean getDefaultEditable(){ return false; }
    protected boolean isPaddingOffsetRequired(){ return false; }
    protected boolean setFrame(int p0, int p1, int p2, int p3){ return false; }
    protected boolean verifyDrawable(Drawable p0){ return false; }
    protected float getLeftFadingEdgeStrength(){ return 0; }
    protected float getRightFadingEdgeStrength(){ return 0; }
    protected int computeHorizontalScrollRange(){ return 0; }
    protected int computeVerticalScrollExtent(){ return 0; }
    protected int computeVerticalScrollRange(){ return 0; }
    protected int getBottomPaddingOffset(){ return 0; }
    protected int getLeftPaddingOffset(){ return 0; }
    protected int getRightPaddingOffset(){ return 0; }
    protected int getTopPaddingOffset(){ return 0; }
    protected int[] onCreateDrawableState(int p0){ return null; }
    protected void drawableStateChanged(){}
    protected void onAttachedToWindow(){}
    protected void onConfigurationChanged(Configuration p0){}
    protected void onCreateContextMenu(ContextMenu p0){}
    protected void onDraw(Canvas p0){}
    protected void onFocusChanged(boolean p0, int p1, Rect p2){}
    protected void onLayout(boolean p0, int p1, int p2, int p3, int p4){}
    protected void onMeasure(int p0, int p1){}
    protected void onScrollChanged(int p0, int p1, int p2, int p3){}
    protected void onSelectionChanged(int p0, int p1){}
    protected void onTextChanged(CharSequence p0, int p1, int p2, int p3){}
    protected void onVisibilityChanged(View p0, int p1){}
    public ActionMode.Callback getCustomInsertionActionModeCallback(){ return null; }
    public ActionMode.Callback getCustomSelectionActionModeCallback(){ return null; }
    public AutofillValue getAutofillValue(){ return null; }
    public BlendMode getCompoundDrawableTintBlendMode(){ return null; }
    public Bundle getInputExtras(boolean p0){ return null; }
    public CharSequence getAccessibilityClassName(){ return null; }
    public CharSequence getError(){ return null; }
    public CharSequence getHint(){ return null; }
    public CharSequence getImeActionLabel(){ return null; }
    public CharSequence getText(){ return null; }
    public ColorStateList getCompoundDrawableTintList(){ return null; }
    public ContentInfo onReceiveContent(ContentInfo p0){ return null; }
    public Drawable getTextCursorDrawable(){ return null; }
    public Drawable getTextSelectHandle(){ return null; }
    public Drawable getTextSelectHandleLeft(){ return null; }
    public Drawable getTextSelectHandleRight(){ return null; }
    public Drawable[] getCompoundDrawables(){ return null; }
    public Drawable[] getCompoundDrawablesRelative(){ return null; }
    public Editable getEditableText(){ return null; }
    public InputConnection onCreateInputConnection(EditorInfo p0){ return null; }
    public InputFilter[] getFilters(){ return null; }
    public Locale getTextLocale(){ return null; }
    public LocaleList getImeHintLocales(){ return null; }
    public LocaleList getTextLocales(){ return null; }
    public Parcelable onSaveInstanceState(){ return null; }
    public PointerIcon onResolvePointerIcon(MotionEvent p0, int p1){ return null; }
    public PorterDuff.Mode getCompoundDrawableTintMode(){ return null; }
    public PrecomputedText.Params getTextMetricsParams(){ return null; }
    public String getFontFeatureSettings(){ return null; }
    public String getFontVariationSettings(){ return null; }
    public String getPrivateImeOptions(){ return null; }
    public TextClassifier getTextClassifier(){ return null; }
    public TextDirectionHeuristic getTextDirectionHeuristic(){ return null; }
    public TextPaint getPaint(){ return null; }
    public TextUtils.TruncateAt getEllipsize(){ return null; }
    public TextView(Context p0){}
    public TextView(Context p0, AttributeSet p1){}
    public TextView(Context p0, AttributeSet p1, int p2){}
    public TextView(Context p0, AttributeSet p1, int p2, int p3){}
    public Typeface getTypeface(){ return null; }
    public URLSpan[] getUrls(){ return null; }
    public boolean bringPointIntoView(int p0){ return false; }
    public boolean didTouchFocusSelect(){ return false; }
    public boolean extractText(ExtractedTextRequest p0, ExtractedText p1){ return false; }
    public boolean getFreezesText(){ return false; }
    public boolean getIncludeFontPadding(){ return false; }
    public boolean hasOverlappingRendering(){ return false; }
    public boolean hasSelection(){ return false; }
    public boolean isAllCaps(){ return false; }
    public boolean isCursorVisible(){ return false; }
    public boolean isElegantTextHeight(){ return false; }
    public boolean isFallbackLineSpacing(){ return false; }
    public boolean isInputMethodTarget(){ return false; }
    public boolean isSingleLine(){ return false; }
    public boolean isSuggestionsEnabled(){ return false; }
    public boolean isTextSelectable(){ return false; }
    public boolean moveCursorToVisibleOffset(){ return false; }
    public boolean onCheckIsTextEditor(){ return false; }
    public boolean onDragEvent(DragEvent p0){ return false; }
    public boolean onGenericMotionEvent(MotionEvent p0){ return false; }
    public boolean onKeyDown(int p0, KeyEvent p1){ return false; }
    public boolean onKeyMultiple(int p0, int p1, KeyEvent p2){ return false; }
    public boolean onKeyPreIme(int p0, KeyEvent p1){ return false; }
    public boolean onKeyShortcut(int p0, KeyEvent p1){ return false; }
    public boolean onKeyUp(int p0, KeyEvent p1){ return false; }
    public boolean onPreDraw(){ return false; }
    public boolean onPrivateIMECommand(String p0, Bundle p1){ return false; }
    public boolean onTextContextMenuItem(int p0){ return false; }
    public boolean onTouchEvent(MotionEvent p0){ return false; }
    public boolean onTrackballEvent(MotionEvent p0){ return false; }
    public boolean performLongClick(){ return false; }
    public boolean setFontVariationSettings(String p0){ return false; }
    public boolean showContextMenu(){ return false; }
    public boolean showContextMenu(float p0, float p1){ return false; }
    public final ColorStateList getHintTextColors(){ return null; }
    public final ColorStateList getLinkTextColors(){ return null; }
    public final ColorStateList getTextColors(){ return null; }
    public final KeyListener getKeyListener(){ return null; }
    public final Layout getLayout(){ return null; }
    public final MovementMethod getMovementMethod(){ return null; }
    public final TransformationMethod getTransformationMethod(){ return null; }
    public final boolean getLinksClickable(){ return false; }
    public final boolean getShowSoftInputOnFocus(){ return false; }
    public final boolean isHorizontallyScrollable(){ return false; }
    public final int getAutoLinkMask(){ return 0; }
    public final int getCurrentHintTextColor(){ return 0; }
    public final int getCurrentTextColor(){ return 0; }
    public final void append(CharSequence p0){}
    public final void setAutoLinkMask(int p0){}
    public final void setEditableFactory(Editable.Factory p0){}
    public final void setHint(CharSequence p0){}
    public final void setHint(int p0){}
    public final void setHintTextColor(ColorStateList p0){}
    public final void setHintTextColor(int p0){}
    public final void setLinkTextColor(ColorStateList p0){}
    public final void setLinkTextColor(int p0){}
    public final void setLinksClickable(boolean p0){}
    public final void setMovementMethod(MovementMethod p0){}
    public final void setShowSoftInputOnFocus(boolean p0){}
    public final void setSpannableFactory(Spannable.Factory p0){}
    public final void setText(CharSequence p0){}
    public final void setText(char[] p0, int p1, int p2){}
    public final void setText(int p0){}
    public final void setText(int p0, TextView.BufferType p1){}
    public final void setTextKeepState(CharSequence p0){}
    public final void setTextKeepState(CharSequence p0, TextView.BufferType p1){}
    public final void setTransformationMethod(TransformationMethod p0){}
    public float getLetterSpacing(){ return 0; }
    public float getLineSpacingExtra(){ return 0; }
    public float getLineSpacingMultiplier(){ return 0; }
    public float getShadowDx(){ return 0; }
    public float getShadowDy(){ return 0; }
    public float getShadowRadius(){ return 0; }
    public float getTextScaleX(){ return 0; }
    public float getTextSize(){ return 0; }
    public int getAutoSizeMaxTextSize(){ return 0; }
    public int getAutoSizeMinTextSize(){ return 0; }
    public int getAutoSizeStepGranularity(){ return 0; }
    public int getAutoSizeTextType(){ return 0; }
    public int getAutofillType(){ return 0; }
    public int getBaseline(){ return 0; }
    public int getBreakStrategy(){ return 0; }
    public int getCompoundDrawablePadding(){ return 0; }
    public int getCompoundPaddingBottom(){ return 0; }
    public int getCompoundPaddingEnd(){ return 0; }
    public int getCompoundPaddingLeft(){ return 0; }
    public int getCompoundPaddingRight(){ return 0; }
    public int getCompoundPaddingStart(){ return 0; }
    public int getCompoundPaddingTop(){ return 0; }
    public int getExtendedPaddingBottom(){ return 0; }
    public int getExtendedPaddingTop(){ return 0; }
    public int getFirstBaselineToTopHeight(){ return 0; }
    public int getGravity(){ return 0; }
    public int getHighlightColor(){ return 0; }
    public int getHyphenationFrequency(){ return 0; }
    public int getImeActionId(){ return 0; }
    public int getImeOptions(){ return 0; }
    public int getInputType(){ return 0; }
    public int getJustificationMode(){ return 0; }
    public int getLastBaselineToBottomHeight(){ return 0; }
    public int getLineBounds(int p0, Rect p1){ return 0; }
    public int getLineCount(){ return 0; }
    public int getLineHeight(){ return 0; }
    public int getMarqueeRepeatLimit(){ return 0; }
    public int getMaxEms(){ return 0; }
    public int getMaxHeight(){ return 0; }
    public int getMaxLines(){ return 0; }
    public int getMaxWidth(){ return 0; }
    public int getMinEms(){ return 0; }
    public int getMinHeight(){ return 0; }
    public int getMinLines(){ return 0; }
    public int getMinWidth(){ return 0; }
    public int getOffsetForPosition(float p0, float p1){ return 0; }
    public int getPaintFlags(){ return 0; }
    public int getSelectionEnd(){ return 0; }
    public int getSelectionStart(){ return 0; }
    public int getShadowColor(){ return 0; }
    public int getTextSizeUnit(){ return 0; }
    public int getTotalPaddingBottom(){ return 0; }
    public int getTotalPaddingEnd(){ return 0; }
    public int getTotalPaddingLeft(){ return 0; }
    public int getTotalPaddingRight(){ return 0; }
    public int getTotalPaddingStart(){ return 0; }
    public int getTotalPaddingTop(){ return 0; }
    public int length(){ return 0; }
    public int[] getAutoSizeTextAvailableSizes(){ return null; }
    public static int AUTO_SIZE_TEXT_TYPE_NONE = 0;
    public static int AUTO_SIZE_TEXT_TYPE_UNIFORM = 0;
    public void addExtraDataToAccessibilityNodeInfo(AccessibilityNodeInfo p0, String p1, Bundle p2){}
    public void addTextChangedListener(TextWatcher p0){}
    public void append(CharSequence p0, int p1, int p2){}
    public void autofill(AutofillValue p0){}
    public void beginBatchEdit(){}
    public void cancelLongPress(){}
    public void clearComposingText(){}
    public void computeScroll(){}
    public void debug(int p0){}
    public void drawableHotspotChanged(float p0, float p1){}
    public void endBatchEdit(){}
    public void findViewsWithText(ArrayList<View> p0, CharSequence p1, int p2){}
    public void getFocusedRect(Rect p0){}
    public void invalidateDrawable(Drawable p0){}
    public void jumpDrawablesToCurrentState(){}
    public void onBeginBatchEdit(){}
    public void onCommitCompletion(CompletionInfo p0){}
    public void onCommitCorrection(CorrectionInfo p0){}
    public void onCreateViewTranslationRequest(int[] p0, Consumer<ViewTranslationRequest> p1){}
    public void onEditorAction(int p0){}
    public void onEndBatchEdit(){}
    public void onRestoreInstanceState(Parcelable p0){}
    public void onRtlPropertiesChanged(int p0){}
    public void onScreenStateChanged(int p0){}
    public void onWindowFocusChanged(boolean p0){}
    public void removeTextChangedListener(TextWatcher p0){}
    public void sendAccessibilityEventUnchecked(AccessibilityEvent p0){}
    public void setAllCaps(boolean p0){}
    public void setAutoSizeTextTypeUniformWithConfiguration(int p0, int p1, int p2, int p3){}
    public void setAutoSizeTextTypeUniformWithPresetSizes(int[] p0, int p1){}
    public void setAutoSizeTextTypeWithDefaults(int p0){}
    public void setBreakStrategy(int p0){}
    public void setCompoundDrawablePadding(int p0){}
    public void setCompoundDrawableTintBlendMode(BlendMode p0){}
    public void setCompoundDrawableTintList(ColorStateList p0){}
    public void setCompoundDrawableTintMode(PorterDuff.Mode p0){}
    public void setCompoundDrawables(Drawable p0, Drawable p1, Drawable p2, Drawable p3){}
    public void setCompoundDrawablesRelative(Drawable p0, Drawable p1, Drawable p2, Drawable p3){}
    public void setCompoundDrawablesRelativeWithIntrinsicBounds(Drawable p0, Drawable p1, Drawable p2, Drawable p3){}
    public void setCompoundDrawablesRelativeWithIntrinsicBounds(int p0, int p1, int p2, int p3){}
    public void setCompoundDrawablesWithIntrinsicBounds(Drawable p0, Drawable p1, Drawable p2, Drawable p3){}
    public void setCompoundDrawablesWithIntrinsicBounds(int p0, int p1, int p2, int p3){}
    public void setCursorVisible(boolean p0){}
    public void setCustomInsertionActionModeCallback(ActionMode.Callback p0){}
    public void setCustomSelectionActionModeCallback(ActionMode.Callback p0){}
    public void setElegantTextHeight(boolean p0){}
    public void setEllipsize(TextUtils.TruncateAt p0){}
    public void setEms(int p0){}
    public void setEnabled(boolean p0){}
    public void setError(CharSequence p0){}
    public void setError(CharSequence p0, Drawable p1){}
    public void setExtractedText(ExtractedText p0){}
    public void setFallbackLineSpacing(boolean p0){}
    public void setFilters(InputFilter[] p0){}
    public void setFirstBaselineToTopHeight(int p0){}
    public void setFontFeatureSettings(String p0){}
    public void setFreezesText(boolean p0){}
    public void setGravity(int p0){}
    public void setHeight(int p0){}
    public void setHighlightColor(int p0){}
    public void setHorizontallyScrolling(boolean p0){}
    public void setHyphenationFrequency(int p0){}
    public void setImeActionLabel(CharSequence p0, int p1){}
    public void setImeHintLocales(LocaleList p0){}
    public void setImeOptions(int p0){}
    public void setIncludeFontPadding(boolean p0){}
    public void setInputExtras(int p0){}
    public void setInputType(int p0){}
    public void setJustificationMode(int p0){}
    public void setKeyListener(KeyListener p0){}
    public void setLastBaselineToBottomHeight(int p0){}
    public void setLetterSpacing(float p0){}
    public void setLineHeight(int p0){}
    public void setLineSpacing(float p0, float p1){}
    public void setLines(int p0){}
    public void setMarqueeRepeatLimit(int p0){}
    public void setMaxEms(int p0){}
    public void setMaxHeight(int p0){}
    public void setMaxLines(int p0){}
    public void setMaxWidth(int p0){}
    public void setMinEms(int p0){}
    public void setMinHeight(int p0){}
    public void setMinLines(int p0){}
    public void setMinWidth(int p0){}
    public void setOnEditorActionListener(TextView.OnEditorActionListener p0){}
    public void setPadding(int p0, int p1, int p2, int p3){}
    public void setPaddingRelative(int p0, int p1, int p2, int p3){}
    public void setPaintFlags(int p0){}
    public void setPrivateImeOptions(String p0){}
    public void setRawInputType(int p0){}
    public void setScroller(Scroller p0){}
    public void setSelectAllOnFocus(boolean p0){}
    public void setSelected(boolean p0){}
    public void setShadowLayer(float p0, float p1, float p2, int p3){}
    public void setSingleLine(){}
    public void setSingleLine(boolean p0){}
    public void setText(CharSequence p0, TextView.BufferType p1){}
    public void setTextAppearance(Context p0, int p1){}
    public void setTextAppearance(int p0){}
    public void setTextClassifier(TextClassifier p0){}
    public void setTextColor(ColorStateList p0){}
    public void setTextColor(int p0){}
    public void setTextCursorDrawable(Drawable p0){}
    public void setTextCursorDrawable(int p0){}
    public void setTextIsSelectable(boolean p0){}
    public void setTextLocale(Locale p0){}
    public void setTextLocales(LocaleList p0){}
    public void setTextMetricsParams(PrecomputedText.Params p0){}
    public void setTextScaleX(float p0){}
    public void setTextSelectHandle(Drawable p0){}
    public void setTextSelectHandle(int p0){}
    public void setTextSelectHandleLeft(Drawable p0){}
    public void setTextSelectHandleLeft(int p0){}
    public void setTextSelectHandleRight(Drawable p0){}
    public void setTextSelectHandleRight(int p0){}
    public void setTextSize(float p0){}
    public void setTextSize(int p0, float p1){}
    public void setTypeface(Typeface p0){}
    public void setTypeface(Typeface p0, int p1){}
    public void setWidth(int p0){}
    static public enum BufferType
    {
        EDITABLE, NORMAL, SPANNABLE;
        private BufferType() {}
    }
    static public interface OnEditorActionListener
    {
        boolean onEditorAction(TextView p0, int p1, KeyEvent p2);
    }
}
