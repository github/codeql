// Generated automatically from android.view.inputmethod.InputConnection for testing purposes

package android.view.inputmethod;

import android.os.Bundle;
import android.os.Handler;
import android.view.KeyEvent;
import android.view.inputmethod.CompletionInfo;
import android.view.inputmethod.CorrectionInfo;
import android.view.inputmethod.ExtractedText;
import android.view.inputmethod.ExtractedTextRequest;
import android.view.inputmethod.InputContentInfo;
import android.view.inputmethod.SurroundingText;

public interface InputConnection
{
    CharSequence getSelectedText(int p0);
    CharSequence getTextAfterCursor(int p0, int p1);
    CharSequence getTextBeforeCursor(int p0, int p1);
    ExtractedText getExtractedText(ExtractedTextRequest p0, int p1);
    Handler getHandler();
    boolean beginBatchEdit();
    boolean clearMetaKeyStates(int p0);
    boolean commitCompletion(CompletionInfo p0);
    boolean commitContent(InputContentInfo p0, int p1, Bundle p2);
    boolean commitCorrection(CorrectionInfo p0);
    boolean commitText(CharSequence p0, int p1);
    boolean deleteSurroundingText(int p0, int p1);
    boolean deleteSurroundingTextInCodePoints(int p0, int p1);
    boolean endBatchEdit();
    boolean finishComposingText();
    boolean performContextMenuAction(int p0);
    boolean performEditorAction(int p0);
    boolean performPrivateCommand(String p0, Bundle p1);
    boolean reportFullscreenMode(boolean p0);
    boolean requestCursorUpdates(int p0);
    boolean sendKeyEvent(KeyEvent p0);
    boolean setComposingRegion(int p0, int p1);
    boolean setComposingText(CharSequence p0, int p1);
    boolean setSelection(int p0, int p1);
    default SurroundingText getSurroundingText(int p0, int p1, int p2){ return null; }
    default boolean performSpellCheck(){ return false; }
    default boolean setImeConsumesInput(boolean p0){ return false; }
    int getCursorCapsMode(int p0);
    static int CURSOR_UPDATE_IMMEDIATE = 0;
    static int CURSOR_UPDATE_MONITOR = 0;
    static int GET_EXTRACTED_TEXT_MONITOR = 0;
    static int GET_TEXT_WITH_STYLES = 0;
    static int INPUT_CONTENT_GRANT_READ_URI_PERMISSION = 0;
    void closeConnection();
}
