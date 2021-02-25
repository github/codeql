document.getElementById('my-id').onclick = function () {
  this.parentNode.innerHTML = '<b>hello</b>'; // `this` is a DOM element
};

document.getElementById('my-id').addEventListener("click", function (ev) {
  this.parentNode.innerHTML = '<b>hello</b>'; // `this` is a DOM element
});
