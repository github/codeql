public class PendingIntentTestActivity extends Activity {


    public void test_pendingIntent1(Context context, Intent intent_imp, Intent intent_nonImp,
                                    Intent intent_rand, int flag_imp1, int flag_imp2, int flag_immute) {
        PendingIntent.getActivity(context, 1231, intent_imp, flag_imp1);    // vulner
        PendingIntent.getActivity(context, 1231, intent_imp, PendingIntent.FLAG_UPDATE_CURRENT);    // vulner
        PendingIntent.getActivity(context, 1231, intent_imp, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_ONE_SHOT);    // vulner
        PendingIntent.getActivity(context, 1231, intent_imp, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
        PendingIntent.getActivity(context, 1231, intent_imp, PendingIntent.FLAG_UPDATE_CURRENT | 0x10);    // vulner
        PendingIntent.getActivity(context, 1231, intent_imp, PendingIntent.FLAG_UPDATE_CURRENT | 0x4000000);
        PendingIntent.getActivity(context, 1231, intent_imp, PendingIntent.FLAG_UPDATE_CURRENT | 67108864);
        PendingIntent.getActivity(context, 1231, intent_imp, PendingIntent.FLAG_IMMUTABLE);
        PendingIntent.getBroadcast(context, 1232, intent_nonImp, flag_imp2);
        PendingIntent.getService(context, 1233, intent_imp, flag_imp1);    // vulner
        PendingIntent.getService(context, 1233, intent_imp, flag_immute);
        PendingIntent.getService(context, 1234, intent_nonImp, PendingIntent.FLAG_IMMUTABLE);
        PendingIntent.getActivity(context, 1235, intent_rand, 0);    // vulner
        PendingIntent.getActivity(context, 1235, intent_rand, flag_imp2);    // vulner
        PendingIntent.getService(context, 1236, intent_rand, flag_immute);
    }

    public void test_pendingIntent2(Context context, Intent intent_imp, Intent intent_nonImp,
                                    Intent intent_rand) {
        int flag_imp1 = PendingIntent.FLAG_UPDATE_CURRENT;
        int flag_imp2 = 0;
        int flag_immute = PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE;
        test_pendingIntent1(context, intent_imp, intent_nonImp, intent_rand, flag_imp1, flag_imp2, flag_immute);
    }

    public void test_pendingIntent3(Context context, Intent intent_imp, Intent intent_nonImp,
                                    Intent intent_rand) {
        Intent intent_imp1 = new Intent(intent_imp);
        Intent intent_rand1 = new Intent(intent_rand);
        test_pendingIntent2(context, intent_imp1, intent_nonImp, intent_rand1);
    }

    public void test_pendingIntent4(Context context) {
        Intent intent_imp = new Intent("com.pd.impllicit_intent");
        Intent intent_nonImp = new Intent("com.pd.intent2")
                .setClassName("com.gl.testpoc", "com.gl.testpoc.MainActivity");
        Intent intent_rand = new Intent("com.pd.randImpllicit_intent");
        if (new Random().nextInt(2) == 1) {
            intent_rand.setClassName("com.gl.testpoc", "com.gl.testpoc.MainActivity");
        }
        test_pendingIntent3(context, intent_imp, intent_nonImp, intent_rand);
    }





}
