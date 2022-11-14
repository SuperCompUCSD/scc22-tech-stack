package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"time"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

type PowerStatus struct {
	CurrentValidity string `json:"ValidUntil"`
	CurrentLimit    int64  `json:"CapWatts"`
	KnownEvents     []KnownPowerEvent
}

type KnownPowerEvent struct {
	EventType string `json:"Event"`
	StartTime string `json:"StartTime"`
	Capacity  int64  `json:"CapWatts"`
}

func getPowerEvents() (PowerStatus, error) {
	if os.Getenv("COMPETITION_POWER_URL") == "" {
		panic("COMPETITION_POWER_URL not set")
	}
	client := http.Client{Timeout: 10 * time.Second}
	r, err := client.Get(os.Getenv("COMPETITION_POWER_URL"))
	if err != nil {
		return PowerStatus{}, err
	}
	defer r.Body.Close()

	var status PowerStatus
	err = json.NewDecoder(r.Body).Decode(&status)
	if err != nil {
		return PowerStatus{}, err
	}

	return status, nil
}

var (
	currentLimit = promauto.NewGaugeVec(prometheus.GaugeOpts{
		Name: "scc_power_limit",
		Help: "The current power limit, in watts.",
	}, []string{"valid_until"})
	upcomingLimit = promauto.NewGauge(prometheus.GaugeOpts{
		Name: "scc_upcoming_power_limit",
		Help: "The most recent upcoming power limit, in watts.",
	})
	powerEventLimit = promauto.NewGaugeVec(prometheus.GaugeOpts{
		Name: "scc_power_event_limit",
		Help: "The capacity of an upcoming period, in watts. Labels include event info and duration.",
	}, []string{"event", "start_time"})
)

func recordMetrics() {
	go func() {
		for {
			power, err := getPowerEvents()
			if err != nil {
				panic(err)
			}
			currentLimit.WithLabelValues(power.CurrentValidity).Set(float64(power.CurrentLimit))
			// add 1 year, since impossible for power events to go for that long
			mostRecentTime := time.Now().AddDate(1, 0, 0)
			for _, event := range power.KnownEvents {
				eventStart, err := time.Parse("20060102T150000Z", event.StartTime)
				fmt.Println(eventStart)
				if err != nil {
					panic(err)
				}
				if eventStart.Before(mostRecentTime) {
					mostRecentTime = eventStart
					upcomingLimit.Set(float64(event.Capacity))
				}
				powerEventLimit.WithLabelValues(event.EventType, event.StartTime).Set(float64(event.Capacity))
			}
			fmt.Println("sleeping...")
			time.Sleep(time.Until(mostRecentTime))
		}
	}()
}

func main() {
	recordMetrics()
	http.Handle("/metrics", promhttp.Handler())
	http.ListenAndServe(":2112", nil)
}
