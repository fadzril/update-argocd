#!/bin/bash -l
# Exit immediately if a pipeline returns a non-zero status.
set -e

echo "⚡️ Starting deployment action"

# Here we are using the variables
# Creating the repository URL in this way will allow us to `git push` without providing a password
# All thanks to the REPO_TOKEN that will grant us access to the repository
REF="${GITHUB_REF/refs\/head\//}"
DEPLOYMENT_REPO="kfit-dev/app-defs"
REMOTE_REPO="https://${REPO_TOKEN}@github.com/$DEPLOYMENT_REPO.git"
GITHUB_EMAIL="devci"
GITHUB_USER="dev+ci@kfit.com"

# We need to clone the repo here.
# Remember, our Docker container is practically pristine at this point
git clone --depth 1 --branch "master" $REMOTE_REPO repo
echo "⚡️ Clone $REMOTE_REPO master..."

cd repo

# Update image tag using kustomize
kustomize edit set image ${APP_NAME}=${IMAGE_PATH}

# Now we setup default config for committer
# So we can perform a commit
git config user.name "$GITHUB_USER"
git config user.email "$GITHUB_EMAIL"

git add .

# That will create a nice commit message
git commit -m "Deploy kfit-dev/@$APP_NAME to $DEPLOY_PATH"
echo "⚡️ Changes for image $IMAGE_PATH ready to go. Pushing to Github..."

# Push this update to our master
git push origin master

# Now everything is ready.
# Lets just be a good citizen and so some clean-up after ourselves
rm -rf repo
echo "⚡️ New version deployed"
