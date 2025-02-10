# Dockerfile
FROM ruby:3.4.1

#install required packages for Node.js and Yarn 
RUN apt-get update -qq && apt-get install -y \
    curl \
    gnupg2 \
    apt-transport-https \
    ca-certificates

#install Node.js 
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get update -qq && \
    apt-get install -y nodejs

#Check if npm exists; if not, install it explicitly 
RUN if ! command -v npm > /dev/null 2>&1; then \
    apt-get install -y npm; \
    fi

#Verify npm is available and install Yarn
RUN npm --version && npm install --global yarn

#install dependencies for building 
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]
