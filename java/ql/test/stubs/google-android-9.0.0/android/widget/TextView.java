/*
 * Copyright (C) 2006 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */

package android.widget;

import java.util.ArrayList;
import java.util.Locale;
import android.annotation.Nullable;
import android.content.Context;
import android.content.res.ColorStateList;
import android.content.res.TypedArray;
import android.graphics.BlendMode;
import android.graphics.PorterDuff;
import android.graphics.Rect;
import android.graphics.Typeface;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.os.LocaleList;
import android.os.UserHandle;
import android.util.AttributeSet;
import android.view.View;

public class TextView extends View {
  public @interface XMLTypefaceAttr {

  }
  public @interface AutoSizeTextType {
  }

  public static void preloadFontCache() {}

  public TextView(Context context) {
    super(null);
  }

  public TextView(Context context, AttributeSet attrs) {
    super(null);
  }

  public TextView(Context context, AttributeSet attrs, int defStyleAttr) {
    super(null);
  }

  public TextView(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
    super(null);
  }

  public void setAutoSizeTextTypeWithDefaults(int autoSizeTextType) {}

  public void setAutoSizeTextTypeUniformWithConfiguration(int autoSizeMinTextSize,
      int autoSizeMaxTextSize, int autoSizeStepGranularity, int unit) {}

  public void setAutoSizeTextTypeUniformWithPresetSizes(int[] presetSizes, int unit) {}

  public int getAutoSizeTextType() {
    return 0;
  }

  public int getAutoSizeStepGranularity() {
    return 0;
  }

  public int getAutoSizeMinTextSize() {
    return 0;
  }

  public int getAutoSizeMaxTextSize() {
    return 0;
  }

  public int[] getAutoSizeTextAvailableSizes() {
    return null;
  }

  public void setTypeface(Typeface tf, int style) {}

  public CharSequence getText() {
    return null;
  }

  public int length() {
    return 0;
  }

  public CharSequence getTransformed() {
    return null;
  }

  public int getLineHeight() {
    return 0;
  }

  public int getCompoundPaddingTop() {
    return 0;
  }

  public int getCompoundPaddingBottom() {
    return 0;
  }

  public int getCompoundPaddingLeft() {
    return 0;
  }

  public int getCompoundPaddingRight() {
    return 0;
  }

  public int getCompoundPaddingStart() {
    return 0;
  }

  public int getCompoundPaddingEnd() {
    return 0;
  }

  public int getExtendedPaddingTop() {
    return 0;
  }

  public int getExtendedPaddingBottom() {
    return 0;
  }

  public int getTotalPaddingLeft() {
    return 0;
  }

  public int getTotalPaddingRight() {
    return 0;
  }

  public int getTotalPaddingStart() {
    return 0;
  }

  public int getTotalPaddingEnd() {
    return 0;
  }

  public int getTotalPaddingTop() {
    return 0;
  }

  public int getTotalPaddingBottom() {
    return 0;
  }

  public void setCompoundDrawables(Drawable left, Drawable top, Drawable right, Drawable bottom) {}

  public void setCompoundDrawablesWithIntrinsicBounds(int left, int top, int right, int bottom) {}

  public void setCompoundDrawablesWithIntrinsicBounds(Drawable left, Drawable top, Drawable right,
      Drawable bottom) {}

  public void setCompoundDrawablesRelative(Drawable start, Drawable top, Drawable end,
      Drawable bottom) {}

  public void setCompoundDrawablesRelativeWithIntrinsicBounds(int start, int top, int end,
      int bottom) {}

  public void setCompoundDrawablesRelativeWithIntrinsicBounds(Drawable start, Drawable top,
      Drawable end, Drawable bottom) {}

  public Drawable[] getCompoundDrawables() {
    return null;
  }

  public Drawable[] getCompoundDrawablesRelative() {
    return null;
  }

  public void setCompoundDrawablePadding(int pad) {}

  public int getCompoundDrawablePadding() {
    return 0;
  }

  public void setCompoundDrawableTintList(ColorStateList tint) {}

  public ColorStateList getCompoundDrawableTintList() {
    return null;
  }

