import java.util.*;

public class CallableViaSummary {
    public interface Element {
        public void handle(String message);
    }

    public void main(String[] args) {
        List<Element> elements = new ArrayList<>();

        List<Element> elements2 = new ArrayList<>();

        elements.add(new Element() {
            @Override
            public void handle(String message) {
                System.out.println(message);
            }
        });

        elements.add(message -> System.out.println(message));

        // This dispatches to the two added elements because
        // the summary of ArrayList causes flow via type tracking.
        elements.get(0).handle("Hello, world!");

        // This does not dispatch to anything, showing that the
        // open-world assumption does not apply
        // (and hence that type tracking is necessary above).
        elements2.get(0).handle("Hello, world!");
    }
}