# базовый образ с alias builder 
FROM golang:1.21.5 AS builder
# рабочая директория
WORKDIR /usr/src
# копирование зависимостей в рабочую директорию
COPY go.mod go.sum .
# подгрузка зависимостей
RUN go mod download
# копирование кода в рабочую директорию
COPY . .
# переменные окружения
ENV CGO_ENABLED 0
ENV GOOS linux
# build файла /usr/src/cmd/main.go в /usr/src/bin/app
RUN go build -o ./bin/app ./cmd/main.go
# второй этап сборки
FROM alpine
# копирование двоичного файла в рабочую директорию из образа golang в образ alpine
COPY --from=builder /usr/src/bin/app .
# копирование БД
COPY --from=builder /usr/src/internal/parcel/tracker.db .
# Run
CMD ["/app"]