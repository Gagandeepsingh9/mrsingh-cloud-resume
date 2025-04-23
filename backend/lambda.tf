#IAM ROLE FOR LAMBDA TO ASSUME

resource "aws_iam_role" "myrole" {
    name = "Lambda_Cloud_resume_iam_role"
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

#IAM POLICY FOR IAM ROLE
resource "aws_iam_policy" "mypolicy" {
    name = "Terrapolicy_for_Lambdarole"
    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  
}

#Attaching Policy with the iam role
resource "aws_iam_role_policy_attachment" "attached" {
    role = aws_iam_role.myrole.name
    policy_arn = aws_iam_policy.mypolicy.arn
  
}

#creating zip file of myfunctioncode.py
data "archive_file" "myzip" {
    type = "zip"
    source_dir = "${path.module}/lambda_python"
    output_path = "${path.module}/lambda_python/myfunctioncode.zip"
}


resource "aws_lambda_function" "mylambdafunction" {
    filename = "${path.module}/lambda_python/myfunctioncode.zip"
    function_name = "lambda_by_terraform"
    role = aws_iam_role.myrole.arn
    handler = "myfunctioncode.lambda_handler"
    runtime = "python3.8"
    source_code_hash = data.archive_file.myzip.output_base64sha256
    #This makes sure Lambda is re-deployed automatically when your function code changes.
    #If hash of the file changes it means code inside it changes, so lambda will re-deploy the code
    #Otherwise it will just skip the deploying part if hash is same(means no change in the code).
  
}

#Creating lambda function url instead of API Gateway
resource "aws_lambda_function_url" "myurl" {
  function_name = aws_lambda_function.mylambdafunction.function_name
  authorization_type = "NONE"

  cors {
  allow_credentials = true
  allow_origins     = ["https://mrsinghincloud.com"] #only this website is allowed to send the credentials to lambda function
  allow_methods     = ["*"]
  allow_headers     = ["date", "keep-alive"]
  expose_headers    = ["keep-alive", "date"]
  max_age           = 86400
}
}