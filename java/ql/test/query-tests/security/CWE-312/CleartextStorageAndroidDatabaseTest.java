import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.Base64;
import android.app.Activity;
import android.content.ContentValues;
import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteStatement;

public class CleartextStorageAndroidDatabaseTest extends Activity {

    public void testCleartextStorageAndroiDatabaseSafe1(Context ctx, String name, String password) {
        SQLiteDatabase db = ctx.openOrCreateDatabase("test", Context.MODE_PRIVATE, null);
        db.execSQL("CREATE TABLE IF NOT EXISTS users(user VARCHAR, password VARCHAR);"); // Safe
    }

    public void testCleartextStorageAndroiDatabaseSafe2(Context ctx, String name, String password) {
        SQLiteDatabase db = ctx.openOrCreateDatabase("test", Context.MODE_PRIVATE, null);
        db.execSQL("DROP TABLE passwords;"); // Safe - no sensitive value being stored
    }

    public void testCleartextStorageAndroiDatabase0(Context ctx, String name, String password) {
        SQLiteDatabase db = ctx.openOrCreateDatabase("test", Context.MODE_PRIVATE, null);
        String query = "INSERT INTO users VALUES ('" + name + "', '" + password + "');";
        db.execSQL(query); // $ hasCleartextStorageAndroidDatabase
    }

    public void testCleartextStorageAndroiDatabase1(Context ctx, String name, String password) {
        SQLiteDatabase db = SQLiteDatabase.openDatabase("", null, 0);
        String query = "INSERT INTO users VALUES ('" + name + "', '" + password + "');";
        db.execSQL(query); // $ hasCleartextStorageAndroidDatabase
    }

    public void testCleartextStorageAndroiDatabase2(String name, String password) {
        SQLiteDatabase db = SQLiteDatabase.openOrCreateDatabase("", null);
        String query = "INSERT INTO users VALUES (?, ?)";
        db.execSQL(query, new String[] {name, password}); // $ hasCleartextStorageAndroidDatabase
    }

    //@formatter:off
    public void testCleartextStorageAndroiDatabase3(String name, String password) {
        SQLiteDatabase db = SQLiteDatabase.create(null);
        String query = "INSERT INTO users VALUES (?, ?)";
        db.execPerConnectionSQL(query, new String[] {name, password}); // $ hasCleartextStorageAndroidDatabase
    }
    //@formatter:on

    public void testCleartextStorageAndroiDatabaseSafe3(String name, String password) {
        SQLiteDatabase db = SQLiteDatabase.openDatabase("", null, 0);
        ContentValues cv = new ContentValues();
        cv.put("username", name);
        cv.put("password", password); // Safe - ContentValues aren't added to any database
    }

    public void testCleartextStorageAndroiDatabase4(String name, String password) {
        SQLiteDatabase db = SQLiteDatabase.openDatabase("", null, 0);
        ContentValues cv = new ContentValues();
        cv.put("username", name);
        cv.put("password", password); // $ hasCleartextStorageAndroidDatabase
        db.insert("table", null, cv);
    }

    public void testCleartextStorageAndroiDatabase5(String name, String password) {
        SQLiteDatabase db = SQLiteDatabase.openDatabase("", null, 0);
        ContentValues cv = new ContentValues();
        cv.put("username", name);
        cv.put("password", password); // $ hasCleartextStorageAndroidDatabase
        db.insertOrThrow("table", null, cv);
    }

    public void testCleartextStorageAndroiDatabase6(String name, String password) {
        SQLiteDatabase db = SQLiteDatabase.openDatabase("", null, 0);
        ContentValues cv = new ContentValues();
        cv.put("username", name);
        cv.put("password", password); // $ hasCleartextStorageAndroidDatabase
        db.insertWithOnConflict("table", null, cv, 0);
    }

    public void testCleartextStorageAndroiDatabase7(String name, String password) {
        SQLiteDatabase db = SQLiteDatabase.openDatabase("", null, 0);
        ContentValues cv = new ContentValues();
        cv.put("username", name);
        cv.put("password", password); // $ hasCleartextStorageAndroidDatabase
        db.replace("table", null, cv);
    }

    public void testCleartextStorageAndroiDatabase8(String name, String password) {
        SQLiteDatabase db = SQLiteDatabase.openDatabase("", null, 0);
        ContentValues cv = new ContentValues();
        cv.put("username", name);
        cv.put("password", password); // $ hasCleartextStorageAndroidDatabase
        db.replaceOrThrow("table", null, cv);
    }

    public void testCleartextStorageAndroiDatabase9(String name, String password) {
        SQLiteDatabase db = SQLiteDatabase.openDatabase("", null, 0);
        ContentValues cv = new ContentValues();
        cv.put("username", name);
        cv.put("password", password); // $ hasCleartextStorageAndroidDatabase
        db.update("table", cv, "", new String[] {});
    }

    public void testCleartextStorageAndroiDatabase10(String name, String password) {
        SQLiteDatabase db = SQLiteDatabase.openDatabase("", null, 0);
        ContentValues cv = new ContentValues();
        cv.put("username", name);
        cv.put("password", password); // $ hasCleartextStorageAndroidDatabase
        db.updateWithOnConflict("table", cv, "", new String[] {}, 0);
    }

    public void testCleartextStorageAndroiDatabaseSafe4(SQLiteDatabase db, String name,
            String password) {
        String query = "INSERT INTO users VALUES ('" + name + "', '" + password + "');";
        SQLiteStatement stmt = db.compileStatement(query); // Safe - statement isn't executed
    }

    public void testCleartextStorageAndroiDatabase11(SQLiteDatabase db, String name,
            String password) {
        String query = "INSERT INTO users VALUES ('" + name + "', '" + password + "');";
        SQLiteStatement stmt = db.compileStatement(query); // $ hasCleartextStorageAndroidDatabase
        stmt.executeUpdateDelete();
    }

    public void testCleartextStorageAndroiDatabase12(SQLiteDatabase db, String name,
            String password) {
        String query = "INSERT INTO users VALUES ('" + name + "', '" + password + "');";
        SQLiteStatement stmt = db.compileStatement(query); // $ hasCleartextStorageAndroidDatabase
        stmt.executeInsert();
    }

    public void testCleartextStorageAndroiDatabaseSafe5(String name, String password)
            throws Exception {
        SQLiteDatabase db = SQLiteDatabase.create(null);
        String query = "INSERT INTO users VALUES (?, ?)";
        db.execSQL(query, new String[] {name, encrypt(password)}); // Safe
    }

    private static String encrypt(String cleartext) throws Exception {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hash = digest.digest(cleartext.getBytes(StandardCharsets.UTF_8));
        String encoded = Base64.getEncoder().encodeToString(hash);
        return encoded;
    }
}
