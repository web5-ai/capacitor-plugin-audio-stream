export interface AudioStreamPlugin {
  load(): Promise<any>
  start(): Promise<any>
  stop(): Promise<any>
}
