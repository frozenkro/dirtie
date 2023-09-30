package main

import (
    "context"
    "fmt"
    "github.com/aws/aws-lambda-go/lambda"
)

func HandleRequest(ctx context.Context, event interface{}) (string, error) {
    fmt.Println("event", event)

    return "Hello dirt, test change 2", nil
}

func main() {
    lambda.Start(HandleRequest)
}
