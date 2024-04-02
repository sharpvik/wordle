package game

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestGame(t *testing.T) {
	g := New(Words)

	g.Update([5]Letter{
		PresentLetter('б'),
		AbsentLetter('у'),
		AbsentLetter('к'),
		AbsentLetter('в'),
		PresentLetter('а'),
	})
	assert.NotEmpty(t, g.Words())

	g.Update([5]Letter{
		AbsentLetter('т'),
		PresentLetter('а'),
		PresentLetter('б'),
		AbsentLetter('л'),
		AbsentLetter('о'),
	})
	assert.NotEmpty(t, g.Words())

	g.Update([5]Letter{
		AbsentLetter('ш'),
		PresentLetter('а'),
		PresentLetter('б'),
		AbsentLetter('а'),
		AbsentLetter('ш'),
	})
	assert.NotEmpty(t, g.Words())
}
