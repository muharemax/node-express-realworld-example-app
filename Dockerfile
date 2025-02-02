FROM node:alpine

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./

#Install dependencies
RUN npm install

# Bundle app source
COPY . .

EXPOSE 3000

ENTRYPOINT [ "node", "app.js" ]