#!/bin/bash

# Create a dedicated profile for this action to avoid conflicts
# with past/future actions.
aws configure --profile s3-sync-action <<-EOF > /dev/null 2>&1
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
text
EOF
