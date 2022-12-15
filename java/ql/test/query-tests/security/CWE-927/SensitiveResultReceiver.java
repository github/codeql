import android.os.Bundle;
import android.os.ResultReceiver;

class SensitiveResultReceiver {
    <T> T source() { return null; }

    void test1(String password) {
        ResultReceiver rec = source();
        Bundle b = new Bundle();
        b.putCharSequence("pass", password);
        rec.send(0, b); // $hasSensitiveResultReceiver
    }
}