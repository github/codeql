try {
   $Exception = New-Object System.Xaml.XamlException -ArgumentList ("Bad XAML!", $null, 10, 2)
    throw $Exception
}
catch [System.Net.WebException],[System.IO.IOException] {
    "Unable to download MyDoc.doc from http://www.contoso.com."
}
catch {
    "An error occurred that could not be resolved."
}
finally {
    "The finally block is executed."
}