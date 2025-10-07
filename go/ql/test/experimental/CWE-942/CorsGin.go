package main

import (
	"net/http"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

// Function is vulnerable due to AllowAllOrigins = true aka Access-Control-Allow-Origin: null
func vulnerable1() {
	router := gin.Default()
	// CORS for https://foo.com and null
	// - PUT and PATCH methods
	// - Origin header
	// - Credentials share
	// - Preflight requests cached for 12 hours
	config_vulnerable := cors.Config{
		AllowMethods:     []string{"PUT", "PATCH"},
		AllowHeaders:     []string{"Origin"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: true,
		MaxAge:           12 * time.Hour,
	}
	config_vulnerable.AllowOrigins = []string{"null", "https://foo.com"} // $ Alert
	router.Use(cors.New(config_vulnerable))
	router.GET("/", func(c *gin.Context) {
		c.String(http.StatusOK, "hello world")
	})
	router.Run()
}

// Function is vulnerable due to AllowAllOrigins = true aka Access-Control-Allow-Origin: null
func vulnerable2() {
	router := gin.Default()
	// CORS for https://foo.com and null
	// - PUT and PATCH methods
	// - Origin header
	// - Credentials share
	// - Preflight requests cached for 12 hours
	config_vulnerable := cors.Config{
		AllowMethods:     []string{"PUT", "PATCH"},
		AllowHeaders:     []string{"Origin"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: true,
		AllowOrigins:     []string{"null", "https://foo.com"}, // $ Alert
		MaxAge:           12 * time.Hour,
	}
	router.Use(cors.New(config_vulnerable))
	router.GET("/", func(c *gin.Context) {
		c.String(http.StatusOK, "hello world")
	})
	router.Run()
}

// Function is safe due to hardcoded origin and AllowCredentials: true
func safe() {
	router := gin.Default()
	// CORS for https://foo.com origin, allowing:
	// - PUT and PATCH methods
	// - Origin header
	// - Credentials share
	// - Preflight requests cached for 12 hours
	config_safe := cors.Config{
		AllowMethods:     []string{"PUT", "PATCH"},
		AllowHeaders:     []string{"Origin"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: true,
		MaxAge:           12 * time.Hour,
	}
	config_safe.AllowOrigins = []string{"https://foo.com"}
	router.Use(cors.New(config_safe))
	router.GET("/", func(c *gin.Context) {
		c.String(http.StatusOK, "hello world")
	})
	router.Run()
}

// Function is safe due to AllowAllOrigins = true aka Access-Control-Allow-Origin: *
func AllowAllTrue1() {
	router := gin.Default()
	// CORS for "*" origin, allowing:
	// - PUT and PATCH methods
	// - Origin header
	// - Credentials share
	// - Preflight requests cached for 12 hours
	config_allowall := cors.Config{
		AllowMethods:     []string{"PUT", "PATCH"},
		AllowHeaders:     []string{"Origin"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: true,
		MaxAge:           12 * time.Hour,
	}
	config_allowall.AllowOrigins = []string{"null"}
	config_allowall.AllowAllOrigins = true
	router.Use(cors.New(config_allowall))
	router.GET("/", func(c *gin.Context) {
		c.String(http.StatusOK, "hello world")
	})
	router.Run()
}

// Function is safe due to AllowAllOrigins = true aka Access-Control-Allow-Origin: *
func AllowAllTrue2() {
	router := gin.Default()
	// CORS for "*" origin, allowing:
	// - PUT and PATCH methods
	// - Origin header
	// - Credentials share
	// - Preflight requests cached for 12 hours
	config_allowall := cors.Config{
		AllowMethods:     []string{"PUT", "PATCH"},
		AllowHeaders:     []string{"Origin"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowAllOrigins:  true,
		AllowCredentials: true,
		MaxAge:           12 * time.Hour,
	}
	config_allowall.AllowOrigins = []string{"null"}
	router.Use(cors.New(config_allowall))
	router.GET("/", func(c *gin.Context) {
		c.String(http.StatusOK, "hello world")
	})
	router.Run()
}

func NoVariableVulnerable() {
	router := gin.Default()
	// CORS for https://foo.com origin, allowing:
	// - PUT and PATCH methods
	// - Origin header
	// - Credentials share
	// - Preflight requests cached for 12 hours
	router.Use(cors.New(cors.Config{
		AllowMethods:     []string{"GET", "POST"},
		AllowHeaders:     []string{"Origin"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowOrigins:     []string{"null", "https://foo.com"}, // $ Alert
		AllowCredentials: true,
		MaxAge:           12 * time.Hour,
	}))
	router.GET("/", func(c *gin.Context) {
		c.String(http.StatusOK, "hello world")
	})
	router.Run()
}

var global_config1 = cors.Config{
	AllowMethods:     []string{"PUT", "PATCH"},
	AllowHeaders:     []string{"Origin"},
	ExposeHeaders:    []string{"Content-Length"},
	AllowCredentials: true,
	AllowOrigins:     []string{"null", "https://foo.com"}, // $ Alert
	MaxAge:           12 * time.Hour,
}

func vulnerableGlobal1() {
	router := gin.Default()
	router.Use(cors.New(global_config1))
	router.GET("/", func(c *gin.Context) {
		c.String(http.StatusOK, "hello world")
	})
	router.Run()
}

var global_config2 = cors.Config{
	AllowMethods:     []string{"PUT", "PATCH"},
	AllowHeaders:     []string{"Origin"},
	ExposeHeaders:    []string{"Content-Length"},
	AllowCredentials: true,
	MaxAge:           12 * time.Hour,
}

func vulnerableGlobal2() {
	router := gin.Default()
	global_config2.AllowOrigins = []string{"null", "https://foo.com"} // $ MISSING: Alert
	router.Use(cors.New(global_config2))
	router.GET("/", func(c *gin.Context) {
		c.String(http.StatusOK, "hello world")
	})
	router.Run()
}
