package models

type ScoreSubmitRequest struct {
	Difficulty   string `json:"difficulty" binding:"required"`
	SignalPoints int    `json:"signal_points"`
	Streak       int    `json:"streak"`
	WordsCleared int    `json:"words_cleared"`
}