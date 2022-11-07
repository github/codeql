import java.util.regex.Matcher;
import java.util.regex.Pattern;


public class BadTagFilter extends Object {
    public static String filter(String content) {
        String oldContent = "";
        while (!oldContent.equals(content)) {
            oldContent = content;
            Pattern p = Pattern.compile("(?i)(?s)<script.*?>.*?</script>");
            content = p.matcher(content).replaceAll("");
        }
        
        return content;
    }
}
