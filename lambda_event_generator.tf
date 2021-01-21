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
      "Sid": "Lambda"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "grant_access_to_eventbridge" {
  name = "Full_access_to_eventbridge"
  role = aws_iam_role.iam_for_lambda.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "events:*"
        ],
        "Effect": "Allow",
        "Resource": "*"
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