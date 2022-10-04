var express = require("express");
var app = express();

app.get("/some/path", function (req, res) {
  const locale = req.param("locale");
  const jsonLD = {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    itemListElement: [
      {
        "@type": "ListItem",
        position: 1,
        item: {
          "@id": `https://example.com/some?locale=${locale}`,
          name: "Some",
        },
      },
      {
        "@type": "ListItem",
        position: 2,
        item: {
          "@id": `https://example.com/some/path?locale=${locale}`,
          name: "Real Dresses",
        },
      },
    ],
  };
  <script
    type="application/ld+json"
    dangerouslySetInnerHTML={{ __html: locale }} // NOT OK
  />;
  <script
    type="application/ld+json"
    dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLD) }} // NOT OK
  />;
  <script
    type="application/ld+json"
    dangerouslySetInnerHTML={{ __html: JSON.stringify({}) }} // OK
  />;
});
