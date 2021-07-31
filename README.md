# GitHub Action to Sync S3 Bucket

This simple action uses the [vanilla AWS CLI](https://docs.aws.amazon.com/cli/index.html) to sync a directory you specify with this actions' arguments

## Usages

Create workflow YAML file in `.github/workflows/` directory of your app. 

Go to Project's settings in GitHub, Click `Secret`, create the Secret key/values as mentioned in the docs below. On every reelease, this action should run.

Example of the workflow is given below:



### `my-workflow.yml` Example

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
      - uses: samifiaz/gh-action-docker@master
        env:
          AWS_S3_BUCKET: ${{ secrets.AWS_S3_BUCKET }}
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_REGION: "us-west-1" # optional: defaults to us-east-1
          SOURCE_DIR: "dist" # optional: defaults to `dist` directory
```

| Key                     | Value                                                                                                                                                                                                                                                                                                                                  | Suggested Type | Required | Default                                                            |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | -------- | ------------------------------------------------------------------ |
| `AWS_ACCESS_KEY_ID`     | Your AWS Access Key. [More info here.](https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html)                                                                                                                                                                                                                    | `secret env`   | **Yes**  | N/A                                                                |
| `AWS_SECRET_ACCESS_KEY` | Your AWS Secret Access Key. [More info here.](https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html)                                                                                                                                                                                                             | `secret env`   | **Yes**  | N/A                                                                |
| `AWS_S3_BUCKET`         | The name of the bucket you're syncing to. For example, `my-app-releases`.                                                                                                                                                                                                                                                 | `secret env`   | **Yes**  | N/A                                                                |
| `AWS_REGION`            | The region where you created your bucket. Set to `us-east-1` by default. [Full list of regions here.](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions)                                                                                                            | `env`          | No       | `us-east-1`                                                        |
| `SOURCE_DIR`            | The local directory (or build directory) you wish to sync/upload to S3 against those release version. For example, `dist`, `public`.                                                                                                                                                                                                                 | `env`          | No       | If nothing is passed, `dist` will be considered your app/build directory                                |
                                     |

## License

This project is distributed under the [MIT license](LICENSE.md).
