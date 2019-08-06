# Deploy a master VM and three worker nodes on Azure. The purpose of this infrastructure is to allow for provisioning a Midas K8S cluster using Kubespray.
# You have to replace the variables in the "provider" structure and the ssh-key data found in each node (master or otherwise).
# Run this file with the usual Terraform commands "terraform plan" followed by "terraform apply".

# Configure the Microsoft Azure Provider
provider "azurerm" {
    subscription_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    client_id       = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    client_secret   = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    tenant_id       = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

# Create a resource group that we can assign Midas resources to
resource "azurerm_resource_group" "midas_resource_group" {
    name     = "Midas_Resources"
    location = "eastus"

    tags = {
        environment = "Midas_Azure"
    }
}

# Create virtual network for our Midas subnet to reside in
resource "azurerm_virtual_network" "midas_network" {
    name                = "Midas_Network"
    address_space       = ["10.0.0.0/16"]
    location            = "eastus"
    resource_group_name = "${azurerm_resource_group.midas_resource_group.name}"

    tags = {
        environment = "Midas_Azure"
    }
}

# Create subnet for all Midas VMs to reside within
resource "azurerm_subnet" "midas_subnet" {
    name                 = "Midas_Subnet"
    resource_group_name  = "${azurerm_resource_group.midas_resource_group.name}"
    virtual_network_name = "${azurerm_virtual_network.midas_network.name}"
    address_prefix       = "10.0.1.0/24"
}

# Create public IP for Master node
resource "azurerm_public_ip" "midas_public_ip_master" {
    name                         = "Midas_IP_Master"
    location                     = "eastus"
    resource_group_name          = "${azurerm_resource_group.midas_resource_group.name}"
    allocation_method            = "Dynamic"

    tags = {
        environment = "Midas_Azure"
    }
}

# Create Network Security Group and corresponding rules
resource "azurerm_network_security_group" "midas_nsg" {
    name                = "Midas_NSG"
    location            = "eastus"
    resource_group_name = "${azurerm_resource_group.midas_resource_group.name}"
    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "Midas_Azure"
    }
}

# Create network interfaces for Master and Worker nodes.
resource "azurerm_network_interface" "midas_ni_master" {
    name                      = "Midas_NI_Master"
    location                  = "eastus"
    resource_group_name       = "${azurerm_resource_group.midas_resource_group.name}"
    network_security_group_id = "${azurerm_network_security_group.midas_nsg.id}"

    ip_configuration {
        name                          = "Midas_IPConfig_Master"
        subnet_id                     = "${azurerm_subnet.midas_subnet.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.midas_public_ip_master.id}"
    }

    tags = {
        environment = "Midas_Azure"
    }
}

resource "azurerm_network_interface" "midas_ni_worker_1" {
    name                      = "Midas_NI_Worker_1"
    location                  = "eastus"
    resource_group_name       = "${azurerm_resource_group.midas_resource_group.name}"
    network_security_group_id = "${azurerm_network_security_group.midas_nsg.id}"

    ip_configuration {
        name                          = "Midas_IPConfig_Worker_1"
        subnet_id                     = "${azurerm_subnet.midas_subnet.id}"
        private_ip_address_allocation = "Dynamic"
    }

    tags = {
        environment = "Midas_Azure"
    }
}

resource "azurerm_network_interface" "midas_ni_worker_2" {
    name                      = "Midas_NI_Worker_2"
    location                  = "eastus"
    resource_group_name       = "${azurerm_resource_group.midas_resource_group.name}"
    network_security_group_id = "${azurerm_network_security_group.midas_nsg.id}"

    ip_configuration {
        name                          = "Midas_IPConfig_Worker_2"
        subnet_id                     = "${azurerm_subnet.midas_subnet.id}"
        private_ip_address_allocation = "Dynamic"
    }

    tags = {
        environment = "Midas_Azure"
    }
}

resource "azurerm_network_interface" "midas_ni_worker_3" {
    name                      = "Midas_NI_Worker_3"
    location                  = "eastus"
    resource_group_name       = "${azurerm_resource_group.midas_resource_group.name}"
    network_security_group_id = "${azurerm_network_security_group.midas_nsg.id}"

    ip_configuration {
        name                          = "Midas_IPConfig_Worker_3"
        subnet_id                     = "${azurerm_subnet.midas_subnet.id}"
        private_ip_address_allocation = "Dynamic"
    }

    tags = {
        environment = "Midas_Azure"
    }
}

