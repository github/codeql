// Generated automatically from android.media.session.MediaSession for testing purposes

package android.media.session;

import android.app.PendingIntent;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.media.AudioAttributes;
import android.media.MediaDescription;
import android.media.MediaMetadata;
import android.media.Rating;
import android.media.VolumeProvider;
import android.media.session.MediaController;
import android.media.session.MediaSessionManager;
import android.media.session.PlaybackState;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Parcel;
import android.os.Parcelable;
import android.os.ResultReceiver;
import java.util.List;

public class MediaSession
{
    protected MediaSession() {}
    abstract static public class Callback
    {
        public Callback(){}
        public boolean onMediaButtonEvent(Intent p0){ return false; }
        public void onCommand(String p0, Bundle p1, ResultReceiver p2){}
        public void onCustomAction(String p0, Bundle p1){}
        public void onFastForward(){}
        public void onPause(){}
        public void onPlay(){}
        public void onPlayFromMediaId(String p0, Bundle p1){}
        public void onPlayFromSearch(String p0, Bundle p1){}
        public void onPlayFromUri(Uri p0, Bundle p1){}
        public void onPrepare(){}
        public void onPrepareFromMediaId(String p0, Bundle p1){}
        public void onPrepareFromSearch(String p0, Bundle p1){}
        public void onPrepareFromUri(Uri p0, Bundle p1){}
        public void onRewind(){}
        public void onSeekTo(long p0){}
        public void onSetPlaybackSpeed(float p0){}
        public void onSetRating(Rating p0){}
        public void onSkipToNext(){}
        public void onSkipToPrevious(){}
        public void onSkipToQueueItem(long p0){}
        public void onStop(){}
    }
    public MediaController getController(){ return null; }
    public MediaSession(Context p0, String p1){}
    public MediaSession(Context p0, String p1, Bundle p2){}
    public MediaSession.Token getSessionToken(){ return null; }
    public MediaSessionManager.RemoteUserInfo getCurrentControllerInfo(){ return null; }
    public boolean isActive(){ return false; }
    public static int FLAG_HANDLES_MEDIA_BUTTONS = 0;
    public static int FLAG_HANDLES_TRANSPORT_CONTROLS = 0;
    public void release(){}
    public void sendSessionEvent(String p0, Bundle p1){}
    public void setActive(boolean p0){}
    public void setCallback(MediaSession.Callback p0){}
    public void setCallback(MediaSession.Callback p0, Handler p1){}
    public void setExtras(Bundle p0){}
    public void setFlags(int p0){}
    public void setMediaButtonBroadcastReceiver(ComponentName p0){}
    public void setMediaButtonReceiver(PendingIntent p0){}
    public void setMetadata(MediaMetadata p0){}
    public void setPlaybackState(PlaybackState p0){}
    public void setPlaybackToLocal(AudioAttributes p0){}
    public void setPlaybackToRemote(VolumeProvider p0){}
    public void setQueue(List<MediaSession.QueueItem> p0){}
    public void setQueueTitle(CharSequence p0){}
    public void setRatingType(int p0){}
    public void setSessionActivity(PendingIntent p0){}
    static public class QueueItem implements Parcelable
    {
        protected QueueItem() {}
        public MediaDescription getDescription(){ return null; }
        public QueueItem(MediaDescription p0, long p1){}
        public String toString(){ return null; }
        public boolean equals(Object p0){ return false; }
        public int describeContents(){ return 0; }
        public long getQueueId(){ return 0; }
        public static Parcelable.Creator<MediaSession.QueueItem> CREATOR = null;
        public static int UNKNOWN_ID = 0;
        public void writeToParcel(Parcel p0, int p1){}
    }
    static public class Token implements Parcelable
    {
        public boolean equals(Object p0){ return false; }
        public int describeContents(){ return 0; }
        public int hashCode(){ return 0; }
        public static Parcelable.Creator<MediaSession.Token> CREATOR = null;
        public void writeToParcel(Parcel p0, int p1){}
    }
}
