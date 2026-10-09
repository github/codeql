const { LinkifyIt } = require("linkify-it");
const legacyLinkifyIt = require("linkify-it");

const scanner = new LinkifyIt().add("ftp:", null).set({ fuzzyLink: false });
const text = "https://a.b.com";
console.log(scanner.match(text));
console.log(legacyLinkifyIt().match(text));
