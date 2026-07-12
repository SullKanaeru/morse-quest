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
	GetUserByEmail(ctx context.Context, email string) (*models.User, error)
	GetUserByID(ctx context.Context, id int) (*models.User, error)
	UpdateSPAndHints(ctx context.Context, id int, spDelta int, hintsDelta int) error
	UpdateProfile(ctx context.Context, id int, username string, avatarUrl string) error
}

type userRepository struct {
	db *sql.DB
}

func NewUserRepository(db *sql.DB) UserRepository {
	return &userRepository{db: db}
}

func (r *userRepository) CreateUser(ctx context.Context, user *models.User) error {
	query := `
		INSERT INTO users (email, username, password_hash, hints) 
		VALUES ($1, $2, $3, 10) 
		RETURNING id, total_sp, hints, created_at, updated_at`

	err := r.db.QueryRowContext(ctx, query, user.Email, user.Username, user.PasswordHash).
		Scan(&user.ID, &user.TotalSP, &user.Hints, &user.CreatedAt, &user.UpdatedAt)
	
	if err != nil {
		return err
	}
	return nil
}

func (r *userRepository) GetUserByUsername(ctx context.Context, username string) (*models.User, error) {
	var user models.User
	query := `SELECT id, email, username, password_hash, avatar_url, total_sp, hints, created_at, updated_at FROM users WHERE username = $1`
	
	err := r.db.QueryRowContext(ctx, query, username).
		Scan(&user.ID, &user.Email, &user.Username, &user.PasswordHash, &user.AvatarUrl, &user.TotalSP, &user.Hints, &user.CreatedAt, &user.UpdatedAt)
	
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, nil
		}
		return nil, err
	}
	return &user, nil
}

func (r *userRepository) GetUserByEmail(ctx context.Context, email string) (*models.User, error) {
	var user models.User
	query := `SELECT id, email, username, password_hash, avatar_url, total_sp, hints, created_at, updated_at FROM users WHERE email = $1`
	
	err := r.db.QueryRowContext(ctx, query, email).
		Scan(&user.ID, &user.Email, &user.Username, &user.PasswordHash, &user.AvatarUrl, &user.TotalSP, &user.Hints, &user.CreatedAt, &user.UpdatedAt)
	
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, nil
		}
		return nil, err
	}
	return &user, nil
}

func (r *userRepository) GetUserByID(ctx context.Context, id int) (*models.User, error) {
	var user models.User
	query := `SELECT id, email, username, password_hash, avatar_url, total_sp, hints, created_at, updated_at FROM users WHERE id = $1`
	
	err := r.db.QueryRowContext(ctx, query, id).
		Scan(&user.ID, &user.Email, &user.Username, &user.PasswordHash, &user.AvatarUrl, &user.TotalSP, &user.Hints, &user.CreatedAt, &user.UpdatedAt)
	
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, nil
		}
		return nil, err
	}
	return &user, nil
}

func (r *userRepository) UpdateSPAndHints(ctx context.Context, id int, spDelta int, hintsDelta int) error {
	query := `
		UPDATE users 
		SET total_sp = total_sp + $1, 
		    hints = hints + $2,
		    updated_at = NOW() 
		WHERE id = $3`
	_, err := r.db.ExecContext(ctx, query, spDelta, hintsDelta, id)
	return err
}

func (r *userRepository) UpdateProfile(ctx context.Context, id int, username string, avatarUrl string) error {
	query := `
		UPDATE users 
		SET username = $1, 
		    avatar_url = $2,
		    updated_at = NOW() 
		WHERE id = $3`
	_, err := r.db.ExecContext(ctx, query, username, avatarUrl, id)
	return err
}