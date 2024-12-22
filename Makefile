assert-command = $(if $(shell which $1),,$(error '$1' command is missing))
assert-var = $(if $($1),,$(error $1 variable is not assigned))

$(call assert-command,gcloud)
$(call assert-command,terraform)

DIR = $(shell pwd)/environments/$(ENV)
TFCMD := terraform -chdir=$(DIR)

check-variables:
	@$(call assert-var,ENV)

init: check-variables
	@$(TFCMD) init

plan: check-variables
	@$(TFCMD) fmt && $(TFCMD) validate && $(TFCMD) init && $(TFCMD) plan

apply: check-variables
	@$(TFCMD) apply -auto-approve
