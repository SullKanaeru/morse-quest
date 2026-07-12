CREATE TABLE IF NOT EXISTS words_dictionary (
    id SERIAL PRIMARY KEY,
    word VARCHAR(50) UNIQUE NOT NULL,
    morse_code TEXT NOT NULL,
    difficulty VARCHAR(20) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);