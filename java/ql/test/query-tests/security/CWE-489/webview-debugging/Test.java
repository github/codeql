import android.webkit.WebView;

class Test {
    boolean DEBUG_BUILD;

    void test1() {
        WebView.setWebContentsDebuggingEnabled(true); // $hasValueFlow
    }

    void test2(){
        if (DEBUG_BUILD) {
            WebView.setWebContentsDebuggingEnabled(true); 
        }
    }

    void test3(boolean enabled){
        WebView.setWebContentsDebuggingEnabled(enabled); // $hasValueFlow
    }

    void test4(){
        test3(true);
    }
}