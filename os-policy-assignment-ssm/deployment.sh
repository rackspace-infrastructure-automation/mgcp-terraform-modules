echo "Enter your Project ID"
read project_id
echo "Enter the Region"
read region
cd terraform
terraform init
terraform apply -auto-approve -var="project_id=$project_id" -var="region=$region"