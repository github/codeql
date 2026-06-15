import Foundation
import ZipArchive

func unzipFile(at sourcePath: String, to destinationPath: String) {
    do {
        let remoteURL = URL(string: "https://example.com/")!

        let source  = URL(fileURLWithPath: sourcePath)

        // Malicious zip is downloaded 
        try Data(contentsOf: remoteURL).write(to: source)

        // ZipArchive is safe
        try SSZipArchive.unzipFile(atPath: sourcePath, toDestination: destinationPath, delegate: self)
        } catch {
    }
}

func main() {
    let sourcePath = "/sourcePath" 
    let destinationPath = "/destinationPath" 
    unzipFile(at: sourcePath, to: destinationPath)
}

main()