# Generate random text for a unique storage account name
resource "random_id" "midas_random_id" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = "${azurerm_resource_group.midas_resource_group.name}"
    }
    
    byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "midas_storage_acct" {
    name                        = "diag${random_id.midas_random_id.hex}"
    resource_group_name         = "${azurerm_resource_group.midas_resource_group.name}"
    location                    = "eastus"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "Midas_Azure"
    }
}

# In terms of keys, we wish to configure the Master VM to have a known_host of the system that's doing the running provisioning.
# For all remaining VMs, we want to configure their known_host with a public key belonging to the Master VM.
# Create Master VM - for use as the master node in Midas K8S cluster
resource "azurerm_virtual_machine" "midas_master_vm" {
    name                  = "Midas_Master_VM"
    location              = "eastus"
    resource_group_name   = "${azurerm_resource_group.midas_resource_group.name}"
    network_interface_ids = ["${azurerm_network_interface.midas_ni_master.id}"]
    vm_size               = "Standard_B1ms"
	
	delete_os_disk_on_termination = true
    delete_data_disks_on_termination = true

    storage_os_disk {
        name              = "Midas_Master_Disk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "MidasMasterVM"
        admin_username = "midas_master"
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/midas_master/.ssh/authorized_keys"
            key_data = "ssh-rsa your-pub-rsa you@pc"
        }
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.midas_storage_acct.primary_blob_endpoint}"
    }

    tags = {
        environment = "Midas_Azure"
    }
}

# Create some worker nodes.

resource "azurerm_virtual_machine" "midas_worker_vm_1" {
    name                  = "Midas_Worker_VM_1"
    location              = "eastus"
    resource_group_name   = "${azurerm_resource_group.midas_resource_group.name}"
    network_interface_ids = ["${azurerm_network_interface.midas_ni_worker_1.id}"]
    vm_size               = "Standard_B1ms"
	
    delete_os_disk_on_termination = true
    delete_data_disks_on_termination = true

    storage_os_disk {
        name              = "Midas_Worker_VM_1_Disk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "MidasWorkerVM1"
        admin_username = "midas_worker_1"
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/midas_worker_1/.ssh/authorized_keys"
            key_data = "ssh-rsa your-pub-rsa you@pc"
        }
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.midas_storage_acct.primary_blob_endpoint}"
    }

    tags = {
        environment = "Midas_Azure"
    }
}

resource "azurerm_virtual_machine" "midas_worker_vm_2" {
    name                  = "Midas_Worker_VM_2"
    location              = "eastus"
    resource_group_name   = "${azurerm_resource_group.midas_resource_group.name}"
    network_interface_ids = ["${azurerm_network_interface.midas_ni_worker_2.id}"]
    vm_size               = "Standard_B1ms"
	
	delete_os_disk_on_termination = true
    delete_data_disks_on_termination = true

    storage_os_disk {
        name              = "Midas_Worker_VM_2_Disk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "MidasWorkerVM2"
        admin_username = "midas_worker_2"
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/midas_worker_2/.ssh/authorized_keys"
            key_data = "ssh-rsa your-pub-rsa you@pc"
        }
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.midas_storage_acct.primary_blob_endpoint}"
    }

    tags = {
        environment = "Midas_Azure"
    }
}

resource "azurerm_virtual_machine" "midas_worker_vm_3" {
    name                  = "Midas_Worker_VM_3"
    location              = "eastus"
    resource_group_name   = "${azurerm_resource_group.midas_resource_group.name}"
    network_interface_ids = ["${azurerm_network_interface.midas_ni_worker_3.id}"]
    vm_size               = "Standard_B1ms"
	
	delete_os_disk_on_termination = true
    delete_data_disks_on_termination = true

    storage_os_disk {
        name              = "Midas_Worker_VM_3_Disk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "MidasWorkerVM3"
        admin_username = "midas_worker_3"
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/midas_worker_3/.ssh/authorized_keys"
            key_data = "ssh-rsa your-pub-rsa you@pc"
        }
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.midas_storage_acct.primary_blob_endpoint}"
    }

    tags = {
        environment = "Midas_Azure"
    }
}
