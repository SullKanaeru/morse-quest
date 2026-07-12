package handlers

import (
	"fmt"
	"net/http"
	"path/filepath"
	"time"

	"morsequest-backend/internal/models"
	"morsequest-backend/internal/services"

	"github.com/gin-gonic/gin"
)

type UserHandler struct {
	userService services.UserService
}

func NewUserHandler(userService services.UserService) *UserHandler {
	return &UserHandler{userService: userService}
}

func (h *UserHandler) GetProfile(c *gin.Context) {
	userIDAny, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}
	userID := userIDAny.(int)

	user, err := h.userService.GetProfile(c.Request.Context(), userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal mengambil profil: " + err.Error()})
		return
	}
	if user == nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User tidak ditemukan"})
		return
	}

	// Jangan kirim password hash ke frontend
	user.PasswordHash = ""

	c.JSON(http.StatusOK, gin.H{
		"message": "Berhasil",
		"data":    user,
	})
}

type BuyHintRequest struct {
	Amount int `json:"amount" binding:"required"`
	Cost   int `json:"cost" binding:"required"`
}

func (h *UserHandler) BuyHint(c *gin.Context) {
	userIDAny, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}
	userID := userIDAny.(int)

	var req BuyHintRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request format"})
		return
	}

	err := h.userService.BuyHint(c.Request.Context(), userID, req.Amount, req.Cost)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Berhasil membeli hint"})
}

func (h *UserHandler) UseHint(c *gin.Context) {
	userIDAny, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}
	userID := userIDAny.(int)

	err := h.userService.UseHint(c.Request.Context(), userID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Berhasil menggunakan hint"})
}

func (h *UserHandler) UpdateProfile(c *gin.Context) {
	userIDAny, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}
	userID := userIDAny.(int)

	var req models.UpdateProfileRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request format"})
		return
	}

	err := h.userService.UpdateProfile(c.Request.Context(), userID, req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Berhasil memperbarui profil"})
}

func (h *UserHandler) UploadAvatar(c *gin.Context) {
	userIDAny, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}
	userID := userIDAny.(int)

	file, err := c.FormFile("avatar")
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Gagal menerima file: " + err.Error()})
		return
	}

	ext := filepath.Ext(file.Filename)
	filename := fmt.Sprintf("%d_%d%s", userID, time.Now().Unix(), ext)
	uploadPath := filepath.Join("uploads", filename)

	if err := c.SaveUploadedFile(file, uploadPath); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal menyimpan file: " + err.Error()})
		return
	}

	avatarUrl := "http://10.0.2.2:3000/uploads/" + filename

	// Update user db avatarUrl
	err = h.userService.UpdateProfile(c.Request.Context(), userID, models.UpdateProfileRequest{
		AvatarUrl: avatarUrl,
	})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal mengupdate profil: " + err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message":   "Berhasil mengunggah avatar",
		"avatarUrl": avatarUrl,
	})
}

