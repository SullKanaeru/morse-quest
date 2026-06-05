package repositories

import (
	"context"
	"database/sql"
	"errors"
	"morsequest-backend/internal/models"
)

type UserRepository interface {
	CreateUser(ctx context.Context, user *models.User) error
	GetUserByUsername(ctx context.Context, username string) (*models.User, error)
}

type userRepository struct {
	db *sql.DB
}

func NewUserRepository(db *sql.DB) UserRepository {
	return &userRepository{db: db}
}

func (r *userRepository) CreateUser(ctx context.Context, user *models.User) error {
	query := `
		INSERT INTO users (username, password_hash) 
		VALUES ($1, $2) 
		RETURNING id, total_sp, created_at, updated_at`

	err := r.db.QueryRowContext(ctx, query, user.Username, user.PasswordHash).
		Scan(&user.ID, &user.TotalSP, &user.CreatedAt, &user.UpdatedAt)
	
	if err != nil {
		return err
	}
	return nil
}

func (r *userRepository) GetUserByUsername(ctx context.Context, username string) (*models.User, error) {
	var user models.User
	query := `SELECT id, username, password_hash, total_sp, created_at, updated_at FROM users WHERE username = $1`
	
	err := r.db.QueryRowContext(ctx, query, username).
		Scan(&user.ID, &user.Username, &user.PasswordHash, &user.TotalSP, &user.CreatedAt, &user.UpdatedAt)
	
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, nil // User tidak ditemukan
		}
		return nil, err
	}
	return &user, nil
}