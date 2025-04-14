---
category: minorAnalysis
---
* Data passed to the [NextResponse](https://nextjs.org/docs/app/api-reference/functions/next-response) constructor is now treated as a sink for `js/reflected-xss`.
* Data received from [NextRequest](https://nextjs.org/docs/app/api-reference/functions/next-request) and [Request](https://developer.mozilla.org/en-US/docs/Web/API/Request) is now treated as a remote user input `source`.
