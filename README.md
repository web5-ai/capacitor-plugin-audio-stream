# @web5-team/capacitor-plugin-audio-stream

audio stream

## Install

```bash
npm install @web5-team/capacitor-plugin-audio-stream
npx cap sync
```

## API

<docgen-index>

* [`load()`](#load)
* [`start()`](#start)
* [`stop()`](#stop)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### load()

```typescript
load() => any
```

**Returns:** <code>any</code>

--------------------


### start()

```typescript
start() => any
```

**Returns:** <code>any</code>

--------------------


### stop()

```typescript
stop() => any
```

**Returns:** <code>any</code>

--------------------

</docgen-api>

## Usage

```typescript
import { AudioStream } from '@web5-team/capacitor-plugin-audio-stream'

window.addEventListener('audioData', (data) => {
  console.log(data) // { success: true, data: 'base64...' }
})

AudioStream.start()
```
