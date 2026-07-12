package models

type Word struct {
	ID         int    `json:"id"`
	Word       string `json:"word"`
	MorseCode  string `json:"morse_code"`
	Difficulty string `json:"difficulty"`
}