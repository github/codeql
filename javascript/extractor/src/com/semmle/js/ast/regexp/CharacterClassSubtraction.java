package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;
import java.util.List;

/**
 * A character class subtraction in a regular expression available only with the `v` flag.
 * Example: [[abc]--[a]--[b]] matches character `c` only.
 */
public class CharacterClassSubtraction extends RegExpTerm {
    private final List<RegExpTerm> elements;

    public CharacterClassSubtraction(SourceLocation loc, List<RegExpTerm> elements) {
        super(loc, "CharacterClassSubtraction");
        this.elements = elements;
    }

    @Override
    public void accept(Visitor v) {
        v.visit(this);
    }

    public List<RegExpTerm> getElements() {
        return elements;
    }
}
