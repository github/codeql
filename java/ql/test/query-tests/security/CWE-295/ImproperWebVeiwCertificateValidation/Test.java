import android.webkit.WebViewClient;
import android.webkit.WebView;
import android.webkit.SslErrorHandler;
import android.net.http.SslError;
import android.net.http.SslCertificate;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.app.Activity;

class Test {
    class A extends WebViewClient {
        public void onReceivedSslError (WebView view, SslErrorHandler handler, SslError error) { // $hasResult
            handler.proceed(); 
        }
    }

    interface Validator {
        boolean isValid(SslCertificate cert);
    }

    class B extends WebViewClient {
        Validator v;

        public void onReceivedSslError (WebView view, SslErrorHandler handler, SslError error) {
            if (this.v.isValid(error.getCertificate())) {
                handler.proceed();
            }
            else {
                handler.cancel();
            }
        } 
    }

    class C extends WebViewClient {
        Activity activity;

        public void onReceivedSslError (WebView view, SslErrorHandler handler, SslError error) {
            new AlertDialog.Builder(activity).
                        setTitle("SSL error").
                        setMessage("SSL error. Connect anyway?").
                        setPositiveButton("Yes", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                handler.proceed();
                            }
                        }).setNegativeButton("No", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                handler.cancel();
                            }
                        }).show();
        }
    }
}