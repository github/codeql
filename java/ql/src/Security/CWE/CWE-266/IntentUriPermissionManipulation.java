public class IntentUriPermissionManipulation extends Activity {

    // BAD: the user-provided Intent is returned as-is
    public void dangerous() {
        Intent intent = getIntent();
        intent.putExtra("result", "resultData");
        setResult(intent);
    }

    // GOOD: a new Intent is created and returned
    public void safe() {
        Intent intent = new Intent();
        intent.putExtra("result", "resultData");
        setResult(intent);
    }

    // GOOD: the user-provided Intent is sanitized before being returned
    public void sanitized() {
        Intent intent = getIntent();
        intent.putExtra("result", "resultData");
        intent.removeFlags(
                Intent.FLAG_GRANT_WRITE_URI_PERMISSION | Intent.FLAG_GRANT_READ_URI_PERMISSION);
        setResult(intent);
    }
}
