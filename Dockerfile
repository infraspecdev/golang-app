# Use the official Golang image as the base image
FROM golang:latest

# Set the working directory inside the container
WORKDIR /app

# Set up environment variables for private modules
ARG GITHUB_USERNAME
RUN --mount=type=secret,id=GH_TOKEN \
    git config --global url."https://$(cat /run/secrets/GH_TOKEN):x-oauth-basic@github.com/".insteadOf "https://github.com/" && \
    echo "GOPRIVATE=github.com/${GITHUB_USERNAME}/*" >> /etc/environment

# Copy the Go module files and download dependencies
COPY go.mod go.sum ./
RUN go mod tidy

# Copy the rest of the application code
COPY . .

# Build the Go application
RUN go build -o helloserver server.go

# Expose the port the application runs on
EXPOSE 8000

# Command to run the executable
CMD ["./helloserver"]