FROM node:6.14.2
EXPOSE 80
COPY midas/ /midas
WORKDIR /midas
RUN npm install package.json
CMD ["node", "server.js"]
