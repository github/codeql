
func handleUrl(_ urlString: String) {
    // get the 'url=' parameter from the URL
    let components = URLComponents(string: urlString)
    let redirectParam = components?.queryItems?.first(where: { $0.name == "url" })

    // check we trust the host
    let regex = #/^(www|beta).example.com//#  // BAD
    if let match = redirectParam?.value?.firstMatch(of: regex) {
        // ... trust the URL ...
    }
}
