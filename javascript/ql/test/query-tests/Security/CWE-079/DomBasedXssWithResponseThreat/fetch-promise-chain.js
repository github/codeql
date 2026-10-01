function insertMessageRows(pageSize, continuationToken) {
  let url = "?handler=LoadMessageLogs&pageSize=" + pageSize;
  if (continuationToken) {
    url += "&continuationToken=" + encodeURIComponent(continuationToken);
  }

  fetch(url) // $ Source[js/xss]
    .then(response => response.json())
    .then(data => {
      const tbody = document.querySelector("#tblMessageLogs tbody");
      tbody.innerHTML = "";

      data.items.forEach(item => {
        const link = `<a href="/MessageLogs/Details/${item.messageId}">View message</a>`;
        const row = `<tr>
          <td>${item.createdDate}</td>
          <td>${item.messageId}</td>
          <td>${item.target ?? ""}</td>
          <td>${link}</td>
        </tr>`;
        tbody.insertAdjacentHTML("beforeend", row); // $ Alert[js/xss]
      });
    });
}

function insertPlainTextResponse() {
  fetch("/api/message") // $ Source[js/xss]
    .then(response => response.text())
    .then(text => {
      document.body.innerHTML = text; // $ Alert[js/xss]
    });
}

function assignTextContent() {
  fetch("/api/message")
    .then(response => response.json())
    .then(data => {
      document.body.textContent = data.message;
    });
}

function insertAliasedFetchResponse() {
  const request = fetch("/api/message"); // $ Source[js/xss]
  request
    .then(response => response.json())
    .then(data => {
      document.body.innerHTML = data.message; // $ Alert[js/xss]
    });
}

function insertReassignedFetchResponse() {
  let request;
  request = fetch("/api/message"); // $ Source[js/xss]
  request
    .then(response => response.text())
    .then(text => {
      document.body.innerHTML = text; // $ Alert[js/xss]
    });
}

function insertMessageAfterMultipleThenHops() {
  fetch("/api/message") // $ Source[js/xss]
    .then(response => response.json())
    .then(data => data.items)
    .then(items => {
      items.forEach(item => {
        document.body.insertAdjacentHTML("beforeend", item.message); // $ Alert[js/xss]
      });
    });
}

function insertDestructuredMessage() {
  fetch("/api/message") // $ Source[js/xss]
    .then(response => response.json())
    .then(({ message }) => {
      document.body.innerHTML = message; // $ Alert[js/xss]
    });
}

function insertMessageFromAsyncThenCallback() {
  fetch("/api/message") // $ Source[js/xss]
    .then(async response => await response.json())
    .then(data => {
      document.body.innerHTML = data.message; // $ Alert[js/xss]
    });
}

function insertPromiseAllMessage() {
  Promise.all([
    fetch("/api/message") // $ Source[js/xss]
      .then(response => response.json())
  ]).then(([data]) => {
    document.body.innerHTML = data.message; // $ Alert[js/xss]
  });
}

function insertAliasedDataMessage() {
  fetch("/api/message") // $ Source[js/xss]
    .then(response => response.json())
    .then(data => {
      const payload = data;
      document.body.innerHTML = payload.message; // $ Alert[js/xss]
    });
}

function insertSanitizedHtml() {
  fetch("/api/message")
    .then(response => response.text())
    .then(text => {
      document.body.innerHTML = DOMPurify.sanitize(text);
    });
}

function assignInputValue() {
  fetch("/api/message")
    .then(response => response.text())
    .then(text => {
      document.querySelector("input").value = text;
    });
}

function assignSafeAttributes() {
  fetch("/api/message")
    .then(response => response.text())
    .then(text => {
      const element = document.querySelector("div");
      element.setAttribute("title", text);
      element.setAttribute("aria-label", text);
    });
}

function catchDoesNotInventResponseValue() {
  fetch("/api/message")
    .catch(error => {
      document.body.innerHTML = error.message;
    });
}

function finallyDoesNotInventResponseValue() {
  let text = "";
  fetch("/api/message")
    .finally(() => {
      document.body.innerHTML = text;
    });
}
