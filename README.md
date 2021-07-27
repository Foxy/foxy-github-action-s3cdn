# GitHub Action to Sync S3 Bucket

This simple action uses the [vanilla AWS CLI](https://docs.aws.amazon.com/cli/index.html) to sync a directory you specify with this actions' arguments

## Usages

### `workflow.yml` Example

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
          SOURCE_DIR: "dist" # optional: defaults to entire repository
```

| Key                     | Value                                                                                                                                                                                                                                                                                                                                  | Suggested Type | Required | Default                                                            |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | -------- | ------------------------------------------------------------------ |
| `AWS_ACCESS_KEY_ID`     | Your AWS Access Key. [More info here.](https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html)                                                                                                                                                                                                                    | `secret env`   | **Yes**  | N/A                                                                |
| `AWS_SECRET_ACCESS_KEY` | Your AWS Secret Access Key. [More info here.](https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html)                                                                                                                                                                                                             | `secret env`   | **Yes**  | N/A                                                                |
| `AWS_S3_BUCKET`         | The name of the bucket you're syncing to. For example, `jarv.is` or `my-app-releases`.                                                                                                                                                                                                                                                 | `secret env`   | **Yes**  | N/A                                                                |
| `AWS_REGION`            | The region where you created your bucket. Set to `us-east-1` by default. [Full list of regions here.](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions)                                                                                                            | `env`          | No       | `us-east-1`                                                        |
| `AWS_S3_ENDPOINT`       | The endpoint URL of the bucket you're syncing to. Can be used for [VPC scenarios](https://aws.amazon.com/blogs/aws/new-vpc-endpoint-for-amazon-s3/) or for non-AWS services using the S3 API, like [DigitalOcean Spaces](https://www.digitalocean.com/community/tools/adapting-an-existing-aws-s3-application-to-digitalocean-spaces). | `env`          | No       | Automatic (`s3.amazonaws.com` or AWS's region-specific equivalent) |
| `SOURCE_DIR`            | The local directory (or file) you wish to sync/upload to S3. For example, `public`. Defaults to your entire repository.                                                                                                                                                                                                                | `env`          | No       | `./` (root of cloned repository)                                   |
| `DEST_DIR`              | The directory inside of the S3 bucket you wish to sync/upload to. For example, `my_project/assets`. Defaults to the root of the bucket.                                                                                                                                                                                                | `env`          | No       | `/` (root of bucket)                                               |

## License

This project is distributed under the [MIT license](LICENSE.md).
