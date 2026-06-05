package models

type Word struct {
	ID         int    `json:"id"`
	Word       string `json:"word"`
	Difficulty string `json:"difficulty"` // Gampang, Sedang, Sulit
}