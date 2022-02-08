// Generated automatically from android.media.session.MediaSessionManager for testing purposes

package android.media.session;

import android.content.ComponentName;
import android.media.Session2Token;
import android.media.session.MediaController;
import android.os.Handler;
import java.util.List;

public class MediaSessionManager
{
    public List<MediaController> getActiveSessions(ComponentName p0){ return null; }
    public List<Session2Token> getSession2Tokens(){ return null; }
    public boolean isTrustedForMediaControl(MediaSessionManager.RemoteUserInfo p0){ return false; }
    public void addOnActiveSessionsChangedListener(MediaSessionManager.OnActiveSessionsChangedListener p0, ComponentName p1){}
    public void addOnActiveSessionsChangedListener(MediaSessionManager.OnActiveSessionsChangedListener p0, ComponentName p1, Handler p2){}
    public void addOnSession2TokensChangedListener(MediaSessionManager.OnSession2TokensChangedListener p0){}
    public void addOnSession2TokensChangedListener(MediaSessionManager.OnSession2TokensChangedListener p0, Handler p1){}
    public void notifySession2Created(Session2Token p0){}
    public void removeOnActiveSessionsChangedListener(MediaSessionManager.OnActiveSessionsChangedListener p0){}
    public void removeOnSession2TokensChangedListener(MediaSessionManager.OnSession2TokensChangedListener p0){}
    static public class RemoteUserInfo
    {
        protected RemoteUserInfo() {}
        public RemoteUserInfo(String p0, int p1, int p2){}
        public String getPackageName(){ return null; }
        public boolean equals(Object p0){ return false; }
        public int getPid(){ return 0; }
        public int getUid(){ return 0; }
        public int hashCode(){ return 0; }
    }
    static public interface OnActiveSessionsChangedListener
    {
        void onActiveSessionsChanged(List<MediaController> p0);
    }
    static public interface OnSession2TokensChangedListener
    {
        void onSession2TokensChanged(List<Session2Token> p0);
    }
}
