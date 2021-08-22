# actions-flutter-deploy-pages

Performs checks against Dart and Flutter code to ensure the package does not have any analysis issues, failed tests, or improperly formatted code (as defined by `dartfmt`).

## Inputs

Name           | Default   | Description
---------------|-----------|-------------
`build_flags`  | n/a       | (Optional) Build flags to pass to Flutter when building the web
`build_mode`   | `release` | (Optional) Release mode; debug, profile, release
`build_number` | n/a       | Build Number to use for the build
`deploy_path`  | `web`     | (Optional) Path to deploy the built application to
`repo_url`     | n/a       | Url to the repo to build.  Typically: `${{env.GITHUB_SERVER_URL}}/${{ env.GITHUB_REPOSITORY }}`
`source_path`  | `.`       | (Optional) Path to the source to build
`token`        | n/a       | Access token for the GH Push to retrieve code.  Typically: `${{ secrets.GITHUB_TOKEN }}`


## Example usage

```yaml
name: Deploy Web to GitHub

on:
  pull_request:
    branches: [main]

jobs:
  build_number:
    runs-on: ubuntu-latest
    outputs:
      buildnumber: ${{ steps.buildnumber.outputs.build_number }}
    steps:
      - name: Generate Build Number
        id: buildnumber
        uses: einaregilsson/build-number@v3
        with:
          token: ${{secrets.GITHUB_TOKEN}}
      - name: Build Number
        run: echo "Build Number - $BUILD_NUMBER"

  publish:
    needs: build_number
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Publish
        uses: peiffer-innovations/actions-flutter-deploy-pages@v1.0.0
        with:
          build_number: ${{ needs.build_number.outputs.buildnumber }}
          deploy_path: web
          repo_url: ${{ env.GITHUB_SERVER }}/${{ env.GITHUB_REPOSITORY }}
          source_path: example
          token: ${{ secrets.GITHUB_TOKEN }}
```

