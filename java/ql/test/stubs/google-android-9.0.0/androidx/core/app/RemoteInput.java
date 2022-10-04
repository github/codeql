// Generated automatically from androidx.core.app.RemoteInput for testing purposes

package androidx.core.app;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import java.util.Map;
import java.util.Set;

public class RemoteInput {
    protected RemoteInput() {}

    public Bundle getExtras() {
        return null;
    }

    public CharSequence getLabel() {
        return null;
    }

    public CharSequence[] getChoices() {
        return null;
    }

    public Set<String> getAllowedDataTypes() {
        return null;
    }

    public String getResultKey() {
        return null;
    }

    public boolean getAllowFreeFormInput() {
        return false;
    }

    public boolean isDataOnly() {
        return false;
    }

    public int getEditChoicesBeforeSending() {
        return 0;
    }

    public static Bundle getResultsFromIntent(Intent p0) {
        return null;
    }

    public static Map<String, Uri> getDataResultsFromIntent(Intent p0, String p1) {
        return null;
    }

    public static String EXTRA_RESULTS_DATA = null;
    public static String RESULTS_CLIP_LABEL = null;
    public static int EDIT_CHOICES_BEFORE_SENDING_AUTO = 0;
    public static int EDIT_CHOICES_BEFORE_SENDING_DISABLED = 0;
    public static int EDIT_CHOICES_BEFORE_SENDING_ENABLED = 0;
    public static int SOURCE_CHOICE = 0;
    public static int SOURCE_FREE_FORM_INPUT = 0;

    public static int getResultsSource(Intent p0) {
        return 0;
    }

    public static void addDataResultToIntent(RemoteInput p0, Intent p1, Map<String, Uri> p2) {}

    public static void addResultsToIntent(RemoteInput[] p0, Intent p1, Bundle p2) {}

    public static void setResultsSource(Intent p0, int p1) {}
}
