import { Matches } from "class-validator";

class Validated {
    @Matches(/^\w+$/) // $ sanitizer
    singleLine: string;

    @Matches(/^\w+$/m)
    multiline: string;

    @Matches(new RegExp("^\\w+$")) // $ sanitizer
    constructedSingleLine: string;

    @Matches(new RegExp("^\\w+$", "m"))
    constructedMultiline: string;

    @Matches("^\\w+$", "i") // $ sanitizer
    stringSingleLine: string;

    // Separate flags for string patterns are not currently covered by the sanitizer model.
    @Matches("^\\w+$", "m") // $ SPURIOUS: sanitizer
    stringMultiline: string;
}
