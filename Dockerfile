FROM python:3.8-alpine

# Installing GIT 
RUN apk update
RUN apk add git

# https://github.com/aws/aws-cli/blob/master/CHANGELOG.rst
ENV AWSCLI_VERSION='1.20.6'

RUN pip install --quiet --no-cache-dir awscli==${AWSCLI_VERSION}
RUN ls

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]