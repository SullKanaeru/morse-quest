package routes

import (
	"morsequest-backend/internal/handlers"
	"morsequest-backend/internal/middleware"

	"github.com/gin-gonic/gin"
)

func SetupRoutes(r *gin.Engine, authHandler *handlers.AuthHandler, wordHandler *handlers.WordHandler, scoreHandler *handlers.ScoreHandler, userHandler *handlers.UserHandler) {

	api := r.Group("/api")

	authGroup := api.Group("/auth")
	{
		authGroup.POST("/register", authHandler.Register)
		authGroup.POST("/login", authHandler.Login)
	}

	userGroup := api.Group("/user")
	userGroup.Use(middleware.Protected())
	{
		userGroup.GET("/profile", userHandler.GetProfile)
		userGroup.PUT("/profile", userHandler.UpdateProfile)
		userGroup.POST("/avatar", userHandler.UploadAvatar)
		userGroup.POST("/buy-hint", userHandler.BuyHint)
	}

	gameGroup := api.Group("/game")
	gameGroup.Use(middleware.Protected())
	{
		gameGroup.GET("/words", wordHandler.GetGameWords) 

		gameGroup.POST("/score", scoreHandler.Submit)
		gameGroup.POST("/use-hint", userHandler.UseHint)
	}
}
