# Update release to argocd action

This action will use tag from checkout/release and update k8s deployment to use new image tag. Update process will be handle by kustomize

## Example usage

```yaml
uses: fadzril/update-argocd@v1
env:
  APP_NAME: app
  IMAGE_TAG: f35334d
  REPO_TOKEN: ${{ secrets.REPO_TOKEN }}
```
