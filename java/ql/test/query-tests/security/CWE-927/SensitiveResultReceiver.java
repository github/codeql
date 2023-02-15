import android.os.Bundle;
import android.os.ResultReceiver;
import android.content.Intent;

class SensitiveResultReceiver {
    <T> T source() { return null; }

    void test1(String password) {
        Intent intent = source();
        ResultReceiver rec = intent.getParcelableExtra("hi");
        Bundle b = new Bundle();
        b.putCharSequence("pass", password);
        rec.send(0, b); // $hasSensitiveResultReceiver
    }
}