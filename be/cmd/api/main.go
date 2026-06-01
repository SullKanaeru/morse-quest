package main

import (
	"log"
	"net/http"
	"os"

	"morsequest-backend/internal/config" // Sesuaikan dengan nama modul kamu

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {
	// 1. Load file .env
	err := godotenv.Load()
	if err != nil {
		log.Println("Peringatan: File .env tidak ditemukan, menggunakan environment default sistem")
	}

	// 2. Inisialisasi Database
	config.ConnectDatabase()

	// 3. Setup Router
	router := gin.Default()

	// Route Test
	router.GET("/ping", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "pong",
			"status":  "Server MorseQuest Berjalan dengan Database PostgreSQL!",
		})
	})

	// 4. Jalankan Server
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	log.Printf("Server berjalan di http://localhost:%s\n", port)
	if err := router.Run(":" + port); err != nil {
		log.Fatalf("Gagal menjalankan server: %v", err)
	}
}