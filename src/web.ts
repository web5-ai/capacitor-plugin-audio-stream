import { WebPlugin } from '@capacitor/core';

import type { AudioStreamPlugin } from './definitions';

export class AudioStreamWeb extends WebPlugin implements AudioStreamPlugin {
  async load(): Promise<void> {
    throw new Error('Method not implemented.');
  }

  async start(): Promise<void> {
    throw new Error('Method not implemented.');
  }

  async stop(): Promise<void> {
    throw new Error('Method not implemented.');
  }
}
