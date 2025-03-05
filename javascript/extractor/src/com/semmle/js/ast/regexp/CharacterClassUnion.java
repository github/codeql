package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;
import java.util.List;

public class CharacterClassUnion extends RegExpTerm {
    private final List<RegExpTerm> elements;

    public CharacterClassUnion(SourceLocation loc, List<RegExpTerm> elements) {
        super(loc, "CharacterClassUnion");
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
