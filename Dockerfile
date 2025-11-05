FROM python:3.12-slim
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /app

RUN apt-get update -y && \
  apt-get install -y --no-install-recommends build-essential git curl jq ca-certificates gnupg && \
  rm -rf /var/lib/apt/lists/*

RUN apt-get update -y && apt-get install -y --no-install-recommends libgtk2.0-0 libgtk-3-0 libgbm-dev \
  libnotify-dev libnss3 libxss1 libasound2 \
  libxtst6 xauth xvfb tzdata && rm -rf /var/lib/apt/lists/*

ENV LANG=C.UTF-8
ENV PIPENV_YES=1 PIPENV_VENV_IN_PROJECT=1

RUN python -m pip install --upgrade pip pipenv

  RUN curl -sL https://deb.nodesource.com/setup_22.x -o nodesource_setup.sh && \
  bash nodesource_setup.sh && \
  cat /etc/apt/sources.list.d/nodesource.list

RUN apt-get update -y && apt-get install -y --no-install-recommends nodejs && rm -rf /var/lib/apt/lists/*
RUN node --version && npm --version

COPY Pipfile /app/Pipfile
COPY Pipfile.lock /app/Pipfile.lock
RUN pipenv --python $(command -v python) install --dev
RUN cp -a /app/. /.project/

COPY package.json /.project/package.json
COPY package-lock.json /.project/package-lock.json
RUN cd /.project && npm ci
RUN mkdir -p /opt/app && cp -a /.project/. /opt/app/

WORKDIR /opt/app

RUN npm ci
RUN pipenv --python $(command -v python) install --dev

COPY . /opt/app

# build arguments
ARG APP_ENV

RUN npm run build

CMD [ "npm", "start" ]

