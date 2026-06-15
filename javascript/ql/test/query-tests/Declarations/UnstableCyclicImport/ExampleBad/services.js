import { AudioService } from './audio'
import { StoreService } from './store';

export const services = [
  AudioService, // $ Alert
  StoreService
];

export function registerService(service) {
  /* ... */
}