import cheerio from "cheerio";

function test(x) {
  let $ = getTemplate(); 
  $.attr('foo', 5).data('bar', 6).html(x);
}

function getTemplate() {
  return cheerio.load('<b>text</b>');
}
