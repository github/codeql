
@SuppressWarnings("lgtm[java/non-sync-override]")
@Deprecated
class TestSuppressWarnings {
    @SuppressWarnings("lgtm[]")
    public void test() {
        
    }
    @Deprecated
    @SuppressWarnings("lgtm[java/confusing-method-name]")
    public void test2() {
        
    }
    @SuppressWarnings("lgtm")
    public void test3() {
        
    }
}
