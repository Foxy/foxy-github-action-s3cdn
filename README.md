# S3CDN: An unpkg clone using S3 and CloudFront

This action runs when tags are created, and will upload your code to an S3 bucket to multiple directories for `@latest` and `@major`, `@major.minor` and `@major.minor.patch`, for access similar to how unpkg.com works. For example, for first release, for release version `v1.2.3-beta.1` the `dist` content will be uploaded to `1`, `1.2`, `1.2.3-beta.1` directores.

In general, 4 new directories will be created or updated in S3 for `latest` and the different versions. Though it's possible in S3 to do some redirects (which could in theory reduce the number of folders and files created), there are limitations there, and S3 storage space for things like npm packages should generally be _very_ negligible.

Note that it doesn't allow for tilde (`~`) or caret (`^`) ranges, nor for asterisks (`*`), though as with unpkg.com, you you can get the latest of any major or minor release by simply not including the minor or patch version, such as `package@1` (which will serve the latest `1.x.x` release) or `package@1.1` (which will serve the latest `1.1.x` release). Unlike unpkg, which redirects, it will serve the files in the corresponding directories in S3.

This package relies on your tags using [semantic versioning](https://semver.org/).

We'd recommend putting CloudFront in front of your S3 bucket, but that's up to you.

## Usages

Create workflow YAML file in `.github/workflows/` directory of your app.

Go to Project's settings in GitHub, Click `Secret`, create the Secret key/values as mentioned in the docs below. On every release, this action should run.

Example of the workflow is given below:

### `s3-package-release.yml` Example

```yaml
name: S3CDN upload

on:
  push:
    tags:
      - "*"
jobs:
  s3cdn:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Foxy/foxy-elements
        uses: actions/checkout@v2
      - name: Install & Build # Update this section with your own build commands
        run: |
          npm install
          npm run prepack
      - uses: Foxy/foxy-github-action-s3cdn@main
        # with:
        #   package-name: elements # optional: defaults to the repo name
        env:
          AWS_S3_CDN_BUCKET_NAME: ${{ secrets.AWS_S3_CDN_BUCKET_NAME }}
          AWS_S3_CDN_KEY_ID: ${{ secrets.AWS_S3_CDN_KEY_ID }}
          AWS_S3_CDN_KEY_SECRET: ${{ secrets.AWS_S3_CDN_KEY_SECRET }}
          # AWS_REGION: "us-west-1" # optional: defaults to us-east-1
          # SOURCE_DIR: "public" # optional: defaults to `dist` directory
```

| Key                     | Value                                                                                                                                                                                                                       | Suggested Type | Required | Default                                                                  |
| ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | -------- | ------------------------------------------------------------------------ |
| `AWS_S3_CDN_KEY_ID`     | Your AWS Access Key. [More info here.](https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html)                                                                                                         | `secret env`   | **Yes**  | N/A                                                                      |
| `AWS_S3_CDN_KEY_SECRET` | Your AWS Secret Access Key. [More info here.](https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html)                                                                                                  | `secret env`   | **Yes**  | N/A                                                                      |
| `AWS_S3_CDN_BUCKET_NAME`         | The name of the bucket you're syncing to. For example, `my-app-releases`.                                                                                                                                                   | `secret env`   | **Yes**  | N/A                                                                      |
| `AWS_REGION`            | The region where you created your bucket. Set to `us-east-1` by default. [Full list of regions here.](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions) | `env`          | No       | `us-east-1`                                                              |
| `SOURCE_DIR`            | The local directory (or build directory) you wish to sync/upload to S3 against those release version. For example, `dist`, `public`.                                                                                        | `env`          | No       | If nothing is passed, `dist` will be considered your app/build directory |
| `package-name`            | Name of the package that will be appended to package version to make directory name. For example, `MyPackage`.                                                                                        | `arg`          | No       | If nothing is passed, project's repo name will be used |

## License

This project is distributed under the [MIT license](LICENSE.md).
