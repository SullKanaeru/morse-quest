package models

import "time"

type User struct {
	ID           int64     `json:"id" db:"id"`
	Username     string    `json:"username" db:"username"`
	Email        string    `json:"email" db:"email"`
	PasswordHash string    `json:"-" db:"password_hash"`
	AvatarUrl    string    `json:"avatar_url" db:"avatar_url"`
	TotalSP      int       `json:"total_sp" db:"total_sp"`
	Hints        int       `json:"hints" db:"hints"`
	CreatedAt    time.Time `json:"created_at" db:"created_at"`
	UpdatedAt    time.Time `json:"updated_at" db:"updated_at"`
}

type UpdateProfileRequest struct {
	Username  string `json:"username" validate:"required,min=3"`
	AvatarUrl string `json:"avatar_url" validate:"required"`
}

type AuthRequest struct {
	Email    string `json:"email" validate:"required,email"`
	Password string `json:"password" validate:"required,min=6"`
}

type RegisterRequest struct {
	Email    string `json:"email" validate:"required,email"`
	Username string `json:"username" validate:"required,min=3"`
	Password string `json:"password" validate:"required,min=6"`
}