############################
# Cognito User Pool
############################
resource "aws_cognito_user_pool" "user_pool" {
  name = "sample-user-pool"

  # メールをユーザー名として使う
  username_attributes = ["email"]
  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_uppercase = true
    require_numbers   = true
    require_symbols   = false
  }
}

############################
# Cognito App Client
############################
resource "aws_cognito_user_pool_client" "app_client" {
  name         = "sample-app-client"
  user_pool_id = aws_cognito_user_pool.user_pool.id

  # HTTP API (JWT) では secret なし
  generate_secret = false

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]
}

############################
# API Gateway JWT Authorizer
############################
resource "aws_apigatewayv2_authorizer" "cognito_jwt" {
  api_id = aws_apigatewayv2_api.http_api.id
  name   = "cognito-jwt-authorizer"

  authorizer_type = "JWT"

  identity_sources = [
    "$request.header.Authorization"
  ]

  jwt_configuration {
    audience = [
      aws_cognito_user_pool_client.app_client.id
    ]

    issuer = "https://cognito-idp.ap-northeast-1.amazonaws.com/${aws_cognito_user_pool.user_pool.id}"
  }
}

resource "aws_cognito_user_pool_domain" "this" {
  domain       = "example-auth-domain"
  user_pool_id = aws_cognito_user_pool.this.id
}