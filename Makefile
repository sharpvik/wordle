dev:
	elm make --output ./app/js/main.js ./src/Main.elm 

prod:
	elm make --optimize --output ./app/js/main.js ./src/Main.elm

run: dev
	go install
	wordle

install: prod
	go install

win: prod
	GOOS=windows GOARCH=amd64 go build