  public void setCompoundDrawableTintMode(PorterDuff.Mode tintMode) {}

  public void setCompoundDrawableTintBlendMode(BlendMode blendMode) {}

  public PorterDuff.Mode getCompoundDrawableTintMode() {
    return null;
  }

  public BlendMode getCompoundDrawableTintBlendMode() {
    return null;
  }

  public void setFirstBaselineToTopHeight(int firstBaselineToTopHeight) {}

  public void setLastBaselineToBottomHeight(int lastBaselineToBottomHeight) {}

  public int getFirstBaselineToTopHeight() {
    return 0;
  }

  public int getLastBaselineToBottomHeight() {
    return 0;
  }

  public final int getAutoLinkMask() {
    return 0;
  }

  public void setTextSelectHandle(Drawable textSelectHandle) {}

  public void setTextSelectHandle(int textSelectHandle) {}

  @Nullable
  public Drawable getTextSelectHandle() {
    return null;
  }

  public void setTextSelectHandleLeft(Drawable textSelectHandleLeft) {}

  public void setTextSelectHandleLeft(int textSelectHandleLeft) {}

  @Nullable
  public Drawable getTextSelectHandleLeft() {
    return null;
  }

  public void setTextSelectHandleRight(Drawable textSelectHandleRight) {}

  public void setTextSelectHandleRight(int textSelectHandleRight) {}

  @Nullable
  public Drawable getTextSelectHandleRight() {
    return null;
  }

  public void setTextCursorDrawable(Drawable textCursorDrawable) {}

  public void setTextCursorDrawable(int textCursorDrawable) {}

  @Nullable
  public Drawable getTextCursorDrawable() {
    return null;
  }

  public void setTextAppearance(int resId) {}

  public void setTextAppearance(Context context, int resId) {}

  public Locale getTextLocale() {
    return null;
  }

  public LocaleList getTextLocales() {
    return null;
  }

  public void setTextLocale(Locale locale) {}

  public void setTextLocales(LocaleList locales) {}

  public float getTextSize() {
    return 0;
  }

  public float getScaledTextSize() {
    return 0;
  }

  public int getTypefaceStyle() {
    return 0;
  }

  public void setTextSize(float size) {}

  public void setTextSize(int unit, float size) {}

  public int getTextSizeUnit() {
    return 0;
  }

  public float getTextScaleX() {
    return 0;
  }

  public void setTextScaleX(float size) {}

  public void setTypeface(Typeface tf) {}

  public Typeface getTypeface() {
    return null;
  }

  public void setElegantTextHeight(boolean elegant) {}

  public void setFallbackLineSpacing(boolean enabled) {}

  public boolean isFallbackLineSpacing() {
    return false;
  }

  public boolean isElegantTextHeight() {
    return false;
  }

  public float getLetterSpacing() {
    return 0;
  }

  public void setLetterSpacing(float letterSpacing) {}

  public String getFontFeatureSettings() {
    return null;
  }

  public String getFontVariationSettings() {
    return null;
  }

  public void setBreakStrategy(int breakStrategy) {}

  public int getBreakStrategy() {
    return 0;
  }

  public void setHyphenationFrequency(int hyphenationFrequency) {}

  public int getHyphenationFrequency() {
    return 0;
  }

  public void setJustificationMode(int justificationMode) {}

  public int getJustificationMode() {
    return 0;
  }

  public void setFontFeatureSettings(String fontFeatureSettings) {}

  public boolean setFontVariationSettings(String fontVariationSettings) {
    return false;
  }

  public void setTextColor(int color) {}

  public void setTextColor(ColorStateList colors) {}

  public final ColorStateList getTextColors() {
    return null;
  }

  public final int getCurrentTextColor() {
    return 0;
  }

  public void setHighlightColor(int color) {}

  public int getHighlightColor() {
    return 0;
  }

  public final void setShowSoftInputOnFocus(boolean show) {}

  public final boolean getShowSoftInputOnFocus() {
    return false;
  }

  public void setShadowLayer(float radius, float dx, float dy, int color) {}

