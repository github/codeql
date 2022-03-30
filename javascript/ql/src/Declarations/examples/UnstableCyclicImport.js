// services.js
import { AudioService } from './audio'
import { StoreService } from './store';

export const services = [
  AudioService,
  StoreService
];

export function registerService(service) {
  /* ... */
}

// audio.js
import { registerService } from './services';

export class AudioService {
  static create() {
    registerService(new AudioService());
  }
}
