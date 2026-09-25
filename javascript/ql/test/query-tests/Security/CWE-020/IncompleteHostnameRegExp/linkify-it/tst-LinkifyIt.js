import { LinkifyIt, linkifyit } from "linkify-it";
import { LinkifyIt as OtherLinkifyIt } from "other-linkify-it";

const scanner = new LinkifyIt({ fuzzyLink: false, fuzzyEmail: false })
  .add("ftp:", null)
  .add("mailto:", null)
  .add("//", null);
const text =
  "😀 *literal* (https://www.youtube.com/watch?v=tax4e4hBBZc), then https://store.steampowered.com/app/457140/.";
const matches = scanner.match(text);
if (matches) {
  console.log(matches.map((match) => match.raw));
}

if (new LinkifyIt().match("https://www.example.com")) {}
if (new LinkifyIt().set({ fuzzyLink: false }).match("https://www.example.com")) {}
if (new LinkifyIt().tlds("onion", true).match("https://www.example.com")) {}
if (linkifyit().match("https://www.example.com")) {}

const otherScanner = new OtherLinkifyIt().add("ftp:", null);
if (otherScanner.match("^https://www.example.com")) {} // $ Alert
