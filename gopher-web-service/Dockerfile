# Use the official Golang image as the base image
FROM golang:1.23-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the Go source code into the container
COPY . .

# Build the Go application
RUN go build -o gopher-web-service

# Expose the port the application runs on
EXPOSE 8080

# Define the command to run the application
CMD ["./gopher-web-service"]