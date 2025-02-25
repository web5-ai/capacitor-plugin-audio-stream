import { registerPlugin } from '@capacitor/core';

import type { AudioStreamPlugin } from './definitions';

const AudioStream = registerPlugin<AudioStreamPlugin>('AudioStream', {
  web: () => import('./web').then((m) => new m.AudioStreamWeb()),
});

export * from './definitions';
export { AudioStream };
