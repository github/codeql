package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;
import java.util.List;

/**
 * A character class intersection in a regular expression available only with the `v` flag.
 * Example: [[abc]&&[ab]&&[b]] matches character `b` only.
 */
public class CharacterClassIntersection extends RegExpTerm {
    private final List<RegExpTerm> elements;

    public CharacterClassIntersection(SourceLocation loc, List<RegExpTerm> elements) {
        super(loc, "CharacterClassIntersection");
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
