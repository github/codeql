import { registerService } from './service_base';

export class AudioService {
  static create() {
    registerService(new AudioService());
  }
}