import { AudioService } from './audio'
import { StoreService } from './store';

export { registerService } from './service_base'

export const services = [
  AudioService,
  StoreService
];