  public float getShadowRadius() {
    return 0;
  }

  public float getShadowDx() {
    return 0;
  }

  public float getShadowDy() {
    return 0;
  }

  public int getShadowColor() {
    return 0;
  }

  public final void setAutoLinkMask(int mask) {}

  public final void setLinksClickable(boolean whether) {}

  public final boolean getLinksClickable() {
    return false;
  }

  public final void setHintTextColor(int color) {}

  public final void setHintTextColor(ColorStateList colors) {}

  public final ColorStateList getHintTextColors() {
    return null;
  }

  public final int getCurrentHintTextColor() {
    return 0;
  }

  public final void setLinkTextColor(int color) {}

  public final void setLinkTextColor(ColorStateList colors) {}

  public final ColorStateList getLinkTextColors() {
    return null;
  }

  public void setGravity(int gravity) {}

  public int getGravity() {
    return 0;
  }

  public int getPaintFlags() {
    return 0;
  }

  public void setPaintFlags(int flags) {}

  public void setHorizontallyScrolling(boolean whether) {}

  public final boolean isHorizontallyScrollable() {
    return false;
  }

  public boolean getHorizontallyScrolling() {
    return false;
  }

  public void setMinLines(int minLines) {}

  public int getMinLines() {
    return 0;
  }

  public void setMinHeight(int minPixels) {}

  public int getMinHeight() {
    return 0;
  }

  public void setMaxLines(int maxLines) {}

  public int getMaxLines() {
    return 0;
  }

  public void setMaxHeight(int maxPixels) {}

  public int getMaxHeight() {
    return 0;
  }

  public void setLines(int lines) {}

  public void setHeight(int pixels) {}

  public void setMinEms(int minEms) {}

  public int getMinEms() {
    return 0;
  }

  public void setMinWidth(int minPixels) {}

  public int getMinWidth() {
    return 0;
  }

  public void setMaxEms(int maxEms) {}

  public int getMaxEms() {
    return 0;
  }

  public void setMaxWidth(int maxPixels) {}

  public int getMaxWidth() {
    return 0;
  }

  public void setEms(int ems) {}

  public void setWidth(int pixels) {}

  public void setLineSpacing(float add, float mult) {}

  public float getLineSpacingMultiplier() {
    return 0;
  }

  public float getLineSpacingExtra() {
    return 0;
  }

  public void setLineHeight(int lineHeight) {}

  public final void append(CharSequence text) {}

  public void append(CharSequence text, int start, int end) {}


  public void setFreezesText(boolean freezesText) {}

  public boolean getFreezesText() {
    return false;
  }

  public final void setText(CharSequence text) {}

  public final void setTextKeepState(CharSequence text) {}

  public void setText(CharSequence text, BufferType type) {}

  public final void setText(char[] text, int start, int len) {}

  public final void setTextKeepState(CharSequence text, BufferType type) {}

  public final void setText(int resid) {}

  public final void setText(int resid, BufferType type) {}

  public final void setHint(CharSequence hint) {}

  public final void setHint(int resid) {}

  public CharSequence getHint() {
    return null;
  }

  public boolean isSingleLine() {
    return false;
  }

  public void setInputType(int type) {}

  public boolean isAnyPasswordInputType() {
    return false;
  }

  public void setRawInputType(int type) {}

  public int getInputType() {
    return 0;
  }

  public void setImeOptions(int imeOptions) {}

  public int getImeOptions() {
    return 0;
  }

  public void setImeActionLabel(CharSequence label, int actionId) {}

  public CharSequence getImeActionLabel() {
    return null;
  }

  public int getImeActionId() {
    return 0;
  }

  public void onEditorAction(int actionCode) {}

  public void setPrivateImeOptions(String type) {}

  public String getPrivateImeOptions() {
    return null;
  }

  public Bundle getInputExtras(boolean create) {
    return null;
  }

  public void setImeHintLocales(LocaleList hintLocales) {}

  public LocaleList getImeHintLocales() {
    return null;
  }

  public CharSequence getError() {
    return null;
  }

  public void setError(CharSequence error) {}

