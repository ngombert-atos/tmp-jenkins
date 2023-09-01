!#/bin/sh

apk add npm

npm install -g html-minifier

html-minifier /src/index.html /static/index.html