package main

import (
	"encoding/json"
	"log"
	"net/http"
	"os/exec"
	"strconv"
	"time"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

type GpuMetricPoll struct {
	TempSensorEdge              float64 `json:"Temperature (Sensor edge) (C),string"`
	TempSensorJunction          float64 `json:"Temperature (Sensor junction) (C),string"`
	TempSensorMemory            float64 `json:"Temperature (Sensor memory) (C),string"`
	TempSensorHBM0              float64 `json:"Temperature (Sensor HBM 0) (C),string"`
	TempSensorHBM1              float64 `json:"Temperature (Sensor HBM 1) (C),string"`
	TempSensorHBM2              float64 `json:"Temperature (Sensor HBM 2) (C),string"`
	TempSensorHBM3              float64 `json:"Temperature (Sensor HBM 3) (C),string"`
	PerformanceLevel            string  `json:"Performance Level"`
	AverageGraphicsPackagePower string  `json:"Average Graphics Package Power (W)"`
	GPUuse                      float64 `json:"GPU use (%),string"`
	GFXActivity                 int64   `json:"GFX Activity,string"`
}

type GpuMetricsPolls map[string]GpuMetricPoll

type GpuMetric struct {
	TempSensorEdge              float64
	TempSensorJunction          float64
	TempSensorMemory            float64
	TempSensorHBM0              float64
	TempSensorHBM1              float64
	TempSensorHBM2              float64
	TempSensorHBM3              float64
	PerformanceLevel            string
	AverageGraphicsPackagePower float64
	GPUuse                      float64
	GFXActivity                 int64
}

type GpuMetrics map[string]GpuMetric

func convert_from_json(metricsJson GpuMetricsPolls) GpuMetrics {
	// convert from json to GpuMetricsPolls
	var metricsResults GpuMetrics = make(map[string]GpuMetric)
	for card, poll := range metricsJson {
		averagePower := 0.0
		if poll.AverageGraphicsPackagePower == "N/A (Secondary die)" {
			averagePower, _ = strconv.ParseFloat(poll.AverageGraphicsPackagePower, 64)
		} else {
			averagePower = 0.0
		}
		metric := GpuMetric{
			TempSensorEdge:              poll.TempSensorEdge,
			TempSensorJunction:          poll.TempSensorJunction,
			TempSensorMemory:            poll.TempSensorMemory,
			TempSensorHBM0:              poll.TempSensorHBM0,
			TempSensorHBM1:              poll.TempSensorHBM1,
			TempSensorHBM2:              poll.TempSensorHBM2,
			TempSensorHBM3:              poll.TempSensorHBM3,
			PerformanceLevel:            poll.PerformanceLevel,
			AverageGraphicsPackagePower: averagePower,
			GPUuse:                      poll.GPUuse,
			GFXActivity:                 poll.GFXActivity,
		}
		metricsResults[card] = metric
	}

	return metricsResults
}

func getROCMMetrics() GpuMetrics {
	// run gpu_sample process
	rocmCmd := exec.Command("/Users/ghost/Downloads/scc22-scripts/monitoring/gpu_exporter/rocm-smi")
	rocmOut, err := rocmCmd.Output()
	if err != nil {
		log.Fatal(err)
	}
	// parse output
	var metricsJson GpuMetricsPolls
	err = json.Unmarshal(rocmOut, &metricsJson)
	if err != nil {
		log.Fatal(err)
	}
	return convert_from_json(metricsJson)
}

var (
	gpuSensorEdge = promauto.NewGaugeVec(prometheus.GaugeOpts{
		Name: "temp_sensor_edge",
		Help: "The temperature at the edge sensor of a given GPU, in Celsius.",
	}, []string{"gpu"})
	gpuSensorJunction = promauto.NewGaugeVec(prometheus.GaugeOpts{
		Name: "neil_gpu_temp_sensor_junction",
		Help: "The temperature at the junction sensor of a given GPU, in Celsius.",
	}, []string{"gpu"})
	gpuSensorMemory = promauto.NewGaugeVec(prometheus.GaugeOpts{
		Name: "neil_gpu_temp_sensor_memory",
		Help: "The temperature at the memory sensor of a given GPU, in Celsius.",
	}, []string{"gpu"})
	gpuSensorHBM0 = promauto.NewGaugeVec(prometheus.GaugeOpts{
		Name: "neil_gpu_temp_sensor_hbm0",
		Help: "The temperature at the HBM 0 sensor of a given GPU, in Celsius.",
	}, []string{"gpu"})
	gpuSensorHBM1 = promauto.NewGaugeVec(prometheus.GaugeOpts{
		Name: "neil_gpu_temp_sensor_hbm1",
		Help: "The temperature at the HBM 1 sensor of a given GPU, in Celsius.",
	}, []string{"gpu"})
	gpuSensorHBM2 = promauto.NewGaugeVec(prometheus.GaugeOpts{
		Name: "neil_gpu_temp_sensor_hbm2",
		Help: "The temperature at the HBM 2 sensor of a given GPU, in Celsius.",
	}, []string{"gpu"})
	gpuSensorHBM3 = promauto.NewGaugeVec(prometheus.GaugeOpts{
		Name: "neil_gpu_temp_sensor_hbm3",
		Help: "The temperature at the HBM 3 sensor of a given GPU, in Celsius.",
	}, []string{"gpu"})
	averageGraphicsPackagePower = promauto.NewGaugeVec(prometheus.GaugeOpts{
		Name: "neil_gpu_average_graphics_package_power",
		Help: "Average graphics package power, in Watts.",
	}, []string{"gpu"})
	gpuUse = promauto.NewGaugeVec(prometheus.GaugeOpts{
		Name: "neil_gpu_gpu_use",
		Help: "Percentage of GPU usage.",
	}, []string{"gpu"})
	gfxActivity = promauto.NewGaugeVec(prometheus.GaugeOpts{
		Name: "neil_gpu_gfx_activity",
		Help: "GFX Activity.",
	}, []string{"gpu"})
)

func recordMetrics() {
	go func() {
		for {
			metrics := getROCMMetrics()
			for k, v := range metrics {
				gpuSensorEdge.WithLabelValues(k).Set(v.TempSensorEdge)
				gpuSensorJunction.WithLabelValues(k).Set(v.TempSensorJunction)
				gpuSensorMemory.WithLabelValues(k).Set(v.TempSensorMemory)
				gpuSensorHBM0.WithLabelValues(k).Set(v.TempSensorHBM0)
				gpuSensorHBM1.WithLabelValues(k).Set(v.TempSensorHBM1)
				gpuSensorHBM2.WithLabelValues(k).Set(v.TempSensorHBM2)
				gpuSensorHBM3.WithLabelValues(k).Set(v.TempSensorHBM3)
				averageGraphicsPackagePower.WithLabelValues(k).Set(v.AverageGraphicsPackagePower)
				gpuUse.WithLabelValues(k).Set(v.GPUuse)
				gfxActivity.WithLabelValues(k).Set(float64(v.GFXActivity))
			}
			time.Sleep(10 * time.Second)
		}
	}()
}

func main() {
	recordMetrics()

	http.Handle("/metrics", promhttp.Handler())
	http.ListenAndServe(":2112", nil)
}
