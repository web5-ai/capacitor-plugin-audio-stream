import { WebPlugin } from '@capacitor/core';

import type { AudioStreamPlugin } from './definitions';

export class AudioStreamWeb extends WebPlugin implements AudioStreamPlugin {
  async load(): Promise<any> {
    return { success: true };
  }

  async start(): Promise<any> {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      return { success: true, stream };
    } catch (error) {
      console.error('Error capturing audio: ', error);
      return { success: false, error: (error as Error).message };
    }
  }

  async stop(): Promise<any> {
    // Web version will not do this since it's handled by the browser
    return { success: true };
  }
}
