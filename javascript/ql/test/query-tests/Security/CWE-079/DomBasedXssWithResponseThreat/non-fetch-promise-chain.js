function insertRequestPromiseBody() {
  const rp = require("request-promise-native");
  rp("https://example.com/message") // $ Source[js/xss]
    .then(body => {
      document.body.innerHTML = body; // $ Alert[js/xss]
    });
}

function insertRequestPromiseJsonBody() {
  const rp = require("request-promise");
  rp({ uri: "https://example.com/message", json: true }) // $ Source[js/xss]
    .then(data => {
      document.body.innerHTML = data.message; // $ Alert[js/xss]
    });
}

function insertAxiosResponseData() {
  const axios = require("axios");
  const request = axios.get("https://example.com/message"); // $ Source[js/xss]
  request.then(response => {
    document.body.innerHTML = response.data.message; // $ Alert[js/xss]
  });
}

function insertNeedleResponseBody() {
  const needle = require("needle");
  needle("get", "https://example.com/message") // $ Source[js/xss]
    .then(response => {
      document.body.innerHTML = response.body.message; // $ Alert[js/xss]
    });
}

function insertSuperagentResponseText() {
  const superagent = require("superagent");
  superagent.get("https://example.com/message") // $ Source[js/xss]
    .then(response => {
      document.body.innerHTML = response.text; // $ Alert[js/xss]
    });
}

function assignAxiosResponseToInputValue() {
  const axios = require("axios");
  axios.get("https://example.com/message")
    .then(response => {
      document.querySelector("input").value = response.data.message;
    });
}
