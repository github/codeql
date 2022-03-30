public class LoadFileFromAppActivity extends Activity {
    public static final int REQUEST_CODE__SELECT_CONTENT_FROM_APPS = 99;

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == LoadFileFromAppActivity.REQUEST_CODE__SELECT_CONTENT_FROM_APPS &&
                resultCode == RESULT_OK) {
            
            {
                // BAD: Load file without validation
                loadOfContentFromApps(data, resultCode);
            }

            {
                // GOOD: load file with validation
                if (!data.getData().getPath().startsWith("/data/data")) {
                    loadOfContentFromApps(data, resultCode);
                }    
            }
        }
    }

    private void loadOfContentFromApps(Intent contentIntent, int resultCode) {
        Uri streamsToUpload = contentIntent.getData();
        try {
            RandomAccessFile file = new RandomAccessFile(streamsToUpload.getPath(), "r");
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}
