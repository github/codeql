package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;
import java.util.List;

public class CharacterClassUnion extends RegExpTerm {
    private final List<RegExpTerm> union;

    public CharacterClassUnion(SourceLocation loc, List<RegExpTerm> union) {
        super(loc, "CharacterClassUnion");
        this.union = union;
    }

    @Override
    public void accept(Visitor v) {
        v.visit(this);
    }

    public List<RegExpTerm> getUnion() {
        return union;
    }
}
