//codeql-extractor-expected-status: 1

// These require Foundation and UIKit/AppKit to really work
// That is why compilation will fail and the entities will have error types
_ = #fileLiteral(resourceName: "file.txt")
_ = #colorLiteral(red: 255, green: 255, blue: 255, alpha: 50)
_ = #imageLiteral(resourceName: "image.gif")
