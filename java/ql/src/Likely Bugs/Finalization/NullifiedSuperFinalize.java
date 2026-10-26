class LocalCache {
    private Collection<NativeResource> localResources;

    //...

    protected void finalize() throws Throwable {
        for (NativeResource r : localResources) {
            r.dispose();
        }
    };
}

class WrongCache extends LocalCache {
    //...
    @Override
    protected void finalize() throws Throwable {
        // BAD: Empty 'finalize', which does not call 'super.finalize'.
        //        Native resources in LocalCache are not disposed of.
    }
}

class RightCache extends LocalCache {
    //...
    @Override
    protected void finalize() throws Throwable {
        // GOOD: 'finalize' calls 'super.finalize'.
        //        Native resources in LocalCache are disposed of.
        super.finalize();
    }
}
