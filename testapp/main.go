package main

import (
	"fmt"
	"log"
	"log/slog"
	"net/http"
	"os"
	"time"
)

func main() {
	logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))

	http.HandleFunc("/test", func(w http.ResponseWriter, r *http.Request) {
		logger.Info("incoming request", "method", r.Method, "path", r.URL.Path)
	})

	go func() {
		x := 1
		for {
			time.Sleep(time.Second * 15)
			logger.Info("worker running", "id", x)
			x++
		}
	}()

	fmt.Println("listening on port 9000...")
	log.Fatal(http.ListenAndServe(":9000", nil))
}
