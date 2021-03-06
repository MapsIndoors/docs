### STAGE 1: Build ###
FROM node:12.18 as build
LABEL author="MapsPeople"

# Create app directory
WORKDIR /app

# Install app dependencies and copy it all
# Use wildcard "package*.json" to ensure both package.json AND package-lock.json are copied
COPY package*.json ./
RUN npm ci
COPY . .

# Build site
RUN npm run sass
RUN npm run build


### STAGE 2: Run ###
FROM nginx:alpine
VOLUME /var/cache/nginx
COPY --from=build /app/dist /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
