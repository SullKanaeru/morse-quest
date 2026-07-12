# Build stage
FROM golang:1.25-alpine AS builder

WORKDIR /app

# Install dependencies required for CGO or missing packages if any
RUN apk add --no-cache git

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the source code
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -o morsequest-be ./cmd/api/main.go

# Final stage
FROM alpine:latest

WORKDIR /app

# Add timezone data and CA certificates for making secure web requests
RUN apk --no-cache add ca-certificates tzdata

# Create directory for uploads if it doesn't exist
RUN mkdir -p uploads
# Ensure correct permissions
RUN chmod -R 755 uploads

# Copy the binary from the builder stage
COPY --from=builder /app/morsequest-be .

# Copy environment variables (in production it's better to pass them directly, but just in case)
COPY .env .env

# Expose port (default 8080)
EXPOSE 8080

# Run the binary
CMD ["./morsequest-be"]
