$("#foo").on("drop", drop);

function drop(e) {
    const { dataTransfer } = e.originalEvent;
    if (!dataTransfer) return;

    const text = dataTransfer.getData('text/plain');
    const html = dataTransfer.getData('text/html');
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
    el.addEventListener('drop', (e) => {
        $("#id").html(e.dataTransfer.getData('text/html')); // NOT OK    
    })
}

document.addEventListener('drop', (e) => {
    $("#id").html(e.dataTransfer.getData('text/html')); // NOT OK
});

$("#foo").bind('drop', (e) => {
    $("#id").html(e.originalEvent.dataTransfer.getData('text/html')); // NOT OK
});