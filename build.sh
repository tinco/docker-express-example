  docker run -it --rm -v "$PWD":/usr/src/app -w /usr/src/app node:6 npm install
  docker build -t tinco/express-example .
