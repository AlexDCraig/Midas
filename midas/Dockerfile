FROM node:6.14.2
EXPOSE 80
COPY . /midas
WORKDIR /midas
RUN npm install package.json
ENTRYPOINT ["node", "server.js", "--database_info", "midas-mongo-deployment:27017"]
