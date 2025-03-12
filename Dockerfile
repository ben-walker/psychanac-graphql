FROM node:17-alpine AS node

FROM node AS build
WORKDIR /root
COPY package*.json .
COPY prisma/schema.prisma ./prisma/
RUN npm ci \
  && npx prisma generate
COPY . .
RUN npm run build

FROM node AS app
WORKDIR /app
COPY --from=build /root/package.json .
COPY --from=build /root/node_modules ./node_modules/
COPY --from=build /root/build ./build/
COPY --from=build /root/prisma ./prisma/
COPY --from=build /root/scripts ./scripts/
CMD [ "npm", "start" ]
