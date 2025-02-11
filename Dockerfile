# Dockerfile
FROM ruby:3.4.1

# install required packages for Node.js and Yarn 
RUN apt-get update -qq && apt-get install -y \
    curl \
    gnupg2 \
    apt-transport-https \
    ca-certificates

# install Node.js 
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get update -qq && \
    apt-get install -y nodejs \
    postgresql-client\
    netcat-openbsd \
    build-essential \
    libpq-dev
# Check if npm exists; if not, install it explicitly 
RUN if ! command -v npm > /dev/null 2>&1; then \
    apt-get install -y npm; \
    fi

# Verify npm is available and install Yarn
RUN npm --version && npm install --global yarn

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0 "]
