(function () {
  function getSource() {
    var source = "source"; // step 1
    return source; // step 2
  }
  loadScript(getSource()) // step 3
    .then(function () { })
    .then(function () { })
    .catch(handleError);
  function loadScript(src) { // step 4 (is summarized)
    return new Promise(function (resolve, reject) {
      setTimeout(function (error) {
        reject(new Error('Blah: ' + src)); // step 5
      }, 1000);
    });
  }
  function handleError(error) { // step 6
    sink(error); // step 7
  }
})();