package models

type DirtAlert struct {
    DeviceId string `json:"deviceId"`
    Timestamp string `json:"timestamp"`
    Level float32 `json:"level"`
}
