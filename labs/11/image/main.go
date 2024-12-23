package main

import (
	"fmt"
	"os"
	"time"
)

func main() {
	// Define the environment variable to check
	envVarName := "SUN_CIPHER_ID"
	envVarValue := os.Getenv(envVarName)

	// Output information to stdout
	if envVarValue == "" {
		fmt.Printf("Environment variable %s is not set.\n", envVarName)
	} else {
		fmt.Printf("Environment variable %s: %s\n", envVarName, envVarValue)
	}

	// Keep the container running
	fmt.Println("Container is now running. Press Ctrl+C to stop.")
	for {
		time.Sleep(10 * time.Second)
	}
}
