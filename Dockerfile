FROM python:3.8-alpine

# github action metadata should now be defines in action.yml file. look further.
# LABEL "com.github.actions.name"="JSCDN"
# LABEL "com.github.actions.description"="Uploads latest release to an AWS S3 repository"
# LABEL "com.github.actions.icon"="refresh-cw"
# LABEL "com.github.actions.color"="green"

# Installing GIT 
RUN apk update
RUN apk add git

# https://github.com/aws/aws-cli/blob/master/CHANGELOG.rst
ENV AWSCLI_VERSION='1.20.6'

RUN pip install --quiet --no-cache-dir awscli==${AWSCLI_VERSION}
RUN ls

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN ls
ENTRYPOINT ["/entrypoint.sh"]