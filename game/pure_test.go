package game

import (
	"testing"

	"github.com/sharpvik/fungi"
	"github.com/stretchr/testify/assert"
)

var testWords = []string{
	"ребро",
	"малыш",
	"буква",
	"лассо",
	"леска",
	"тезка",
}

func TestNotAtPosition(t *testing.T) {
	result, err := fungi.CollectSlice(
		notAtPosition(4, 'а')(fungi.SliceStream(testWords)))
	assert.NoError(t, err)
	assert.Equal(t, []string{"ребро", "малыш", "лассо"}, result)
}

func TestAtPosition(t *testing.T) {
	result, err := fungi.CollectSlice(
		atPosition(4, 'а')(fungi.SliceStream(testWords)))
	assert.NoError(t, err)
	assert.Equal(t, []string{"буква", "леска", "тезка"}, result)
}
