// Generated automatically from android.view.accessibility.AccessibilityNodeInfo for testing purposes

package android.view.accessibility;

import android.graphics.Rect;
import android.graphics.Region;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;
import android.util.Size;
import android.view.View;
import android.view.accessibility.AccessibilityWindowInfo;
import java.util.List;
import java.util.Map;

public class AccessibilityNodeInfo implements Parcelable
{
    public AccessibilityNodeInfo findFocus(int p0){ return null; }
    public AccessibilityNodeInfo focusSearch(int p0){ return null; }
    public AccessibilityNodeInfo getChild(int p0){ return null; }
    public AccessibilityNodeInfo getLabelFor(){ return null; }
    public AccessibilityNodeInfo getLabeledBy(){ return null; }
    public AccessibilityNodeInfo getParent(){ return null; }
    public AccessibilityNodeInfo getTraversalAfter(){ return null; }
    public AccessibilityNodeInfo getTraversalBefore(){ return null; }
    public AccessibilityNodeInfo(){}
    public AccessibilityNodeInfo(AccessibilityNodeInfo p0){}
    public AccessibilityNodeInfo(View p0){}
    public AccessibilityNodeInfo(View p0, int p1){}
    public AccessibilityNodeInfo.CollectionInfo getCollectionInfo(){ return null; }
    public AccessibilityNodeInfo.CollectionItemInfo getCollectionItemInfo(){ return null; }
    public AccessibilityNodeInfo.ExtraRenderingInfo getExtraRenderingInfo(){ return null; }
    public AccessibilityNodeInfo.RangeInfo getRangeInfo(){ return null; }
    public AccessibilityNodeInfo.TouchDelegateInfo getTouchDelegateInfo(){ return null; }
    public AccessibilityWindowInfo getWindow(){ return null; }
    public Bundle getExtras(){ return null; }
    public CharSequence getClassName(){ return null; }
    public CharSequence getContentDescription(){ return null; }
    public CharSequence getError(){ return null; }
    public CharSequence getHintText(){ return null; }
    public CharSequence getPackageName(){ return null; }
    public CharSequence getPaneTitle(){ return null; }
    public CharSequence getStateDescription(){ return null; }
    public CharSequence getText(){ return null; }
    public CharSequence getTooltipText(){ return null; }
    public List<AccessibilityNodeInfo.AccessibilityAction> getActionList(){ return null; }
    public List<AccessibilityNodeInfo> findAccessibilityNodeInfosByText(String p0){ return null; }
    public List<AccessibilityNodeInfo> findAccessibilityNodeInfosByViewId(String p0){ return null; }
    public List<String> getAvailableExtraData(){ return null; }
    public String getViewIdResourceName(){ return null; }
    public String toString(){ return null; }
    public boolean canOpenPopup(){ return false; }
    public boolean equals(Object p0){ return false; }
    public boolean isAccessibilityFocused(){ return false; }
    public boolean isCheckable(){ return false; }
    public boolean isChecked(){ return false; }
    public boolean isClickable(){ return false; }
    public boolean isContentInvalid(){ return false; }
    public boolean isContextClickable(){ return false; }
    public boolean isDismissable(){ return false; }
    public boolean isEditable(){ return false; }
    public boolean isEnabled(){ return false; }
    public boolean isFocusable(){ return false; }
    public boolean isFocused(){ return false; }
    public boolean isHeading(){ return false; }
    public boolean isImportantForAccessibility(){ return false; }
    public boolean isLongClickable(){ return false; }
    public boolean isMultiLine(){ return false; }
    public boolean isPassword(){ return false; }
    public boolean isScreenReaderFocusable(){ return false; }
    public boolean isScrollable(){ return false; }
    public boolean isSelected(){ return false; }
    public boolean isShowingHintText(){ return false; }
    public boolean isTextEntryKey(){ return false; }
    public boolean isVisibleToUser(){ return false; }
    public boolean performAction(int p0){ return false; }
    public boolean performAction(int p0, Bundle p1){ return false; }
    public boolean refresh(){ return false; }
    public boolean refreshWithExtraData(String p0, Bundle p1){ return false; }
    public boolean removeAction(AccessibilityNodeInfo.AccessibilityAction p0){ return false; }
    public boolean removeChild(View p0){ return false; }
    public boolean removeChild(View p0, int p1){ return false; }
    public int describeContents(){ return 0; }
    public int getActions(){ return 0; }
    public int getChildCount(){ return 0; }
    public int getDrawingOrder(){ return 0; }
    public int getInputType(){ return 0; }
    public int getLiveRegion(){ return 0; }
    public int getMaxTextLength(){ return 0; }
    public int getMovementGranularities(){ return 0; }
    public int getTextSelectionEnd(){ return 0; }
    public int getTextSelectionStart(){ return 0; }
    public int getWindowId(){ return 0; }
    public int hashCode(){ return 0; }
    public static AccessibilityNodeInfo obtain(){ return null; }
    public static AccessibilityNodeInfo obtain(AccessibilityNodeInfo p0){ return null; }
    public static AccessibilityNodeInfo obtain(View p0){ return null; }
    public static AccessibilityNodeInfo obtain(View p0, int p1){ return null; }
    public static Parcelable.Creator<AccessibilityNodeInfo> CREATOR = null;
    public static String ACTION_ARGUMENT_COLUMN_INT = null;
    public static String ACTION_ARGUMENT_EXTEND_SELECTION_BOOLEAN = null;
    public static String ACTION_ARGUMENT_HTML_ELEMENT_STRING = null;
    public static String ACTION_ARGUMENT_MOVEMENT_GRANULARITY_INT = null;
    public static String ACTION_ARGUMENT_MOVE_WINDOW_X = null;
    public static String ACTION_ARGUMENT_MOVE_WINDOW_Y = null;
    public static String ACTION_ARGUMENT_PRESS_AND_HOLD_DURATION_MILLIS_INT = null;
    public static String ACTION_ARGUMENT_PROGRESS_VALUE = null;
    public static String ACTION_ARGUMENT_ROW_INT = null;
    public static String ACTION_ARGUMENT_SELECTION_END_INT = null;
    public static String ACTION_ARGUMENT_SELECTION_START_INT = null;
    public static String ACTION_ARGUMENT_SET_TEXT_CHARSEQUENCE = null;
    public static String EXTRA_DATA_RENDERING_INFO_KEY = null;
    public static String EXTRA_DATA_TEXT_CHARACTER_LOCATION_ARG_LENGTH = null;
    public static String EXTRA_DATA_TEXT_CHARACTER_LOCATION_ARG_START_INDEX = null;
    public static String EXTRA_DATA_TEXT_CHARACTER_LOCATION_KEY = null;
    public static int ACTION_ACCESSIBILITY_FOCUS = 0;
    public static int ACTION_CLEAR_ACCESSIBILITY_FOCUS = 0;
    public static int ACTION_CLEAR_FOCUS = 0;
    public static int ACTION_CLEAR_SELECTION = 0;
    public static int ACTION_CLICK = 0;
    public static int ACTION_COLLAPSE = 0;
    public static int ACTION_COPY = 0;
    public static int ACTION_CUT = 0;
    public static int ACTION_DISMISS = 0;
    public static int ACTION_EXPAND = 0;
    public static int ACTION_FOCUS = 0;
    public static int ACTION_LONG_CLICK = 0;
    public static int ACTION_NEXT_AT_MOVEMENT_GRANULARITY = 0;
    public static int ACTION_NEXT_HTML_ELEMENT = 0;
    public static int ACTION_PASTE = 0;
    public static int ACTION_PREVIOUS_AT_MOVEMENT_GRANULARITY = 0;
    public static int ACTION_PREVIOUS_HTML_ELEMENT = 0;
    public static int ACTION_SCROLL_BACKWARD = 0;
    public static int ACTION_SCROLL_FORWARD = 0;
    public static int ACTION_SELECT = 0;
    public static int ACTION_SET_SELECTION = 0;
    public static int ACTION_SET_TEXT = 0;
    public static int EXTRA_DATA_TEXT_CHARACTER_LOCATION_ARG_MAX_LENGTH = 0;
    public static int FOCUS_ACCESSIBILITY = 0;
    public static int FOCUS_INPUT = 0;
    public static int MOVEMENT_GRANULARITY_CHARACTER = 0;
    public static int MOVEMENT_GRANULARITY_LINE = 0;
    public static int MOVEMENT_GRANULARITY_PAGE = 0;
    public static int MOVEMENT_GRANULARITY_PARAGRAPH = 0;
    public static int MOVEMENT_GRANULARITY_WORD = 0;
    public void addAction(AccessibilityNodeInfo.AccessibilityAction p0){}
    public void addAction(int p0){}
    public void addChild(View p0){}
    public void addChild(View p0, int p1){}
    public void getBoundsInParent(Rect p0){}
    public void getBoundsInScreen(Rect p0){}
    public void recycle(){}
    public void removeAction(int p0){}
    public void setAccessibilityFocused(boolean p0){}
    public void setAvailableExtraData(List<String> p0){}
    public void setBoundsInParent(Rect p0){}
    public void setBoundsInScreen(Rect p0){}
    public void setCanOpenPopup(boolean p0){}
    public void setCheckable(boolean p0){}
    public void setChecked(boolean p0){}
    public void setClassName(CharSequence p0){}
    public void setClickable(boolean p0){}
    public void setCollectionInfo(AccessibilityNodeInfo.CollectionInfo p0){}
    public void setCollectionItemInfo(AccessibilityNodeInfo.CollectionItemInfo p0){}
    public void setContentDescription(CharSequence p0){}
    public void setContentInvalid(boolean p0){}
    public void setContextClickable(boolean p0){}
    public void setDismissable(boolean p0){}
    public void setDrawingOrder(int p0){}
    public void setEditable(boolean p0){}
    public void setEnabled(boolean p0){}
    public void setError(CharSequence p0){}
    public void setFocusable(boolean p0){}
    public void setFocused(boolean p0){}
    public void setHeading(boolean p0){}
    public void setHintText(CharSequence p0){}
    public void setImportantForAccessibility(boolean p0){}
    public void setInputType(int p0){}
    public void setLabelFor(View p0){}
    public void setLabelFor(View p0, int p1){}
    public void setLabeledBy(View p0){}
    public void setLabeledBy(View p0, int p1){}
    public void setLiveRegion(int p0){}
    public void setLongClickable(boolean p0){}
    public void setMaxTextLength(int p0){}
    public void setMovementGranularities(int p0){}
    public void setMultiLine(boolean p0){}
    public void setPackageName(CharSequence p0){}
    public void setPaneTitle(CharSequence p0){}
    public void setParent(View p0){}
    public void setParent(View p0, int p1){}
    public void setPassword(boolean p0){}
    public void setRangeInfo(AccessibilityNodeInfo.RangeInfo p0){}
    public void setScreenReaderFocusable(boolean p0){}
    public void setScrollable(boolean p0){}
    public void setSelected(boolean p0){}
    public void setShowingHintText(boolean p0){}
    public void setSource(View p0){}
    public void setSource(View p0, int p1){}
    public void setStateDescription(CharSequence p0){}
    public void setText(CharSequence p0){}
    public void setTextEntryKey(boolean p0){}
    public void setTextSelection(int p0, int p1){}
    public void setTooltipText(CharSequence p0){}
    public void setTouchDelegateInfo(AccessibilityNodeInfo.TouchDelegateInfo p0){}
    public void setTraversalAfter(View p0){}
    public void setTraversalAfter(View p0, int p1){}
    public void setTraversalBefore(View p0){}
    public void setTraversalBefore(View p0, int p1){}
    public void setViewIdResourceName(String p0){}
    public void setVisibleToUser(boolean p0){}
    public void writeToParcel(Parcel p0, int p1){}
    static public class AccessibilityAction implements Parcelable
    {
        protected AccessibilityAction() {}
        public AccessibilityAction(int p0, CharSequence p1){}
        public CharSequence getLabel(){ return null; }
        public String toString(){ return null; }
        public boolean equals(Object p0){ return false; }
        public int describeContents(){ return 0; }
        public int getId(){ return 0; }
        public int hashCode(){ return 0; }
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_ACCESSIBILITY_FOCUS = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_CLEAR_ACCESSIBILITY_FOCUS = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_CLEAR_FOCUS = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_CLEAR_SELECTION = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_CLICK = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_COLLAPSE = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_CONTEXT_CLICK = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_COPY = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_CUT = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_DISMISS = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_EXPAND = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_FOCUS = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_HIDE_TOOLTIP = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_IME_ENTER = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_LONG_CLICK = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_MOVE_WINDOW = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_NEXT_AT_MOVEMENT_GRANULARITY = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_NEXT_HTML_ELEMENT = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_PAGE_DOWN = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_PAGE_LEFT = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_PAGE_RIGHT = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_PAGE_UP = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_PASTE = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_PRESS_AND_HOLD = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_PREVIOUS_AT_MOVEMENT_GRANULARITY = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_PREVIOUS_HTML_ELEMENT = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_SCROLL_BACKWARD = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_SCROLL_DOWN = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_SCROLL_FORWARD = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_SCROLL_LEFT = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_SCROLL_RIGHT = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_SCROLL_TO_POSITION = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_SCROLL_UP = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_SELECT = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_SET_PROGRESS = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_SET_SELECTION = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_SET_TEXT = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_SHOW_ON_SCREEN = null;
        public static AccessibilityNodeInfo.AccessibilityAction ACTION_SHOW_TOOLTIP = null;
        public static Parcelable.Creator<AccessibilityNodeInfo.AccessibilityAction> CREATOR = null;
        public void writeToParcel(Parcel p0, int p1){}
    }
    static public class CollectionInfo
    {
        protected CollectionInfo() {}
        public CollectionInfo(int p0, int p1, boolean p2){}
        public CollectionInfo(int p0, int p1, boolean p2, int p3){}
        public boolean isHierarchical(){ return false; }
        public int getColumnCount(){ return 0; }
        public int getRowCount(){ return 0; }
        public int getSelectionMode(){ return 0; }
        public static AccessibilityNodeInfo.CollectionInfo obtain(int p0, int p1, boolean p2){ return null; }
        public static AccessibilityNodeInfo.CollectionInfo obtain(int p0, int p1, boolean p2, int p3){ return null; }
        public static int SELECTION_MODE_MULTIPLE = 0;
        public static int SELECTION_MODE_NONE = 0;
        public static int SELECTION_MODE_SINGLE = 0;
    }
    static public class CollectionItemInfo
    {
        protected CollectionItemInfo() {}
        public CollectionItemInfo(int p0, int p1, int p2, int p3, boolean p4){}
        public CollectionItemInfo(int p0, int p1, int p2, int p3, boolean p4, boolean p5){}
        public boolean isHeading(){ return false; }
        public boolean isSelected(){ return false; }
        public int getColumnIndex(){ return 0; }
        public int getColumnSpan(){ return 0; }
        public int getRowIndex(){ return 0; }
        public int getRowSpan(){ return 0; }
        public static AccessibilityNodeInfo.CollectionItemInfo obtain(int p0, int p1, int p2, int p3, boolean p4){ return null; }
        public static AccessibilityNodeInfo.CollectionItemInfo obtain(int p0, int p1, int p2, int p3, boolean p4, boolean p5){ return null; }
    }
    static public class ExtraRenderingInfo
    {
        protected ExtraRenderingInfo() {}
        public Size getLayoutSize(){ return null; }
        public float getTextSizeInPx(){ return 0; }
        public int getTextSizeUnit(){ return 0; }
    }
    static public class RangeInfo
    {
        protected RangeInfo() {}
        public RangeInfo(int p0, float p1, float p2, float p3){}
        public float getCurrent(){ return 0; }
        public float getMax(){ return 0; }
        public float getMin(){ return 0; }
        public int getType(){ return 0; }
        public static AccessibilityNodeInfo.RangeInfo obtain(int p0, float p1, float p2, float p3){ return null; }
        public static int RANGE_TYPE_FLOAT = 0;
        public static int RANGE_TYPE_INT = 0;
        public static int RANGE_TYPE_PERCENT = 0;
    }
    static public class TouchDelegateInfo implements Parcelable
    {
        protected TouchDelegateInfo() {}
        public AccessibilityNodeInfo getTargetForRegion(Region p0){ return null; }
        public Region getRegionAt(int p0){ return null; }
        public TouchDelegateInfo(Map<Region, View> p0){}
        public int describeContents(){ return 0; }
        public int getRegionCount(){ return 0; }
        public static Parcelable.Creator<AccessibilityNodeInfo.TouchDelegateInfo> CREATOR = null;
        public void writeToParcel(Parcel p0, int p1){}
    }
}
