package models

import "time"

// User merepresentasikan tabel users di database
type User struct {
	// Kita gunakan BIGSERIAL untuk ID agar kapasitasnya besar dan auto-increment
	ID        uint64    `gorm:"primaryKey;autoIncrement;type:bigserial" json:"id"`
	Username  string    `gorm:"unique;not null;type:varchar(100)" json:"username"`
	Password  string    `gorm:"not null" json:"-"` // json:"-" memastikan password tidak pernah bocor ke response API
	Rank      string    `gorm:"default:'Kadet Morse';type:varchar(50)" json:"rank"`
	Level     int       `gorm:"default:1" json:"level"`
	Stars     int       `gorm:"default:0" json:"stars"`
	Coins     int       `gorm:"default:0" json:"coins"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}