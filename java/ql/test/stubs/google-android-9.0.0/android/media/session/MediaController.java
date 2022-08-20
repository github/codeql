// Generated automatically from android.media.session.MediaController for testing purposes

package android.media.session;

import android.app.PendingIntent;
import android.content.Context;
import android.media.AudioAttributes;
import android.media.MediaMetadata;
import android.media.Rating;
import android.media.session.MediaSession;
import android.media.session.PlaybackState;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Parcel;
import android.os.Parcelable;
import android.os.ResultReceiver;
import android.view.KeyEvent;
import java.util.List;

public class MediaController
{
    protected MediaController() {}
    abstract static public class Callback
    {
        public Callback(){}
        public void onAudioInfoChanged(MediaController.PlaybackInfo p0){}
        public void onExtrasChanged(Bundle p0){}
        public void onMetadataChanged(MediaMetadata p0){}
        public void onPlaybackStateChanged(PlaybackState p0){}
        public void onQueueChanged(List<MediaSession.QueueItem> p0){}
        public void onQueueTitleChanged(CharSequence p0){}
        public void onSessionDestroyed(){}
        public void onSessionEvent(String p0, Bundle p1){}
    }
    public Bundle getExtras(){ return null; }
    public Bundle getSessionInfo(){ return null; }
    public CharSequence getQueueTitle(){ return null; }
    public List<MediaSession.QueueItem> getQueue(){ return null; }
    public MediaController(Context p0, MediaSession.Token p1){}
    public MediaController.PlaybackInfo getPlaybackInfo(){ return null; }
    public MediaController.TransportControls getTransportControls(){ return null; }
    public MediaMetadata getMetadata(){ return null; }
    public MediaSession.Token getSessionToken(){ return null; }
    public PendingIntent getSessionActivity(){ return null; }
    public PlaybackState getPlaybackState(){ return null; }
    public String getPackageName(){ return null; }
    public String getTag(){ return null; }
    public boolean dispatchMediaButtonEvent(KeyEvent p0){ return false; }
    public class TransportControls
    {
        protected TransportControls() {}
        public void fastForward(){}
        public void pause(){}
        public void play(){}
        public void playFromMediaId(String p0, Bundle p1){}
        public void playFromSearch(String p0, Bundle p1){}
        public void playFromUri(Uri p0, Bundle p1){}
        public void prepare(){}
        public void prepareFromMediaId(String p0, Bundle p1){}
        public void prepareFromSearch(String p0, Bundle p1){}
        public void prepareFromUri(Uri p0, Bundle p1){}
        public void rewind(){}
        public void seekTo(long p0){}
        public void sendCustomAction(PlaybackState.CustomAction p0, Bundle p1){}
        public void sendCustomAction(String p0, Bundle p1){}
        public void setPlaybackSpeed(float p0){}
        public void setRating(Rating p0){}
        public void skipToNext(){}
        public void skipToPrevious(){}
        public void skipToQueueItem(long p0){}
        public void stop(){}
    }
    public int getRatingType(){ return 0; }
    public long getFlags(){ return 0; }
    public void adjustVolume(int p0, int p1){}
    public void registerCallback(MediaController.Callback p0){}
    public void registerCallback(MediaController.Callback p0, Handler p1){}
    public void sendCommand(String p0, Bundle p1, ResultReceiver p2){}
    public void setVolumeTo(int p0, int p1){}
    public void unregisterCallback(MediaController.Callback p0){}
    static public class PlaybackInfo implements Parcelable
    {
        public AudioAttributes getAudioAttributes(){ return null; }
        public String getVolumeControlId(){ return null; }
        public String toString(){ return null; }
        public int describeContents(){ return 0; }
        public int getCurrentVolume(){ return 0; }
        public int getMaxVolume(){ return 0; }
        public int getPlaybackType(){ return 0; }
        public int getVolumeControl(){ return 0; }
        public static Parcelable.Creator<MediaController.PlaybackInfo> CREATOR = null;
        public static int PLAYBACK_TYPE_LOCAL = 0;
        public static int PLAYBACK_TYPE_REMOTE = 0;
        public void writeToParcel(Parcel p0, int p1){}
    }
}
