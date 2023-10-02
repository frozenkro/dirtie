package main

import (
	"context"
	"dirtie/src/common/models"
	"encoding/json"
	"fmt"
	"log"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
    "github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
)

func HandleRequest(ctx context.Context, sqsEvent events.SQSEvent) error {
    cfg, err := config.LoadDefaultConfig(ctx)
    if err != nil {
        return fmt.Errorf("error loading sdk config: %v\n", err)
    }

    client := dynamodb.NewFromConfig(cfg)
    
    fmt.Printf("updated\n")

    errCount := 0
    for _, message := range sqsEvent.Records {
        fmt.Printf("Message: %s \n Event Source %s: %s \n", message.MessageId, message.EventSource, message.Body)

        var dirtAlert models.DirtAlert
        err = json.Unmarshal([]byte(message.Body), &dirtAlert) 
        if err != nil {
            log.Printf("Error unmarshaling item: %v", err)
            continue
        }

        av, err := attributevalue.MarshalMap(dirtAlert)
        if err != nil {
            log.Printf("Error marshaling to aws attributevalue: %v", err)
            continue
        }
        
        fmt.Printf("Debug marshal \n [property, type, value]")
        fmt.Printf("[ DeviceId, %T, %v ]\n", dirtAlert.DeviceId, dirtAlert.DeviceId)
        fmt.Printf("[ EventTimestamp, %T, %v ]\n", dirtAlert.Timestamp, dirtAlert.Timestamp)
        fmt.Printf("[ Level, %T, %v ]\n", dirtAlert.Level, dirtAlert.Level)

        putArgs := &dynamodb.PutItemInput{
            TableName: aws.String("DirtAlerts"),
            Item: av,
        }

        _, err = client.PutItem(ctx, putArgs)
        if err != nil {
            log.Printf("Error updating item: %v \n", err)
            errCount++
        }

    }
    
    if errCount != 0 {
        return fmt.Errorf("%v errors occurred, check cloudwatch for output", errCount)
    }
    return nil
}

func main() {
    lambda.Start(HandleRequest)
}
