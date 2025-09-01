FROM golang:1.24.2-alpine AS build
WORKDIR /app
COPY . .
RUN go build -o testapp .

FROM alpine:3.22.1 as runtime
WORKDIR /app
COPY --from=build /app/testapp .
CMD ["./testapp"]