  public void setError(CharSequence error, Drawable icon) {}

  public boolean isTextSelectable() {
    return false;
  }

  public void setTextIsSelectable(boolean selectable) {}

  public int getHorizontalOffsetForDrawables() {
    return 0;
  }

  public int getLineCount() {
    return 0;
  }

  public int getLineBounds(int line, Rect bounds) {
    return 0;
  }

  public int getBaseline() {
    return 0;
  }

  public void resetErrorChangedFlag() {}

  public void hideErrorIfUnchanged() {}

  public boolean onCheckIsTextEditor() {
    return false;
  }

  public void beginBatchEdit() {}

  public void endBatchEdit() {}

  public void onBeginBatchEdit() {}

  public void onEndBatchEdit() {}

  public boolean onPrivateIMECommand(String action, Bundle data) {
    return false;
  }

  public void nullLayouts() {}

  public boolean useDynamicLayout() {
    return false;
  }

  public void setIncludeFontPadding(boolean includepad) {}

  public boolean getIncludeFontPadding() {
    return false;
  }

  public boolean bringPointIntoView(int offset) {
    return false;
  }

  public boolean moveCursorToVisibleOffset() {
    return false;
  }

  public void computeScroll() {}

  public void debug(int depth) {}

  public int getSelectionStart() {
    return 0;
  }

  public int getSelectionEnd() {
    return 0;
  }

  public boolean hasSelection() {
    return false;
  }

  public void setSingleLine() {}

  public void setAllCaps(boolean allCaps) {}

  public boolean isAllCaps() {
    return false;
  }

  public void setSingleLine(boolean singleLine) {}

  public void setMarqueeRepeatLimit(int marqueeLimit) {}

  public int getMarqueeRepeatLimit() {
    return 0;
  }

  public void setSelectAllOnFocus(boolean selectAllOnFocus) {}

  public void setCursorVisible(boolean visible) {}

  public boolean isCursorVisible() {
    return false;
  }

  public void onWindowFocusChanged(boolean hasWindowFocus) {}

  public void clearComposingText() {}

  public void setSelected(boolean selected) {}

  public boolean showContextMenu() {
    return false;
  }

  public boolean showContextMenu(float x, float y) {
    return false;
  }

  public boolean didTouchFocusSelect() {
    return false;
  }

  public void cancelLongPress() {}

  public void findViewsWithText(ArrayList<View> outViews, CharSequence searched, int flags) {}

  public enum BufferType {
  }

  public static ColorStateList getTextColors(Context context, TypedArray attrs) {
    return null;
  }

  public static int getTextColor(Context context, TypedArray attrs, int def) {
    return 0;
  }

  public final void setTextOperationUser(UserHandle user) {}

  public Locale getTextServicesLocale() {
    return null;
  }

  public boolean isInExtractedMode() {
    return false;
  }

  public Locale getSpellCheckerLocale() {
    return null;
  }

  public CharSequence getAccessibilityClassName() {
    return null;
  }

  public boolean isPositionVisible(final float positionX, final float positionY) {
    return false;
  }

  public boolean performAccessibilityActionInternal(int action, Bundle arguments) {
    return false;
  }

  public void sendAccessibilityEventInternal(int eventType) {}

  public boolean isInputMethodTarget() {
    return false;
  }

  public boolean onTextContextMenuItem(int id) {
    return false;
  }

  public boolean performLongClick() {
    return false;
  }

  public boolean isSuggestionsEnabled() {
    return false;
  }

  public void hideFloatingToolbar(int durationMs) {}

  public int getOffsetForPosition(float x, float y) {
    return 0;
  }

  public void onRtlPropertiesChanged(int layoutDirection) {}

  public void onResolveDrawables(int layoutDirection) {}

  public CharSequence getIterableTextForAccessibility() {
    return null;
  }

  public int getAccessibilitySelectionStart() {
    return 0;
  }

  public boolean isAccessibilitySelectionExtendable() {
    return false;
  }

  public int getAccessibilitySelectionEnd() {
    return 0;
  }

  public void setAccessibilitySelection(int start, int end) {}

}
