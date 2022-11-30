import android.webkit.JavascriptInterface;
import android.database.sqlite.SQLiteOpenHelper;

class ExposedObject extends SQLiteOpenHelper {
    @JavascriptInterface
    public String studentEmail(String studentName) {
        // SQL injection
        String query = "SELECT email FROM students WHERE studentname = '" + studentName + "'";

        Cursor cursor = db.rawQuery(query, null);
        cursor.moveToFirst();
        String email = cursor.getString(0);

        return email;
    }
}

webview.getSettings().setJavaScriptEnabled(true);
webview.addJavaScriptInterface(new ExposedObject(), "exposedObject");
webview.loadData("", "text/html", null);

String name = "Robert'; DROP TABLE students; --";
webview.loadUrl("javascript:alert(exposedObject.studentEmail(\""+ name +"\"))");
