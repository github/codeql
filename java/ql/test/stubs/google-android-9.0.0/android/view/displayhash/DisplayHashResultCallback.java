// Generated automatically from android.view.displayhash.DisplayHashResultCallback for testing purposes

package android.view.displayhash;

import android.view.displayhash.DisplayHash;

public interface DisplayHashResultCallback
{
    static int DISPLAY_HASH_ERROR_INVALID_BOUNDS = 0;
    static int DISPLAY_HASH_ERROR_INVALID_HASH_ALGORITHM = 0;
    static int DISPLAY_HASH_ERROR_MISSING_WINDOW = 0;
    static int DISPLAY_HASH_ERROR_NOT_VISIBLE_ON_SCREEN = 0;
    static int DISPLAY_HASH_ERROR_TOO_MANY_REQUESTS = 0;
    static int DISPLAY_HASH_ERROR_UNKNOWN = 0;
    void onDisplayHashError(int p0);
    void onDisplayHashResult(DisplayHash p0);
}
