
# Simple environment

This project defines a fully usable, self-contained infrastructure stack with a single server. It does not depend on anything other than the account bootstrap.

# The use case

We have an application that is deployed onto a single server. We use a stock AMI, pull the application when provisioning the server. We have an automated test for the application. Pipeline that tests it, allows a manual review, and pushes it to production.

Follows our core CFRs for security (locked down to our own IP address, although the code can be changed to override it to a defined set of addresses), SSL.

The service includes all of the infrastructure it needs beyond the account baseline, such as VPC and subnets. Multiple instances of the service can be deployed into a single AWS account. The developer can spin up a sandbox instance in the AWS account from their local workstation, so they can edit and debug before pushing changes through the pipeline.

There is no data, and no per-instance configuration.

# Usage

To manage the project as an entity, use the Makefile in the base of the **simple-env** folder. Run `make` to see what it can do. This is about managing the project in source control and pipelines.

To manage an instance of the project (i.e. a server and its infrastructure), use the Makefile in the **simple-env/infra** folder. Run `make` without any arguments in that folder to see how to use it.

