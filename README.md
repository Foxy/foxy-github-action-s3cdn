# S3CDN

This simple action uses the [official AWS CLI version 2 Docker image](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-docker.html) to upload dist/app directory content to AWS S3 in their Major, Minor and Patch version directories.

For example, for first release, for release version `v1.2.3-beta.1` the `dist` content will be uploaded to `1`, `1.2`, `1.2.3-beta.1` directores.

## Usages

Create workflow YAML file in `.github/workflows/` directory of your app.

Go to Project's settings in GitHub, Click `Secret`, create the Secret key/values as mentioned in the docs below. On every release, this action should run.

Example of the workflow is given below:

### `s3-package-release.yml` Example

```

name: Update AWS S3 with current release

on:
  push:
    tags:
      - "*"
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: samifiaz/gh-action-docker@main
        with:
          package-name: MyPackage # optional: Default is repo name.
        env:
          AWS_S3_BUCKET: ${{ secrets.AWS_S3_BUCKET }}
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_REGION: "us-west-1" # optional: defaults to us-east-1
          SOURCE_DIR: "public" # optional: defaults to `dist` directory
```

| Key                     | Value                                                                                                                                                                                                                       | Suggested Type | Required | Default                                                                  |
| ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | -------- | ------------------------------------------------------------------------ |
| `AWS_ACCESS_KEY_ID`     | Your AWS Access Key. [More info here.](https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html)                                                                                                         | `secret env`   | **Yes**  | N/A                                                                      |
| `AWS_SECRET_ACCESS_KEY` | Your AWS Secret Access Key. [More info here.](https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html)                                                                                                  | `secret env`   | **Yes**  | N/A                                                                      |
| `AWS_S3_BUCKET`         | The name of the bucket you're syncing to. For example, `my-app-releases`.                                                                                                                                                   | `secret env`   | **Yes**  | N/A                                                                      |
| `AWS_REGION`            | The region where you created your bucket. Set to `us-east-1` by default. [Full list of regions here.](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions) | `env`          | No       | `us-east-1`                                                              |
| `SOURCE_DIR`            | The local directory (or build directory) you wish to sync/upload to S3 against those release version. For example, `dist`, `public`.                                                                                        | `env`          | No       | If nothing is passed, `dist` will be considered your app/build directory |
| `package-name`            | Name of the package that will be appended to package version to make directory name. For example, `MyPackage`.                                                                                        | `arg`          | No       | If nothing is passed, project's repo name will be used |

## License

This project is distributed under the [MIT license](LICENSE.md).
