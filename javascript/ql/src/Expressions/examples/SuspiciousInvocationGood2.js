function error(msg) {
  console.log(msg);
}

function processResponse(response) {
  if (response.status === 200) {
    var err = processResponseText(response.responseText);
    if (err)
       throw err;
  } else {
    error("Unexpected response status " + response.status);
  }
}