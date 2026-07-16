private import csharp as CS
private import semmle.code.asp.AspNet as ASP
private import codeql.util.test.InlineExpectationsTest

module Impl implements InlineExpectationsTestSig {
  private newtype TExpectationComment =
    TCSharpComment(CS::SinglelineComment c) or
    TXmlComment(CS::XmlComment c) or
    TAspComment(ASP::AspComment c)

  /**
   * A class representing comments that may contain inline expectations.
   * Supports C# single-line comments (`//`), XML comments (`<!-- -->`), and
   * ASP.NET comments (`<!-- -->` and `<%-- --%>`) in their respective file types.
   */
  class ExpectationComment extends TExpectationComment {
    CS::SinglelineComment asCSharpComment() { this = TCSharpComment(result) }

    CS::XmlComment asXmlComment() { this = TXmlComment(result) }

    ASP::AspComment asAspComment() { this = TAspComment(result) }

    /** Gets the contents of this comment, _without_ the preceding comment marker. */
    string getContents() {
      result = this.asCSharpComment().getText()
      or
      result = this.asXmlComment().getText()
      or
      result = this.asAspComment().getBody()
    }

    /** Gets the location of this comment. */
    Location getLocation() {
      result = this.asCSharpComment().getLocation()
      or
      result = this.asXmlComment().getLocation()
      or
      result = this.asAspComment().getLocation()
    }

    /** Gets a textual representation of this comment. */
    string toString() {
      result = this.asCSharpComment().toString()
      or
      result = this.asXmlComment().toString()
      or
      result = this.asAspComment().toString()
    }
  }

  class Location = CS::Location;
}
