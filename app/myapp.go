package main

import (
        "fmt"
        "net/http"
        "os"
	"log"
        )

func handler(w http.ResponseWriter, r *http.Request) {
        h, _ := os.Hostname()
        fmt.Fprintf(w, "Hello v0.5, I am running on container %s", h)
	fmt.Fprintf(w, ". I love %s!\n", r.URL.Path[1:])
}

func Log(handler http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        log.Printf("%s %s %s", r.RemoteAddr, r.Method, r.URL)
	handler.ServeHTTP(w, r)
    })
}


func main() {
        http.HandleFunc("/", handler)
        http.ListenAndServe(":8080", Log(http.DefaultServeMux))
}
