package util

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestPassword(t *testing.T) {
	password := "password"
	hash, err := HashPassword(password)
	require.NoError(t, err)
	require.NotEmpty(t, hash)

	err = CheckPassword(password, hash)
	require.NoError(t, err)

	err = CheckPassword("wrong", hash)
	require.Error(t, err)

	hash2, err := HashPassword(password)
	require.NoError(t, err)
	require.NotEmpty(t, hash2)
	require.NotEqual(t, hash, hash2)
}
