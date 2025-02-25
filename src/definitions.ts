export interface AudioStreamPlugin {
  load(): Promise<void>
  start(): Promise<void>
  stop(): Promise<void>
}
