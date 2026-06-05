package services

import (
	"context"
	"errors"
	"time"
	"morsequest-backend/internal/models"
	"morsequest-backend/internal/repositories"

	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"
)

var jwtSecret = []byte("SUPER_SECRET_KEY_MORSEQUEST") // Pindahkan ke .env di production

type AuthService interface {
	Register(ctx context.Context, req models.AuthRequest) (*models.User, error)
	Login(ctx context.Context, req models.AuthRequest) (string, *models.User, error)
}

type authService struct {
	userRepo repositories.UserRepository
}

func NewAuthService(userRepo repositories.UserRepository) AuthService {
	return &authService{userRepo: userRepo}
}

func (s *authService) Register(ctx context.Context, req models.AuthRequest) (*models.User, error) {
	// Cek apakah username sudah ada
	existingUser, _ := s.userRepo.GetUserByUsername(ctx, req.Username)
	if existingUser != nil {
		return nil, errors.New("username sudah digunakan")
	}

	// Hash password
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		return nil, err
	}

	user := &models.User{
		Username:     req.Username,
		PasswordHash: string(hashedPassword),
	}

	if err := s.userRepo.CreateUser(ctx, user); err != nil {
		return nil, err
	}

	return user, nil
}

func (s *authService) Login(ctx context.Context, req models.AuthRequest) (string, *models.User, error) {
	// Ambil user dari database
	user, err := s.userRepo.GetUserByUsername(ctx, req.Username)
	if err != nil || user == nil {
		return "", nil, errors.New("username atau password salah")
	}

	// Bandingkan password
	err = bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(req.Password))
	if err != nil {
		return "", nil, errors.New("username atau password salah")
	}

	// Generate JWT Token
	claims := jwt.MapClaims{
		"user_id": user.ID,
		"exp":     time.Now().Add(time.Hour * 72).Unix(), // Token berlaku 72 jam
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString(jwtSecret)
	if err != nil {
		return "", nil, err
	}

	return tokenString, user, nil
}