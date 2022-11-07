# Description:
This repo deploys an OS Policy assignment for each zone within the selected region.
The Policy assignment will deploy SSM for the following OS:
- Windows
- Debian
- Ubuntu
- CentOS

# Deployment instructions:
1. In terraform/providers configure your backend bucket (BACKEND_BUCKET) and a bucket folder (BUCKET_FOLDER)
1. run:
    ./deployment.sh
1. Type your PROJECT_ID and REGION when requested
