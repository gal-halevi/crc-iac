# All required permissions for backend deploy/destroy
data "aws_iam_policy_document" "backend" {
  statement {
    sid    = "Backend"
    effect = "Allow"
    actions = [
      "apigateway:GET",
      "apigateway:POST",
      "apigateway:DELETE",
      "dynamodb:CreateTable",
      "dynamodb:DescribeTable",
      "dynamodb:DescribeContinuousBackups",
      "dynamodb:DescribeTimeToLive",
      "dynamodb:ListTagsOfResource",
      "dynamodb:DeleteTable",
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfilesForRole",
      "iam:AttachRolePolicy",
      "iam:PassRole",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "lambda:AddPermission",
      "lambda:CreateFunction",
      "lambda:GetPolicy",
      "lambda:GetFunction",
      "lambda:ListVersionsByFunction",
      "lambda:GetFunctionCodeSigningConfig",
      "lambda:DeleteFunction",
      "lambda:RemovePermission",
      "logs:CreateLogGroup",
      "logs:DescribeLogGroups",
      "logs:ListTagsForResource",
      "logs:DeleteLogGroup"
    ]
    resources = ["*"]
  }
}

# Create policy for backend deployment
resource "aws_iam_policy" "backend_deploy_policy" {
  name        = "backend-deploy-policy"
  description = "Policy used for backend deployment"
  policy      = data.aws_iam_policy_document.backend.json
}

# Attach backend policy to OIDC role
resource "aws_iam_role_policy_attachment" "be_attach_policy" {
  role       = local.role_name
  policy_arn = aws_iam_policy.backend_deploy_policy.arn
}

module "dynamodb" {
  source      = "../modules/dynamodb_table"
  table_name  = var.table_name
  primary_key = var.primary_key
  depends_on  = [aws_iam_role_policy_attachment.be_attach_policy]
}

module "lambda" {
  source             = "../modules/lambda_function"
  source_file_path   = var.source_file_path
  dynamodb_table_arn = module.dynamodb.table_arn
  lambda_name        = var.lambda_name
  handler            = var.lambda_handler_name
  depends_on         = [aws_iam_role_policy_attachment.be_attach_policy]
}

module "api_gateway" {
  source               = "../modules/api_gateway"
  api_name             = var.api_name
  lambda_function_name = var.lambda_name
  lambda_arn           = module.lambda.invoke_arn
  route_key            = var.api_route_key
  cors_allowed_origins = var.api_cors_allowed_origins
  depends_on           = [aws_iam_role_policy_attachment.be_attach_policy]
}