# BAD: Uses outlook.us domain
$outlookUrl = "https://mail.outlook.us/api/v1"

# BAD: Uses office.us domain
$officeUrl = "https://portal.office.us/admin"

# BAD: Uses deprecated goo.gl shortener
$shortUrl = "https://goo.gl/abc123"

# BAD: Uses deprecated ajax.aspnetcdn.com
$cdnUrl = "https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.5.1.min.js"

# BAD: Uses deprecated ajax.microsoft.com
$msAjaxUrl = "http://ajax.microsoft.com/ajax/4.0/1/MicrosoftAjax.js"

# GOOD: Uses valid Microsoft domains
$validUrl1 = "https://outlook.office365.com/api/v1"
$validUrl2 = "https://portal.azure.com"
