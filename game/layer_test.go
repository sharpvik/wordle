package game

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestLayer(t *testing.T) {
	m1 := map[rune]int{
		'a': 1,
		'b': 2,
		'c': 3,
	}
	m2 := map[rune]int{
		'a': 2,
		'c': 2,
	}
	layer(m1, m2)
	assert.Equal(t, 2, m1['a'])
	assert.Equal(t, 2, m1['b'])
	assert.Equal(t, 3, m1['c'])
}
