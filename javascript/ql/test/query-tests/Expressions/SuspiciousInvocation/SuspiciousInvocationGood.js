function error(msg) {
  console.log(msg);
}

function processResponse(response) {
  if (response.status === 200) {
    let error = processResponseText(response.responseText);
    if (error)
       throw error;
  } else {
    error("Unexpected response status " + response.status);
  }
}