resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda_eventbridge"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "sid1"
    },
    {
        "Action": "sts.AssumeRole",
        "Principal": {
          "Service": "events.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": "EventsFullAccess"
    }
  ]
}
EOF
}

resource "aws_lambda_function" "lambda_event_generator" {
  filename      = "lambda_event_generator.zip"
  function_name = "lambda_event_generator"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_event_generator.lambda_handler"
  source_code_hash = filebase64sha256("lambda_event_generator.zip")

  runtime = "python3.8"
}