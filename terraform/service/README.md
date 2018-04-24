base 
-----

`service` package is responsible for the following:

* managing/deploying ecs service
* creating ecs task definitions
* managing associated security groups
* managing associated iam profile(s)

### Prerequisites

* Configure your environment with aws credentials: `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`

* Before you can use this package, you'll need to make sure that `terraform` is 
installed.  [[Download Terraform](https://www.terraform.io/downloads.html)].  
Make sure `terraform` is in your `PATH`

* In the `base` directory, you'll need to pull terraform's dependencies.  Run

```bash
  terraform init
```

### Using this package

Once all that's set up, you can run:

```bash
  terraform apply
```

To setup the base services.  `terraform apply` is idempotent so running it multiple
times is fine.   

### Delete

To remove the services created by terraform, you can run 

```bash
  terraform destroy
```

and this will remove services created.

