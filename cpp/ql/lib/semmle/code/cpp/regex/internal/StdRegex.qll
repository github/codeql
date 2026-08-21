/**
 * Provides identification of the `std::basic_regex` standard-library API type.
 *
 * This is shared infrastructure used by both the flow-free grammar/flag
 * module (`RegexGrammar`) and the dataflow layer (`RegexFlowConfigs`). It
 * lives in its own module so that importing it does not pull in the
 * dataflow libraries: both `RegexGrammar.qll` and `RegexFlowConfigs.qll`
 * can import it, keeping the parser/tree-view layer flow-free.
 */

import cpp

/**
 * A `std::basic_regex` class type (or instantiation thereof, e.g. `std::regex`,
 * `std::wregex`).
 */
class StdBasicRegex extends Class {
  StdBasicRegex() {
    this.hasQualifiedName("std", "basic_regex")
    or
    this.(ClassTemplateInstantiation).getTemplate().hasQualifiedName("std", "basic_regex")
  }
}
