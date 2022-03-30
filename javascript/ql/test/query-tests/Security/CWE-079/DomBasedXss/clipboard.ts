$("#foo").on("paste", paste);

function paste(e) {
    const { clipboardData } = e.originalEvent;
    if (!clipboardData) return;

    const text = clipboardData.getData('text/plain');
    const html = clipboardData.getData('text/html');
    if (!text && !html) return;

    e.preventDefault();

    const div = document.createElement('div');
    if (html) {
        div.innerHTML = html; // NOT OK
    } else {
        div.textContent = text;
    }
    document.body.append(div);
}

export function install(el: HTMLElement): void {
    el.addEventListener('paste', (e) => {
        $("#id").html(e.clipboardData.getData('text/html')); // NOT OK    
    })
}

document.addEventListener('paste', (e) => {
    $("#id").html(e.clipboardData.getData('text/html')); // NOT OK
});

$("#foo").bind('paste', (e) => {
    $("#id").html(e.originalEvent.clipboardData.getData('text/html')); // NOT OK
});