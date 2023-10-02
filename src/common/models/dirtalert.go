package models

type DirtAlert struct {
    DeviceId string `json:"deviceId"`
    Timestamp int64 `json:"timestamp"`
    Level float32 `json:"level"`
}
