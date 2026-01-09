-- Bookworm Database Schema
-- SQLite database for storing scanned book information

-- Books table - stores book metadata from ISBN scans
CREATE TABLE IF NOT EXISTS Books (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    ISBN TEXT NOT NULL UNIQUE,
    Title TEXT NOT NULL,
    PublishDate TEXT,
    Publishers TEXT,
    NumberOfPages INTEGER,
    CoverUrl TEXT,
    FirstSentence TEXT,
    ScannedAt TEXT NOT NULL,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Index on ISBN for fast lookups
CREATE INDEX IF NOT EXISTS idx_books_isbn ON Books(ISBN);

-- Index on Title for searching
CREATE INDEX IF NOT EXISTS idx_books_title ON Books(Title);

-- Index on ScannedAt for chronological queries
CREATE INDEX IF NOT EXISTS idx_books_scanned ON Books(ScannedAt);

-- Trigger to update UpdatedAt timestamp on record modification
CREATE TRIGGER IF NOT EXISTS update_books_timestamp 
AFTER UPDATE ON Books
BEGIN
    UPDATE Books SET UpdatedAt = CURRENT_TIMESTAMP WHERE Id = NEW.Id;
END;
