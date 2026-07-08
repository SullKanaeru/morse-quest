package routes

import (
	"morsequest-backend/internal/handlers"
	"morsequest-backend/internal/middleware"
	"net/http"

	"github.com/gin-gonic/gin"
)

func SetupRoutes(r *gin.Engine, authHandler *handlers.AuthHandler, wordHandler *handlers.WordHandler, scoreHandler *handlers.ScoreHandler) {

	api := r.Group("/api")

	authGroup := api.Group("/auth")
	{
		authGroup.POST("/register", authHandler.Register)
		authGroup.POST("/login", authHandler.Login)
	}

	userGroup := api.Group("/user")
	userGroup.Use(middleware.Protected())
	{
		userGroup.GET("/profile", func(c *gin.Context) {
			c.JSON(http.StatusOK, gin.H{
				"message": "Selamat! Kamu berhasil masuk ke area rahasia dengan token yang valid.",
			})
		})
	}

	gameGroup := api.Group("/game")
	gameGroup.Use(middleware.Protected())
	{
		gameGroup.GET("/words", wordHandler.GetGameWords) 

		gameGroup.POST("/score", scoreHandler.Submit)
	}
}
