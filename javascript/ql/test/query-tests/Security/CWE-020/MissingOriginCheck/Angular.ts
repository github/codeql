import { Component, HostListener } from '@angular/core';

@Component({ selector: 'app-root' })
class AngularComponent {
  // Angular registers this as a `window` message handler via the decorator,
  // equivalent to `window.addEventListener('message', ...)`.
  @HostListener('window:message', ['$event'])
  onWindowMessage(event: MessageEvent): void { // $ Alert - no origin check
    eval(event.data);
  }

  @HostListener('document:message', ['$event'])
  onDocumentMessage(event: MessageEvent): void { // $ Alert - no origin check
    eval(event.data);
  }

  @HostListener('window:message', ['$event'])
  onCheckedMessage(event: MessageEvent): void { // OK - has an origin check
    if (event.origin === 'https://www.example.com') {
      eval(event.data);
    }
  }

  // Not a message event, so it is not a postMessage handler.
  @HostListener('window:resize', ['$event'])
  onResize(event: MessageEvent): void { // OK - not a message handler
    eval(event.data);
  }
}
