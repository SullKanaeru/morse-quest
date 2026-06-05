package repositories

import (
	"context"
	"database/sql"
	"morsequest-backend/internal/models"
)

type WordRepository interface {
	GetRandomWords(ctx context.Context, difficulty string, limit int) ([]models.Word, error)
}

type wordRepository struct {
	db *sql.DB
}

func NewWordRepository(db *sql.DB) WordRepository {
	return &wordRepository{db: db}
}

func (r *wordRepository) GetRandomWords(ctx context.Context, difficulty string, limit int) ([]models.Word, error) {
	query := `SELECT id, word, difficulty FROM words_dictionary WHERE difficulty = $1 ORDER BY RANDOM() LIMIT $2`
	
	rows, err := r.db.QueryContext(ctx, query, difficulty, limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var words []models.Word
	for rows.Next() {
		var w models.Word
		if err := rows.Scan(&w.ID, &w.Word, &w.Difficulty); err != nil {
			return nil, err
		}
		words = append(words, w)
	}

	return words, nil
}