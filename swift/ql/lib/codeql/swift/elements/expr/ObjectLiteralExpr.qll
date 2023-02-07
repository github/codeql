private import codeql.swift.generated.expr.ObjectLiteralExpr

class ObjectLiteralExpr extends Generated::ObjectLiteralExpr { }

class FileLiteralExpr extends ObjectLiteralExpr {
  FileLiteralExpr() { this.getKind() = 0 }

  override string toString() { result = "#fileLiteral(...)" }
}

class ImageLiteralExpr extends ObjectLiteralExpr {
  ImageLiteralExpr() { this.getKind() = 1 }

  override string toString() { result = "#imageLiteral(...)" }
}

class ColorLiteralExpr extends ObjectLiteralExpr {
  ColorLiteralExpr() { this.getKind() = 2 }

  override string toString() { result = "#colorLiteral(...)" }
}
