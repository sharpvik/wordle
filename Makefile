dev:
	elm make --output ./app/js/main.js ./src/Main.elm 

prod:
	elm make --optimize --output ./app/js/main.js ./src/Main.elm