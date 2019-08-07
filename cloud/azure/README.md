# Deploying a Midas Kubernetes cluster on Azure using Terraform and Kubespray

1. Run ``set_azure_vars_for_tf.sh``. Login to your Azure account when it asks. This will configure a few variables to your environment needed to successfully pursue an Azure session.

2. Leverage the variables set by (1) by adding the appropriate values to the 'xxxx...'s found in the ``provision_midas_vms_on_azure.tf`` file. Additionally, replace the phony SSH public RSA key values found in each VM listing of this file with the real public RSA key you have on hand. Then, run:
```shell
terraform plan
terraform apply
```

3. SSH into the Master VM, and run a ``ssh-keygen``. Accept the default location and copy the key to your clipboard. Then, go onto the Azure Portal in your favorite browser. For each worker node resource, go in, select "Reset password", "Reset SSH Key", and add this copied key to the key section, along with the proper username (e.g. "midas-worker-1"). Hit save.


