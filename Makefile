ifneq ("$(wildcard Makefile.local)", "")
include Makefile.local
endif

AWS_PROFILE ?= shared-non-prod
MODULES_DIR := modules
TERRAFORM_DOCS := terraform-docs markdown

component ?= iac-role
account ?= aws-$(AWS_PROFILE)
region ?= us-west-2

export AWS_PROFILE

.PHONY: fmt
fmt:
	@terragrunt hclfmt --diff
	@terraform fmt -recursive

.PHONY: init
init:
	@cd deployments/accounts/$(account)/$(region)/$(component) && \
	terragrunt init -migrate-state

.PHONY: plan-all
plan-all:
	@cd deployments/accounts/$(account)/$(region) && \
	terragrunt run-all plan

.PHONY: plan
plan:
	@cd deployments/accounts/$(account)/$(region)/$(component) && \
	terragrunt plan

.PHONY: apply-all
apply-all:
	@cd deployments/accounts/$(account)/$(region) && \
	terragrunt run-all apply

.PHONY: apply
apply:
	@cd deployments/accounts/$(account)/$(region)/$(component) && \
	terragrunt apply

.PHONY: destroy
destroy:
	@cd deployments/accounts/$(account)/$(region)/$(component) && \
	terragrunt destroy

.PHONY: destroy-all
destroy-all:
	@cd deployments/accounts/$(account)/$(region) && \
	terragrunt run-all destroy

.PHONY: output-all
output-all:
	@cd deployments/accounts/$(account)/$(region) && \
	terragrunt run-all output

.PHONY: output
output:
	@cd deployments/accounts/$(account)/$(region)/$(component) && \
	terragrunt output

.PHONY: unlock
unlock:
ifndef id
	$(error Please specify the id variable for force-unlock, e.g., make unlock id=xxxxxxxx)
endif
	@cd deployments/accounts/$(account)/$(region)/$(component) && \
	terragrunt force-unlock $(id)

.PHONY: lint
TFLINT_CONFIG := $(PWD)/.tflint.hcl
TFLINT_OPTS ?= --recursive
lint:
	@which tflint > /dev/null || (echo "tflint not found. Please install it first." && exit 1)
	@tflint $(TFLINT_OPTS) --config $(TFLINT_CONFIG)

.PHONY: sec
sec:
	@which trivy > /dev/null || (echo "trivy not found. Please install it first." && exit 1)
	@trivy config . -q

.PHONY: clean
clean:
	@cd deployments/accounts/$(account)/$(region) && \
	find . -type d -name ".terragrunt-cache" -exec rm -rf {} +

.PHONY: clean-lock
clean-lock:
	@cd deployments/accounts/$(account)/$(region) && \
	find . -type f -name ".terraform.lock.hcl" -exec rm -rf {} +

.PHONY: docs
docs:
	@which terraform-docs > /dev/null || (echo "terraform-docs not found. Please install it first." && exit 1)
	@for dir in $(MODULES_DIR)/*/; do \
		echo "Generating docs for $$dir"; \
		(cd $$dir && $(TERRAFORM_DOCS) . > TF_README.md); \
	done
