import { AudioService } from './audio'
import { StoreService } from './store';

export const services = [
  AudioService,
  StoreService
];

export function registerService(service) {
  /* ... */
}