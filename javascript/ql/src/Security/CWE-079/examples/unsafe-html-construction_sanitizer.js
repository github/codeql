
const striptags = require('striptags');
module.exports = function showBoldName(name) {
  document.getElementById('name').innerHTML = "<b>" + striptags(name) + "</b>";
}
