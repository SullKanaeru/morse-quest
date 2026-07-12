package handlers

import (
	"morsequest-backend/internal/models"
	"morsequest-backend/internal/services"
	"net/http"

	"github.com/gin-gonic/gin"
)

type ScoreHandler struct {
	scoreService services.ScoreService
}

func NewScoreHandler(scoreService services.ScoreService) *ScoreHandler {
	return &ScoreHandler{scoreService: scoreService}
}

func (h *ScoreHandler) Submit(c *gin.Context) {
	var req models.ScoreSubmitRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Data request tidak valid"})
		return
	}

	userIDAny, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}
	userID := userIDAny.(int)

	err := h.scoreService.SubmitScore(c.Request.Context(), userID, req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal menyimpan skor: " + err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Skor dan statistik berhasil disimpan!",
	})
}