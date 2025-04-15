###################################################################
# Create IAM user and policies for Continuous Deploy (CD) account #
###################################################################


resource "aws_iam_user" "cd" {
  name = "recipe-app-api-cd"
}

resource "aws_iam_access_key" "cd" {
  user = aws_iam_user.cd.name
}

##########################################################
# Policy for Terraform backend to S3 and DynamoDB access #
##########################################################


## data block: Generated that can be used when creating / managing resources (Defines IAM Policy Document)
## data block: Alternative to using JSON file in *setup* terraform
## You could also specify these policies in JSON File
## You can use *variables* in `data` block to make it more dynamic.
data "aws_iam_policy_document" "tf_backend" {

  # Grants permission to list the specific Terraform state S3 bucket.  
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.tf_state_bucket}"]
  }

  # Enables access to specific key paths in the bucket for Terraform state file handling.
  # tf-state-deploy is used for the main deploy state.
  # tf-state-deploy-env is used for workspaces.
  # No need to add access for setup since it's handled from an admin's local machine.  
  statement {
    effect  = "Allow"
    actions = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = [
      "arn:aws:s3:::${var.tf_state_bucket}/tf-state-deploy/*",
      "arn:aws:s3:::${var.tf_state_bucket}/tf-state-deploy-env/*"
    ]
  }


  statement {
    effect = "Allow"
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]
    resources = ["arn:aws:dynamodb:*:*:table/${var.tf_state_lock_table}"]
  }
}

## resource block: Creates resources in AWS Account (You will see these in AWS Account)
## This creates the IAM Policy in AWS from the data block above.
resource "aws_iam_policy" "tf_backend" {
  name        = "${aws_iam_user.cd.name}-tf-s3-dynamodb"
  description = "Allow user to use S3 and DynamoDB for TF backend resources"
  policy      = data.aws_iam_policy_document.tf_backend.json # Getting policy from the data block.
}

## Attach AWS IAM Policy with the IAM User
resource "aws_iam_user_policy_attachment" "tf_backend" {
  user       = aws_iam_user.cd.name
  policy_arn = aws_iam_policy.tf_backend.arn
}


#########################
# Policy for ECR access #
#########################

data "aws_iam_policy_document" "ecr" {
  statement {
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr:CompleteLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:InitiateLayerUpload",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage"
    ]
    resources = [
      aws_ecr_repository.app.arn,
      aws_ecr_repository.proxy.arn,
    ]
  }
}

resource "aws_iam_policy" "ecr" {
  name        = "${aws_iam_user.cd.name}-ecr"
  description = "Allow user to manage ECR resources"
  policy      = data.aws_iam_policy_document.ecr.json
}

resource "aws_iam_user_policy_attachment" "ecr" {
  user       = aws_iam_user.cd.name
  policy_arn = aws_iam_policy.ecr.arn
}
