package services

import (
	"context"
	"errors"
	"morsequest-backend/internal/models"
	"morsequest-backend/internal/repositories"
)

type UserService interface {
	GetProfile(ctx context.Context, userID int) (*models.User, error)
	BuyHint(ctx context.Context, userID int, amount int, cost int) error
	UseHint(ctx context.Context, userID int) error
	UpdateProfile(ctx context.Context, userID int, req models.UpdateProfileRequest) error
}

type userService struct {
	userRepo repositories.UserRepository
}

func NewUserService(userRepo repositories.UserRepository) UserService {
	return &userService{userRepo: userRepo}
}

func (s *userService) GetProfile(ctx context.Context, userID int) (*models.User, error) {
	return s.userRepo.GetUserByID(ctx, userID)
}

func (s *userService) BuyHint(ctx context.Context, userID int, amount int, cost int) error {
	user, err := s.userRepo.GetUserByID(ctx, userID)
	if err != nil {
		return err
	}
	if user == nil {
		return errors.New("user not found")
	}
	if user.TotalSP < cost {
		return errors.New("insufficient SP")
	}

	return s.userRepo.UpdateSPAndHints(ctx, userID, -cost, amount)
}

func (s *userService) UseHint(ctx context.Context, userID int) error {
	user, err := s.userRepo.GetUserByID(ctx, userID)
	if err != nil {
		return err
	}
	if user == nil {
		return errors.New("user not found")
	}
	if user.Hints < 1 {
		return errors.New("insufficient hints")
	}

	return s.userRepo.UpdateSPAndHints(ctx, userID, 0, -1)
}

func (s *userService) UpdateProfile(ctx context.Context, userID int, req models.UpdateProfileRequest) error {
	user, err := s.userRepo.GetUserByID(ctx, userID)
	if err != nil {
		return err
	}
	if user == nil {
		return errors.New("user not found")
	}

	return s.userRepo.UpdateProfile(ctx, userID, req.Username, req.AvatarUrl)
}
