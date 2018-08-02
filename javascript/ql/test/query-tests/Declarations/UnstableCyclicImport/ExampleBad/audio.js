import { registerService } from './services';

export class AudioService {
  static create() {
    registerService(new AudioService());
  }
}
