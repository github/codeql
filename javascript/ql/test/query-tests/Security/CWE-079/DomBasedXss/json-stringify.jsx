var express = require("express");
var app = express();

app.get("/some/path", function (req, res) {
  const locale = req.param("locale"); // $ Source
  const breadcrumbList = [
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
        name: "Path",
      },
    },
  ];
  const jsonLD = {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    itemListElement: breadcrumbList,
  };
  <script
    type="application/ld+json"
    dangerouslySetInnerHTML={{ __html: JSON.stringify(locale) }} // $ Alert
  />;
  <script
    type="application/ld+json"
    dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLD) }} // $ Alert
  />;
  <script
    type="application/ld+json"
    dangerouslySetInnerHTML={{ __html: JSON.stringify({}) }}
  />;
  <script type="application/ld+json">{ JSON.stringify(jsonLD) }</script>
});
