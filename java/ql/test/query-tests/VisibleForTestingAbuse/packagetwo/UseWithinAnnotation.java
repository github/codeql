package packagetwo;

import packageone.*;

@interface Range {
    int min() default 0;
    int max() default 100;
}

public class UseWithinAnnotation {
    @VisibleForTesting
    static final int MAX_LISTING_LENGTH_MIN = 1;
    @VisibleForTesting
    static final int MAX_LISTING_LENGTH_MAX = 1000;

    @Range(min = MAX_LISTING_LENGTH_MIN, max = MAX_LISTING_LENGTH_MAX)
    private int maxListingLength = MAX_LISTING_LENGTH_MAX;
}
