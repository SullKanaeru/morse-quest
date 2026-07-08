package services

import (
	"context"
	"morsequest-backend/internal/models"
	"morsequest-backend/internal/repositories"
	"strings"
)

type ScoreService interface {
	SubmitScore(ctx context.Context, userID int, req models.ScoreSubmitRequest) error
}

type scoreService struct {
	scoreRepo repositories.ScoreRepository
}

func NewScoreService(scoreRepo repositories.ScoreRepository) ScoreService {
	return &scoreService{scoreRepo: scoreRepo}
}

func (s *scoreService) SubmitScore(ctx context.Context, userID int, req models.ScoreSubmitRequest) error {

	difficulty := strings.Title(strings.ToLower(req.Difficulty))

	if req.SignalPoints > 0 {
		if err := s.scoreRepo.UpdateUserSP(ctx, userID, req.SignalPoints); err != nil {
			return err
		}
	}

	if err := s.scoreRepo.UpsertGameStats(ctx, userID, difficulty, req.Streak, req.WordsCleared); err != nil {
		return err
	}

	return nil
}