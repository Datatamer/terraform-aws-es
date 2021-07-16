package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformCreateES(t *testing.T) {
	// This creates this function with the possibility of being run in parallel with other functions
	// that start with this same t.Parallel() call.
	t.Parallel()

	namePrefix := "terratest-es"

	// Getting a random region between the US ones
	awsRegion := aws.GetRandomRegion(t, []string{"us-east-1", "us-east-2", "us-west-1", "us-west-2"}, nil)

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../examples/test_minimal",

		// Test Root Module Variables
		Vars: map[string]interface{}{
			"name-prefix": namePrefix,
		},
		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	})

	// Run destroy when this function exits
	defer terraform.Destroy(t, terraformOptions)
	// Run TF Init and Apply in the TerraformDir passed in options
	terraform.InitAndApply(t, terraformOptions)

	es_id := terraform.Output(t, terraformOptions, "tamr_es_domain_id")
	es_endp := terraform.Output(t, terraformOptions, "tamr_es_domain_endpoint")
	es_sg_ids := terraform.OutputList(t, terraformOptions, "es_security_group_ids")

	assert.NotNil(t, es_id)
	assert.NotNil(t, es_endp)
	assert.NotNil(t, es_sg_ids)

}
