import { WebPlugin } from '@capacitor/core';

import type { AudioStreamPlugin } from './definitions';

export class AudioStreamWeb extends WebPlugin implements AudioStreamPlugin {
  async load(): Promise<any> {
    throw new Error('Method not implemented.');
  }

  async start(): Promise<any> {
    throw new Error('Method not implemented.');
  }

  async stop(): Promise<any> {
    throw new Error('Method not implemented.');
  }
}
