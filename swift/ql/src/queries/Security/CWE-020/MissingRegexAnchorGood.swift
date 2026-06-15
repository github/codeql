func handleUrl(_ urlString: String) {
    // get the 'url=' parameter from the URL
    let components = URLComponents(string: urlString)
    let redirectParam = components?.queryItems?.first(where: { $0.name == "url" })

    // check we trust the host
    let regex = try Regex(#"^https?://www\.example\.com"#) // GOOD: the host of `url` can not be controlled by an attacker
    if let match = redirectParam?.value?.firstMatch(of: regex) {
        // ... trust the URL ...
    }
}
