# базовый образ с alias builder 
FROM golang:alpine AS builder
# рабочая директория
WORKDIR /usr/src
# копирование зависимостей в рабочую директорию
COPY go.mod go.sum .
# подгрузка зависимостей
RUN go mod download
# копирование кода в рабочую директорию
COPY . ./
# build файла /usr/src/cmd/main.go в /usr/src/bin/app
RUN CGO_ENABLED=0 GOOS=linux go build -o ./bin/app ./cmd/main.go
# второй этап сборки
FROM alpine
# копирование двоичного файла в рабочую директорию из образа golang в образ alpine
COPY --from=builder /usr/src/bin/app ./
# Run
CMD ["/app"]