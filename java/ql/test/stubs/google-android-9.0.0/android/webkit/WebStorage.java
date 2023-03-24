// Generated automatically from android.webkit.WebStorage for testing purposes

package android.webkit;

import android.webkit.ValueCallback;
import java.util.Map;

public class WebStorage
{
    public static WebStorage getInstance(){ return null; }
    public void deleteAllData(){}
    public void deleteOrigin(String p0){}
    public void getOrigins(ValueCallback<Map> p0){}
    public void getQuotaForOrigin(String p0, ValueCallback<Long> p1){}
    public void getUsageForOrigin(String p0, ValueCallback<Long> p1){}
    public void setQuotaForOrigin(String p0, long p1){}
    static public interface QuotaUpdater
    {
        void updateQuota(long p0);
    }
}
