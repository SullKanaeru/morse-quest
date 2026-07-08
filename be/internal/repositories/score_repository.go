package repositories

import (
	"context"
	"database/sql"
)

type ScoreRepository interface {
	UpdateUserSP(ctx context.Context, userID int, spToAdd int) error
	UpsertGameStats(ctx context.Context, userID int, difficulty string, streak int, wordsCleared int) error
}

type scoreRepository struct {
	db *sql.DB
}

func NewScoreRepository(db *sql.DB) ScoreRepository {
	return &scoreRepository{db: db}
}

func (r *scoreRepository) UpdateUserSP(ctx context.Context, userID int, spToAdd int) error {
	query := `UPDATE users SET total_sp = total_sp + $1, updated_at = NOW() WHERE id = $2`
	_, err := r.db.ExecContext(ctx, query, spToAdd, userID)
	return err
}

func (r *scoreRepository) UpsertGameStats(ctx context.Context, userID int, difficulty string, streak int, wordsCleared int) error {
	query := `
		INSERT INTO user_game_stats (user_id, difficulty, highest_streak, total_words_cleared, updated_at)
		VALUES ($1, $2, $3, $4, NOW())
		ON CONFLICT (user_id, difficulty) 
		DO UPDATE SET 
			highest_streak = GREATEST(user_game_stats.highest_streak, EXCLUDED.highest_streak),
			total_words_cleared = user_game_stats.total_words_cleared + EXCLUDED.total_words_cleared,
			updated_at = NOW()
	`
	_, err := r.db.ExecContext(ctx, query, userID, difficulty, streak, wordsCleared)
	return err
}