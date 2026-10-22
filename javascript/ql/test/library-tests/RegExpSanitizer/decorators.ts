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
}
