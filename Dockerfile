# Use the official Golang image as the base image
FROM golang:latest AS builder

# Set the working directory inside the container
WORKDIR /app

# Set up environment variables for private modules
RUN --mount=type=secret,id=GH_TOKEN \
    git config --global url."https://infraspecdev:$(cat /run/secrets/GH_TOKEN)@github.com/".insteadOf "https://github.com/" && \
    echo "GOPRIVATE=github.com/*" >> /etc/environment && \
    echo "GONOSUMDB=github.com/*" >> /etc/environment

# Copy the Go module files and download dependencies
COPY go.mod go.sum ./
RUN --mount=type=secret,id=GH_TOKEN go mod tidy

# Copy the rest of the application code
COPY . .

# Build the Go application
RUN go build -o helloserver server.go

# Use a minimal base image for the final stage
FROM alpine:latest

# Set the working directory inside the container
WORKDIR /app

# Copy the built executable from the builder stage
COPY --from=builder /app/helloserver .

# Expose the port the application runs on
EXPOSE 8000

# Command to run the executable
CMD ["./helloserver"]