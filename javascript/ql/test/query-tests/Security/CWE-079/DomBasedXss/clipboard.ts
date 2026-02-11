$("#foo").on("paste", paste);

function paste(e) {
    const { clipboardData } = e.originalEvent;
    if (!clipboardData) return;

    const text = clipboardData.getData('text/plain');
    const html = clipboardData.getData('text/html'); // $ Source
    if (!text && !html) return;

    e.preventDefault();

    const div = document.createElement('div');
    if (html) {
        div.innerHTML = html; // $ Alert
    } else {
        div.textContent = text;
    }
    document.body.append(div);
}

export function install(el: HTMLElement): void {
    el.addEventListener('paste', (e) => {
        $("#id").html(e.clipboardData.getData('text/html')); // $ Alert
    })
}

document.addEventListener('paste', (e) => {
    $("#id").html(e.clipboardData.getData('text/html')); // $ Alert
});

$("#foo").bind('paste', (e) => {
    $("#id").html(e.originalEvent.clipboardData.getData('text/html')); // $ Alert
});

(function () {
    let div = document.createElement("div");
    div.onpaste = function (e: ClipboardEvent) {
        const { clipboardData } = e;
        if (!clipboardData) return;

        const text = clipboardData.getData('text/plain');
        const html = clipboardData.getData('text/html'); // $ Source
        if (!text && !html) return;

        e.preventDefault();

        const div = document.createElement('div');
        if (html) {
            div.innerHTML = html; // $ Alert
        } else {
            div.textContent = text;
        }
        document.body.append(div);
    }
})();

async function getClipboardData(e: ClipboardEvent): Promise<Array<File | string>> {
    // Using a set to filter out duplicates. For some reason, dropping URLs duplicates them 3 times (for me)
    const dropItems = new Set<File | string>();
  
    // First get all files in the drop event
    if (e.clipboardData.files.length > 0) {
      // tslint:disable-next-line: prefer-for-of
      for (let i = 0; i < e.clipboardData.files.length; i++) {
        const file = e.clipboardData.files[i];
      }
    }
  
    if (e.clipboardData.types.includes('text/html')) {
      const droppedHtml = e.clipboardData.getData('text/html'); // $ Source
      const container = document.createElement('html');
      container.innerHTML = droppedHtml; // $ Alert
      const imgs = container.getElementsByTagName('img');
      if (imgs.length === 1) {
        const src = imgs[0].src;
        dropItems.add(src);
      }
    } else if (e.clipboardData.types.includes('text/plain')) {
      const plainText = e.clipboardData.getData('text/plain');
      // Check if text is an URL
      if (/^https?:\/\//i.test(plainText)) {
        dropItems.add(plainText);
      }
    }
  
    const imageItems = Array.from(dropItems);
    return imageItems;
  }

// inputevent
(function () {
    let div = document.createElement("div");
    div.addEventListener("beforeinput", function (e: InputEvent) {
        const { data, inputType, isComposing, dataTransfer } = e;
        if (!dataTransfer) return;

        const html = dataTransfer.getData('text/html'); // $ Source
        $("#id").html(html); // $ Alert
    });
})();