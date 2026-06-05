package main

import (
	"database/sql"
	"log"
	"morsequest-backend/internal/handlers"
	"morsequest-backend/internal/repositories"
	"morsequest-backend/internal/routes"
	"morsequest-backend/internal/services"

	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"
)

func main() {
	// 1. Inisialisasi Database
	db, err := sql.Open("postgres", "postgres://postgres:postgres@localhost:5432/morsequest-db?sslmode=disable")
	if err != nil {
		log.Fatal(err)
	}

	// 2. Setup Dependency Injection
	userRepo := repositories.NewUserRepository(db)
	authService := services.NewAuthService(userRepo)
	authHandler := handlers.NewAuthHandler(authService)
	
	wordRepo := repositories.NewWordRepository(db)
	wordService := services.NewWordService(wordRepo)
	wordHandler := handlers.NewWordHandler(wordService)

	// 3. Inisialisasi Gin Engine
	r := gin.Default()

	// 4. Daftarkan Routes
	routes.SetupRoutes(r, authHandler, wordHandler)

	// 5. Jalankan Server di port 3000
	log.Fatal(r.Run(":3000"))
}