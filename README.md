# terraform-s3-static-site-example

This repo contains simple example on how to create AWS infrastructure to host static website(s) in S3 using Terraform.

## Prerequisites

These dependencies are needed to be able to run the commands locally.

- Terraform ([tfenv](https://github.com/tfutils/tfenv))
- Node.js ([nvm](https://github.com/nvm-sh/nvm))
- [AWS CLI](https://aws.amazon.com/cli/)

## Infra

1. Run Terraform init to intitialize the working directory with needed configs:

```bash
npm run infra:init -w=infra
```

2. Run Terraform plan to create execution plan and preview changes:

```bash
npm run infra:plan -w=infra
```

3. Run Terraform apply the planned changes to infra:

```bash
npm run infra:apply -w=infra
```

4. *(Optional)* Destroy the created infra:

```bash
npm run infra:destroy -w=infra
```

## Site

The site is plain [Next.js application](https://nextjs.org/) from which we will take static export and deploy that to the S3 by using AWS CLI. This step happens inside the [GitHub workflow](./.github/workflows/site.yml).

Basically what we do is:

```bash
aws s3 sync packages/site/out s3://my-bucket/
```

### Caveats

While Next.js site can be statically exported by using the `next export` command, it has some limited features that you should be aware of. The supported and unsupported features are listed here: https://nextjs.org/docs/advanced-features/static-html-export