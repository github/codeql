// Solution 1: Extract to individual constants
public class Display {
    public static final String RED = "FF0000";
    public static final String GREEN = "00FF00";
    public static final String BLUE = "0000FF";
}

// Solution 2: Define constants using in an enum type
public enum Display
{
    RED ("FF0000"), GREEN ("00FF00"), BLUE ("0000FF");

    private String rgb;
    private Display(int rgb) {
        this.rgb = rgb;
    }
    public String getRGB(){
        return rgb;
    }
}

// Solution 3: Use an unmodifiable collection
public class Display {
    public static final List<String> RGB =
            Collections.unmodifiableList(
                    Arrays.asList("FF0000",
                            "00FF00",
                            "0000FF"));
}

// Solution 4: Use a utility method
public class Utils {
    public static <T> List<T> constList(T... values) {
        return Collections.unmodifiableList(
                Arrays.asList(values));
    }
}

public class Display {
    public static final List<String> RGB =
            Utils.constList("FF0000", "00FF00", "0000FF");
}
