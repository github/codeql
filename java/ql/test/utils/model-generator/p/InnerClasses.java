package p;

public class InnerClasses {
    
    class IgnoreMe {
        public String no(String input) {
            return input;
        }
    }
    
    public class CaptureMe {
        public String yesCm(String input) {
            return input;
        }
    }

    public String yes(String input) {
        return input;
    }

}
