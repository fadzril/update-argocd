#!/bin/bash -l
# Exit immediately if a pipeline returns a non-zero status.
set -e

echo "⚡️ Starting deployment action"

# Here we are using the variables
# Creating the repository URL in this way will allow us to `git push` without providing a password
# All thanks to the REPO_TOKEN that will grant us access to the repository
REMOTE_REPO="https://$REPO_TOKEN@github.com/kfit-dev/app-defs.git"
GITHUB_EMAIL="devci"
GITHUB_USER="dev+ci@kfit.com"

# We need to clone the repo here.
# Remember, our Docker container is practically pristine at this point
echo "⚡️ Clone $REMOTE_REPO master..."
git clone $REMOTE_REPO repo

cd repo

echo "⚡️ Checkout branch deploy/$APP_PATH"
git checkout deploy/$APP_PATH
cd $APP_PATH

curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
chmod +x ./kustomize
cp ./kustomize /usr/local/bin/kustomize
echo "⚡️ Validating kustomize: $(which kustomize)"

# Update image tag using kustomize
kustomize edit set image ${APP_NAME}=${IMAGE_PATH}

# Now we setup default config for committer
# So we can perform a commit
git config user.name "$GITHUB_USER"
git config user.email "$GITHUB_EMAIL"

git add .

# That will create a nice commit message
git commit -m "Deploy kfit-dev/@$APP_NAME to $APP_PATH with ref $IMAGE_TAG"
echo "⚡️ Changes for image $IMAGE_PATH ready to go. Pushing to Github..."

# Push this update to our master
git push origin deploy/$APP_PATH

# Now everything is ready.
# Lets just be a good citizen and so some clean-up after ourselves
rm -rf repo
echo "⚡️ New version deployed"
