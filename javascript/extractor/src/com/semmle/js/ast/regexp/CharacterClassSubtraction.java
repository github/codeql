package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;
import java.util.List;

public class CharacterClassSubtraction extends RegExpTerm {
    private final List<RegExpTerm> subtraction;

    public CharacterClassSubtraction(SourceLocation loc, List<RegExpTerm> subtraction) {
        super(loc, "CharacterClassSubtraction");
        this.subtraction = subtraction;
    }

    @Override
    public void accept(Visitor v) {
        v.visit(this);
    }

    public List<RegExpTerm> getSubtraction() {
        return subtraction;
    }
}
