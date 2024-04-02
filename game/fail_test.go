package game

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

var failTestWords = []string{
	"забью",
	"набью",
	"набей",
	"жабам",
	"жабре",
	"забес",
	"рабье",
	"жабья",
	"жабьи",
	"хабар",
	"рабий",
	"пабах",
	"шабер",
	"забег",
	"рабью",
	"пабам",
	"забеж",
	"набег",
	"фабря",
	"чабер",
	"жабью",
	"набер",
	"жабий",
	"шабаш",
	"рабам",
	"фабрю",
	"жабах",
	"мабиш",
	"сабан",
	"рабин",
	"рабах",
	"жабры",
	"жабье",
	"набре",
	"забей",
	"забер",
	"рабьи",
	"рабья",
	"чабан",
}

func TestFail(t *testing.T) {
	attempt := [5]Letter{
		AbsentLetter('ш'),
		PresentLetter('а'),
		PresentLetter('б'),
		AbsentLetter('а'),
		AbsentLetter('ш'),
	}
	result := update(attempt, failTestWords)
	assert.NotEmpty(t, result)
}
