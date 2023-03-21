// BAD: Sensitive data is sent to an untrusted result receiver 
void bad(String password) {
    Intent intent = getIntent();
    ResultReceiver rec = intent.getParcelableExtra("Receiver");
    Bundle b = new Bundle();
    b.putCharSequence("pass", password);
    rec.send(0, b); 
}