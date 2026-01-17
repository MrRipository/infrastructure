provider "aws" {
  region = "ap-northeast-1"
}

# DynamoDBテーブルの定義
resource "aws_dynamodb_table" "example_table" {
  name           = "example-github-actions-table"
  billing_mode   = "PAY_PER_REQUEST" # 従量課金（無料枠内での試行に最適）
  hash_key       = "UserId"

  attribute {
    name = "UserId"
    type = "S"
  }

  tags = {
    Environment = "Dev"
    CreatedBy   = "GitHubActions"
  }
}

terraform {
    backend "s3" {
        bucket = "terraform-state-bucket-20260118-t" # 事前に手動で作ったS3バケット名
        key    = "production/terraform.tfstate"     # バケット内での保存パス（好きな名前でOK）
        region = "ap-northeast-1"
    }
}