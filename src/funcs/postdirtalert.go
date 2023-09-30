package main

import (
    "context"
    "fmt"
    "encoding/json"
    "dirtie/src/common/models"
    "github.com/aws/aws-lambda-go/lambda"
    "github.com/aws/aws-lambda-go/events"
)

func HandleRequest(ctx context.Context, sqsEvent events.SQSEvent) error {
    for _, message := range sqsEvent.Records {
        fmt.Printf("Message: %s \n Event Source %s: %s \n", message.MessageId, message.EventSource, message.Body)

        var dirtAlert models.DirtAlert
        json.Unmarshal([]byte(message.Body), &dirtAlert) 
    }

    return nil
}

func main() {
    lambda.Start(HandleRequest)
}
