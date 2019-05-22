FROM node:6.14.2
EXPOSE 8080
COPY alex_node/ .
CMD ["node", "server.js"]
