package game

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestGame(t *testing.T) {
	g := New()

	g.Update([5]Letter{
		PresentLetter('б'),
		AbsentLetter('у'),
		AbsentLetter('к'),
		AbsentLetter('в'),
		PresentLetter('а'),
	})
	assert.NotEmpty(t, g.PossibleWords())

	g.Update([5]Letter{
		AbsentLetter('т'),
		PlacedLetter('а'),
		PlacedLetter('б'),
		AbsentLetter('л'),
		AbsentLetter('о'),
	})
	assert.NotEmpty(t, g.PossibleWords())

	g.Update([5]Letter{
		AbsentLetter('ш'),
		PlacedLetter('а'),
		PlacedLetter('б'),
		AbsentLetter('а'),
		AbsentLetter('ш'),
	})
	assert.NotEmpty(t, g.PossibleWords())
}
