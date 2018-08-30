class DateFormattingThread implements Runnable {
    private DateFormat dateF = new SimpleDateFormat("yyyyMMdd");  // Instance field declared

    public void run() {
        for(int i=0; i < 10; i++){
            try {
                Date d = dateF.parse("20121221");
                System.out.println(d);
            } catch (ParseException e) { }
        }
    }
}

public class DateFormatThreadUnsafeFix {
    
    public static void main(String[] args) {
        for(int i=0; i<100; i++){
            new Thread(new DateFormattingThread()).start();
        }
    }

}