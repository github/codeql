function paste(e) {
    const { clipboardData } = e.originalEvent;
    if (!clipboardData) return;

    const text = clipboardData.getData('text/plain');
    const html = clipboardData.getData('text/html');
    if (!text && !html) return;

    e.preventDefault();

    const div = document.createElement('div');
    if (html) {
        div.innerHTML = html;
    } else {
        div.textContent = text;
    }
    document.body.append(div);
}