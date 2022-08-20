async function loadMessage() {
    const query = new URLSearchParams(location.search);
    const url = '/api/messages/' + query.get('message_id');
    const data = await (await fetch(url)).json();
    document.getElementById('message').innerHTML = data.html;
}
