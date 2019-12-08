#!/bin/bash -l
# Exit immediately if a pipeline returns a non-zero status.
set -e

echo "⚡️ Starting deployment action"

# Here we are using the variables
# Creating the repository URL in this way will allow us to `git push` without providing a password
# All thanks to the REPO_TOKEN that will grant us access to the repository
REF="${GITHUB_REF/refs\/head\/}"
DEPLOYMENT_REPO="kfit-dev/app-defs"
DEPLOYMENT_REF="deployment/${APP_NAME}/$REF/${IMAGE_TAG}"
REMOTE_REPO="https://${REPO_TOKEN}@github.com/$DEPLOYMENT_REPO.git"
GITHUB_REPOSITORY="kfit-dev/app-defs"
GITHUB_EMAIL="devci"
GITHUB_USER="dev+ci@kfit.com"

# We need to clone the repo here.
# Remember, our Docker container is practically pristine at this point
git clone $REMOTE_REPO repo
cd repo

# Install all of our dependencies inside the container
# based on the git repository Gemfile
echo "⚡️ Checkout to $DEPLOYMENT_REF branch..."
git checkout -b $DEPLOYMENT_REF

# Update image tag using kustomize
kustomize edit set image ${APP_NAME}=${IMAGE_PATH}

# Now we setup default config for committer
# So we can perform a commit
git config user.name "$GITHUB_USER"
git config user.email "$GITHUB_EMAIL"
git add .

# That will create a nice commit message
# like Set fave.staging.web image tag at
# refs/heads/deployment/favefood/staging to 069367f
git commit -m "Set ${APP_NAME} image tag at $DEPLOYMENT_REF to ${IMAGE_TAG}"
echo "⚡️ Checkout branch ready to go. Pushing to Github..."

# Force push this update to our gh-pages
git push --force origin $DEPLOYMENT_REF

# Now everything is ready.
# Lets just be a good citizen and so some clean-up after ourselves
rm -rf repo
echo "⚡️ New version deployed"