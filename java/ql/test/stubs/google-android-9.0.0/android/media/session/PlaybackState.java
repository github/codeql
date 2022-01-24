// Generated automatically from android.media.session.PlaybackState for testing purposes

package android.media.session;

import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;
import java.util.List;

public class PlaybackState implements Parcelable
{
    protected PlaybackState() {}
    public Bundle getExtras(){ return null; }
    public CharSequence getErrorMessage(){ return null; }
    public List<PlaybackState.CustomAction> getCustomActions(){ return null; }
    public String toString(){ return null; }
    public boolean isActive(){ return false; }
    public float getPlaybackSpeed(){ return 0; }
    public int describeContents(){ return 0; }
    public int getState(){ return 0; }
    public long getActions(){ return 0; }
    public long getActiveQueueItemId(){ return 0; }
    public long getBufferedPosition(){ return 0; }
    public long getLastPositionUpdateTime(){ return 0; }
    public long getPosition(){ return 0; }
    public static Parcelable.Creator<PlaybackState> CREATOR = null;
    public static int STATE_BUFFERING = 0;
    public static int STATE_CONNECTING = 0;
    public static int STATE_ERROR = 0;
    public static int STATE_FAST_FORWARDING = 0;
    public static int STATE_NONE = 0;
    public static int STATE_PAUSED = 0;
    public static int STATE_PLAYING = 0;
    public static int STATE_REWINDING = 0;
    public static int STATE_SKIPPING_TO_NEXT = 0;
    public static int STATE_SKIPPING_TO_PREVIOUS = 0;
    public static int STATE_SKIPPING_TO_QUEUE_ITEM = 0;
    public static int STATE_STOPPED = 0;
    public static long ACTION_FAST_FORWARD = 0;
    public static long ACTION_PAUSE = 0;
    public static long ACTION_PLAY = 0;
    public static long ACTION_PLAY_FROM_MEDIA_ID = 0;
    public static long ACTION_PLAY_FROM_SEARCH = 0;
    public static long ACTION_PLAY_FROM_URI = 0;
    public static long ACTION_PLAY_PAUSE = 0;
    public static long ACTION_PREPARE = 0;
    public static long ACTION_PREPARE_FROM_MEDIA_ID = 0;
    public static long ACTION_PREPARE_FROM_SEARCH = 0;
    public static long ACTION_PREPARE_FROM_URI = 0;
    public static long ACTION_REWIND = 0;
    public static long ACTION_SEEK_TO = 0;
    public static long ACTION_SET_PLAYBACK_SPEED = 0;
    public static long ACTION_SET_RATING = 0;
    public static long ACTION_SKIP_TO_NEXT = 0;
    public static long ACTION_SKIP_TO_PREVIOUS = 0;
    public static long ACTION_SKIP_TO_QUEUE_ITEM = 0;
    public static long ACTION_STOP = 0;
    public static long PLAYBACK_POSITION_UNKNOWN = 0;
    public void writeToParcel(Parcel p0, int p1){}
    static public class CustomAction implements Parcelable
    {
        protected CustomAction() {}
        public Bundle getExtras(){ return null; }
        public CharSequence getName(){ return null; }
        public String getAction(){ return null; }
        public String toString(){ return null; }
        public int describeContents(){ return 0; }
        public int getIcon(){ return 0; }
        public static Parcelable.Creator<PlaybackState.CustomAction> CREATOR = null;
        public void writeToParcel(Parcel p0, int p1){}
    }
}
