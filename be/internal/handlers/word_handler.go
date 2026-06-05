package handlers

import (
	"morsequest-backend/internal/services"
	"net/http"

	"github.com/gin-gonic/gin"
)

type WordHandler struct {
	wordService services.WordService
}

func NewWordHandler(wordService services.WordService) *WordHandler {
	return &WordHandler{wordService: wordService}
}

func (h *WordHandler) GetGameWords(c *gin.Context) {
	// Mengambil parameter URL (contoh: /api/game/words?difficulty=Gampang)
	difficulty := c.Query("difficulty")
	if difficulty == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Parameter difficulty wajib diisi"})
		return
	}

	words, err := h.wordService.GetWordsForGame(c.Request.Context(), difficulty)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Berhasil menarik soal",
		"data":    words,
	})
}