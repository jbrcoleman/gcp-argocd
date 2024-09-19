package main

import (
    "fmt"
    "net/http"
)

func main() {
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprintf(w, `
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Go Gopher</title>
            </head>
            <body>
                <h1>Welcome to the Go Gopher Web Service!</h1>
                <img src="/static/gopher.png" alt="Go Gopher">
            </body>
            </html>
        `)
    })

    // Serve static files
    fs := http.FileServer(http.Dir("static"))
    http.Handle("/static/", http.StripPrefix("/static/", fs))

    fmt.Println("Starting server at :8080")
    http.ListenAndServe(":8080", nil)
}