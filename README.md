
# spin-simple-stack

This is a reference infrastructure project which defines a simple, self-contained stack with a single server. The purpose is to explore project structures and tooling, to demonstrate the implementation of a pipeline for infrastructure, and to create a starting point for new projects.


## Purpose

Many teams starting infrastructure projects spend too much time on work that is essential, but low value. Examples include deciding how to structure projects and wire various pieces together. Obviously we need to do these things, but we shouldn't need to re-do them on every project.

These cloudspin projects are intended to explore conventions for structuring projects, and for integrating code and infrastructure within and between projects. What you see here is very early, however, so is likely to involve into something quite different.

Another issue is that can take time for a team new to infrastructure as code to learn effective patterns and practices, and learn how to apply them to their systems. So these projects are designed to illustrate some key patterns and practices, such as the use of automated testing and pipelines for delivering changes. Over time we'll publish content that describes these, with this code as a reference.

Teams are welcome to use these cloudspin projects as seeds for their own projects. The intention is that these will become fully usable, and useful, following good practices for security and operability.


## Tech stack

We've selected various technologies and tools to implement these projects.

Our initial set of projects are based on AWS. We've started with AWS because it's the platform we've worked with most often. We have deeper familiarity with it, and we expect most people will have some familiarity with it. The concepts should apply to other platforms. We're hoping to expand to provide reference projects for other platforms as well.

- *Environment definition*: We're using Terraform to define environments, mainly because it can be used to define infrastructure for multiple infrastructure platforms. We are not expecting to create reference projects using other tools. However, we believe Terraform is easily understood, and the concepts and patterns should be understandable by teams using alternative tools.
- *Server configuration*: We may use Ansible. We haven't decided whether to use other tools.
- *Server image building*: Packer. We aren't aware of viable alternatives, and it does the job.
- *Testing*: At the moment, we're using the Ruby Rspec ecosystem, including serverspec, awspec. Also test-kitchen. This is an area that's likely to evolve.
- *Local scripting*: Makefiles so far, although this may evolve. Infrablocks is using Rake with custom extensions. Bash? We seem to be more Ruby-oriented than Python.

For other tools and applications, we ought to be able to support swapping in alternatives. For example, we can provide projects that implement ConcourseCI, GoCD, and Jenkins, and a team can choose which one to use.

- *Monitoring*: Prometheus, ...?
- *CI/CD*: AWS CodePipeline, Concourse, GoCD, Jenkins
- *Container clusters*: Kubernetes, EKS, ECS, ....


## Related projects

- This projects assumes the AWS account has been set up using [spin-bootstrap](https://github.com/kief/spin-bootstrap), particularly the remote statefile bucket, and some IAM roles.
- This project uses [Infrablocks](https://github.com/infrablocks) modules.


# About the simple environment project

This project defines a fully usable, self-contained infrastructure stack with a single server. It does not depend on anything other than the account bootstrap.

## The use case

We have an application that is deployed onto a single server. We use a stock AMI, pull the application when provisioning the server. We have an automated test for the application. Pipeline that tests it, allows a manual review, and pushes it to production.

Follows our core CFRs for security (locked down to our own IP address, although the code can be changed to override it to a defined set of addresses), SSL.

The service includes all of the infrastructure it needs beyond the account baseline, such as VPC and subnets. Multiple instances of the service can be deployed into a single AWS account. The developer can spin up a sandbox instance in the AWS account from their local workstation, so they can edit and debug before pushing changes through the pipeline.

There is no data, and no per-instance configuration.

# Usage

To manage the project as an entity, use the Makefile in the base of the **simple-stack** folder. Run `make` to see what it can do. This is about managing the project in source control and pipelines.

To manage an instance of the project (i.e. a server and its infrastructure), use the Makefile in the **simple-stack/infra** folder. Run `make` without any arguments in that folder to see how to use it.



# Using rake-cloudspin

## Random notes

Export your PGP key for use in Terraform:

```bash
gpg --export YOUR_KEY_ID | base64
```

Decrypt secret access key output from Terraform:

```bash
echo ENCRYPTED_STRING | GPG_TTY=$(tty) base64 --decode | gpg -d
```

## Config

```
[kief_api_user]
region = eu-west-1

[profile stack_manager]
role_arn = ${OUTPUT.STACK_MANAGER_ROLE_ARN}
source_profile = kief_api_user
```

## Testing

Should work:
```bash
aws --profile kief_api_user --region eu-west-1 sts get-caller-identity
```

Should not work (UnauthorizedOperation):
```bash
aws --profile kief_api_user --region eu-west-1 ec2 describe-instances
```

Should work:
```bash
aws --profile stack_manager --region eu-west-1 ec2 describe-instances
```



