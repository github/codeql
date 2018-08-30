class Test implements Func {
    public boolean test() { return false; }
    public static void test2(Func func) {
    }
    {
        test2(this::test);
    }
}


interface Func {
    public boolean test();
}

class Test2 {
    {
        new Test().test2(() -> {
            Func f = () -> false;
            return false;
        });
    }
}
class Test3 {
	public abstract class SourceType2 {}
	public abstract class SourceType<T, U> {}
    private final java.util.concurrent.ConcurrentHashMap<String, Test3.SourceType<SourceType2, byte[]>> cache =
            new java.util.concurrent.ConcurrentHashMap<>();
    {
        cache.computeIfAbsent(
                null,
                dummy-> {
                    return null;
                });
    }
}
