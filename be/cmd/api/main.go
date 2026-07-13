package main

import (
	"database/sql"
	"log"
	"os"
	"morsequest-backend/internal/handlers"
	"morsequest-backend/internal/repositories"
	"morsequest-backend/internal/routes"
	"morsequest-backend/internal/services"

	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"
)

func main() {
	dbUrl := os.Getenv("DB_URL")
	if dbUrl == "" {
		// Fallback for local development if .env is missing
		dbUrl = "postgres://postgres:postgres@localhost:5432/morsequest-db?sslmode=disable"
	}
	db, err := sql.Open("postgres", dbUrl)
	if err != nil {
		log.Fatal(err)
	}

	userRepo := repositories.NewUserRepository(db)
	authService := services.NewAuthService(userRepo)
	authHandler := handlers.NewAuthHandler(authService)
	
	wordRepo := repositories.NewWordRepository(db)
	wordService := services.NewWordService(wordRepo)
	wordHandler := handlers.NewWordHandler(wordService)

	scoreRepo := repositories.NewScoreRepository(db)
	scoreService := services.NewScoreService(scoreRepo)
	scoreHandler := handlers.NewScoreHandler(scoreService)

	userService := services.NewUserService(userRepo)
	userHandler := handlers.NewUserHandler(userService)

	r := gin.Default()

	r.Static("/uploads", "./uploads")

	routes.SetupRoutes(r, authHandler, wordHandler, scoreHandler, userHandler)

	log.Fatal(r.Run(":3000"))
}