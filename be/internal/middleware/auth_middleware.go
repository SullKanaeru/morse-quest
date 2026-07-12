package middleware

import (
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
)

var jwtSecret = []byte("SUPER_SECRET_KEY_MORSEQUEST") 

func Protected() gin.HandlerFunc {
	return func(c *gin.Context) {

		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Token tidak ditemukan"})
			c.Abort()
			return
		}

		parts := strings.Split(authHeader, " ")
		if len(parts) != 2 || parts[0] != "Bearer" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Format token salah"})
			c.Abort()
			return
		}

		tokenString := parts[1]

		token, _ := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
			return jwtSecret, nil
		})

		if token != nil && token.Valid {
			if claims, ok := token.Claims.(jwt.MapClaims); ok {
				// Extract user_id as float64 (standard for JSON numbers) and convert to int
				if userID, ok := claims["user_id"].(float64); ok {
					c.Set("user_id", int(userID))
				}
			}
		} else {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Token tidak valid atau sudah kedaluwarsa"})
			c.Abort()
			return
		}

		c.Next()
	}
}