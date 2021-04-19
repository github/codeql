import java.util.ArrayList;
import java.util.List;
import java.util.Map;

class UselessTypeTest {
    static class ExtendingRaw extends ArrayList {
    }

    Object obj = null;
    boolean[] bad = {
        "" instanceof String,
        "" instanceof Object,
        new ArrayList<String>() instanceof ArrayList<String>,
        new ArrayList<String>() instanceof ArrayList<?>,
        new ArrayList<String>() instanceof ArrayList<? super String>,
        new ArrayList<String>() instanceof ArrayList<? extends String>,
        new ArrayList<String>() instanceof List<? super String>,
        new ArrayList<String>() instanceof List<? extends String>,
        ((ArrayList<?>) obj) instanceof List,
        ((ArrayList<? super String>) obj) instanceof List<?>,
        ((ArrayList<? super String>) obj) instanceof List,
        ((ArrayList<? extends String>) obj) instanceof List<?>,
        ((ArrayList<? extends String>) obj) instanceof List,
        ((List<?>) obj) instanceof List,
        ((List<? super String>) obj) instanceof List<?>,
        ((List<? super String>) obj) instanceof List,
        ((List<? extends String>) obj) instanceof List<?>,
        ((List<? extends String>) obj) instanceof List,
        new ArrayList<String>() instanceof ArrayList,
        new ArrayList() instanceof ArrayList<?>,
        new ArrayList<String>() instanceof List<String>,
        new ArrayList<String>() instanceof List<?>,
        new ArrayList<String>() instanceof List,
        new ExtendingRaw() instanceof ArrayList,
        new ExtendingRaw() instanceof ArrayList<?>,
        new String[0] instanceof String[],
        new String[0] instanceof Object,
        new String[0] instanceof Object[],
        new int[0] instanceof Object,
    };

    boolean[] good = {
        new Object() instanceof Number,
        new ArrayList<String>() instanceof Map<?, ?>,
        new ArrayList<String>() instanceof Map,
        ((List<? super String>) obj) instanceof ArrayList<?>,
        ((List<? super String>) obj) instanceof ArrayList<? super String>,
        new Object() instanceof int[],
        new Object() instanceof Object[],
        new Object[0] instanceof String[],
    };
}
