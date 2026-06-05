package services

import (
	"context"
	"errors"
	"morsequest-backend/internal/models"
	"morsequest-backend/internal/repositories"
	"strings"
)

type WordService interface {
	GetWordsForGame(ctx context.Context, difficulty string) ([]models.Word, error)
}

type wordService struct {
	wordRepo repositories.WordRepository
}

func NewWordService(wordRepo repositories.WordRepository) WordService {
	return &wordService{wordRepo: wordRepo}
}

func (s *wordService) GetWordsForGame(ctx context.Context, difficulty string) ([]models.Word, error) {
	// Normalisasi input agar case-insensitive (misal: "gampang" jadi "Gampang")
	diff := strings.Title(strings.ToLower(difficulty))

	var limit int
	switch diff {
	case "Gampang":
		limit = 5
	case "Sedang":
		limit = 10
	case "Sulit":
		limit = 15
	default:
		return nil, errors.New("tingkat kesulitan tidak valid (pilih: Gampang, Sedang, Sulit)")
	}

	return s.wordRepo.GetRandomWords(ctx, diff, limit)
}