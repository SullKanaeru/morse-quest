package config

import (
	"log"
	"os"

	"morsequest-backend/internal/models"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var DB *gorm.DB

func ConnectDatabase() {
	dsn := os.Getenv("DB_URL")
	if dsn == "" {
		log.Fatal("Variabel DB_URL belum di-set di file .env")
	}

	database, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatalf("Gagal terhubung ke database PostgreSQL: %v", err)
	}

	log.Println("Berhasil terhubung ke PostgreSQL!")

	// Auto Migrate akan otomatis membuat atau memperbarui tabel User
	err = database.AutoMigrate(&models.User{})
	if err != nil {
		log.Fatalf("Gagal melakukan migrasi database: %v", err)
	}
	
	log.Println("Migrasi tabel berhasil!")
	DB = database
}