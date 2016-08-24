FROM tinco/passenger-standalone-alpine-node:latest
ADD . /usr/src/app
RUN chown -R app:app /usr/src/app

