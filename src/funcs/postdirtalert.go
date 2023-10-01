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
    
    errCount := 0
    for _, message := range sqsEvent.Records {
        fmt.Printf("Message: %s \n Event Source %s: %s \n", message.MessageId, message.EventSource, message.Body)

        var dirtAlert models.DirtAlert
        json.Unmarshal([]byte(message.Body), &dirtAlert) 
        
        av, err := attributevalue.MarshalMap(dirtAlert)
        if err != nil {
            log.Printf("Error marshaling item: %v", err)
            continue
        }

        putArgs := &dynamodb.PutItemInput{
            TableName: aws.String("dirt_alerts"),
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
