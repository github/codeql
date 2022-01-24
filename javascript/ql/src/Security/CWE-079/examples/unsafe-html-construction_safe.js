module.exports = function showBoldName(name) {
  const bold = document.createElement('b');
  bold.innerText = name;
  document.getElementById('name').appendChild(bold);
}
