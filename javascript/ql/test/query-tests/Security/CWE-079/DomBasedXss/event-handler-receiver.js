document.getElementById('my-id').onclick = function() {
  this.parentNode.innerHTML = '<h2><a href="' + location.href + '">A link</a></h2>'; // NOT OK
};
