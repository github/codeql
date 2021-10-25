
@SuppressWarnings("lgtm[java/non-sync-override]")
@Deprecated
class TestSuppressWarnings {
    @SuppressWarnings("lgtm[]")
    public void test() {
        
    }
    @Deprecated
    @SuppressWarnings({"lgtm[java/confusing-method-name] not confusing","lgtm[java/non-sync-override]"})
    public void test2() {
        
    }
    @SuppressWarnings("lgtm")
    public void test3() {
        
    }
    @SuppressWarnings({"lgtm[java/confusing-method-name] blah blah lgtm[java/non-sync-override]"})
    public void test4() {
        
    }
}
