import android.webkit.WebView;

class Test {
    boolean DEBUG_BUILD;

    void test1() {
        WebView.setWebContentsDebuggingEnabled(true); // $ Alert
    }

    void test2(){
        if (DEBUG_BUILD) {
            WebView.setWebContentsDebuggingEnabled(true);
        }
    }

    void test3(boolean enabled){
        WebView.setWebContentsDebuggingEnabled(enabled); // $ Alert
    }

    void test4(){
        test3(true); // $ Source
    }
}
