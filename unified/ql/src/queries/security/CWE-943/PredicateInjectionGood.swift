let remoteString = try String(contentsOf: URL(string: "https://example.com/")!)

let filenames: [String] = ["img1.png", "img2.png", "img3.png", "img.txt", "img.csv"]

let predicate = NSPredicate(format: "SELF LIKE %@", remoteString)
let filtered = filenames.filter(){ filename in
    predicate.evaluate(with: filename)
}
print(filtered)
