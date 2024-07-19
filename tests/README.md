## Instructions on how to run the terraform modules tests

1. The Terraform version should be the latest (i.e. v1.9.0): this is advised because on earlier versions, tests were at beta stage.
2. Through terminal, set up the following environment variables: 
    -  `export MONGODB_ATLAS_PUBLIC_KEY="<YOUR_PUBLIC_KEY>"`
    -  `export MONGODB_ATLAS_PRIVATE_KEY="<YOUR_PRIVATE_KEY>"`
    -  `export MONGODB_ATLAS_BASE_URL="https://cloud-dev.mongodb.com/"` 
    -  `export TF_VAR_org_id=<YOUR_ORG_ID>` 
3. Run from terminal (from repository root) the command `terraform init`
4. Run from terminal (from repository root) the command `terraform test`
