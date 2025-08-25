addEventListener("message", (event) => { // $ Source
  angular.merge({}, JSON.parse(event.data)); // $ Alert
});
