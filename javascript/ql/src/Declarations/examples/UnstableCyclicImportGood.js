// service_base.js
export function registerService(service) {
  /* ... */
}

// services.js
import { AudioService } from './audio'
import { StoreService } from './store';

export { registerService } from './service_base'

export const services = [
  AudioService,
  StoreService
];

// audio.js
import { registerService } from './service_base';

export class AudioService {
  static create() {
    registerService(new AudioService());
  }
}
