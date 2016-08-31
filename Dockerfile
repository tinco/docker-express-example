FROM node
ADD . /usr/src/app
WORKDIR /usr/src/app
CMD node app.js
