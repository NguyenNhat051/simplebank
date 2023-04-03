package token

import (
	"errors"
	"time"

	"github.com/google/uuid"
)

var (
	ErrExpiredToken = errors.New("token is expired")
	ErrInvalidToken = errors.New("token is invalid")
)

type Payload struct {
	ID        uuid.UUID `json:"id"` // unique id for the token
	Username  string    `json:"username"`
	IssuedAt  time.Time `json:"issued_at"`
	ExpiredAt time.Time `json:"expired_at"`
}

func NewPayLoad(username string, duration time.Duration) (*Payload, error) {
	tokenId, err := uuid.NewRandom()
	if err != nil {
		return nil, err
	}
	now := time.Now()
	return &Payload{
		ID:        tokenId,
		Username:  username,
		IssuedAt:  now,
		ExpiredAt: now.Add(duration),
	}, nil
}

func (p *Payload) Valid() error {
	if p.ExpiredAt.Before(time.Now()) {
		return ErrExpiredToken
	}
	return nil
}
