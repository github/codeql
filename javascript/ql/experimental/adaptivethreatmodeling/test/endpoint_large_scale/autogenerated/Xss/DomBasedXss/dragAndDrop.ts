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

(function () {
    let div = document.createElement("div");
    div.ondrop = function (e: DragEvent) {
        const { dataTransfer } = e;
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
})();

async function getDropData(e: DragEvent): Promise<Array<File | string>> {
    // Using a set to filter out duplicates. For some reason, dropping URLs duplicates them 3 times (for me)
    const dropItems = new Set<File | string>();
  
    // First get all files in the drop event
    if (e.dataTransfer.files.length > 0) {
      // tslint:disable-next-line: prefer-for-of
      for (let i = 0; i < e.dataTransfer.files.length; i++) {
        const file = e.dataTransfer.files[i];
      }
    }
  
    if (e.dataTransfer.types.includes('text/html')) {
      const droppedHtml = e.dataTransfer.getData('text/html');
      const container = document.createElement('html');
      container.innerHTML = droppedHtml;
      const imgs = container.getElementsByTagName('img');
      if (imgs.length === 1) {
        const src = imgs[0].src;
        dropItems.add(src);
      }
    } else if (e.dataTransfer.types.includes('text/plain')) {
      const plainText = e.dataTransfer.getData('text/plain');
      // Check if text is an URL
      if (/^https?:\/\//i.test(plainText)) {
        dropItems.add(plainText);
      }
    }
  
    const imageItems = Array.from(dropItems);
    return imageItems;
  }