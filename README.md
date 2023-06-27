# ds-infrastructure-private-beta

## Requisites
Before a successful ```terraform apply``` can be run following requisites need to be in place.
* Run ```terraform apply``` on **ds-infrastructure**
* Add values manually to _Systems Manager Parameter Store_
* Add values manually to _Secrets Manager_
* Create several AMIs in **ds-ami-build**
### ds-infrastructure
Running ```terraform apply``` on **ds-infrastructure** will create most of the basic networking and services on which private beta will run.
### Database
The private beta installation depends on the existence of a PostgreSQL database.
It is highly recommended to run at least one replica in the live environment.
Use the GitHub Action in **ds-ami-build** repo to prepare the ami(s) which will be use during ```terraform apply``` on **ds-infrastructure**.
### Systems Manager Parameter Store
Most values required will me set during ```terraform apply``` in **ds-infrastructure**.
Following values would need to be stored manually in the _Systems Manager Parameter Store_:
* /infrastrcuture/private_beta_waf_ipset - comma separated string containing either a list of allowed or blocked IP address ranges in CIDR notation.
* /infrastructure/certificate-manager/wildcard-certificate-arn - containing the certificate arn for the valid wildcard certificate; might have been put in place by other application installations.
* /infrastructure/certificate-manager/us-east-1-wildcard-certificate-arn - wildcard certificate used by CloudFront; similar to the wildcard certificate for the domain above.
### Secrets Manager
This are database or other secrets which are confidential and should not be saved in a repository.
### AMI builds
Please read any documentation in the **ds-ami-build** repo in regards of the required build for further information.
* NginX instance - private-beta-rp-primer*
* Wagtail instance - private-beta-dw-primer*
