# variables.tfvars

primary_resource_group_name = "tfrg-p"
secondary_resource_group_name = "tfrg-s"
primary_location = "East US"
secondary_location = "Central US"
vm_name = "tf-vm"
vm_size = "Standard_B1s"
source_image_id = "/subscriptions/bf18f464-1469-4216-834f-9c6694dbfe26/resourceGroups/cloud-demo/providers/Microsoft.Compute/images/testvm-image"
vm_admin_username = "azureadmin"
vm_admin_password = "H3r3andth3r3"
computer_name = "tf-vm"
vault_name = "tfvault"
vault_sku = "Standard"
primary_fabric_name = "primary-fabric"
secondary_fabric_name = "secondary-fabric"
primary_container_name = "primary-protection-container"
secondary_container_name = "secondary-protection-container"
policy_name = "policy"
container-mapping_name = "container-mapping"
network-mapping_name = "network-mapping"
primary_sa_name = "tfrgsa"
storage_account_tier = "Standard"
sa_replication_type = "LRS"
primary_vnet_name = "tf-vm-vnet"
secondary_vnet_name = "tf-vm-vnet-s"
primary_subnet_name = "default"
secondary_subnet_name = "default"
primary_vnet_address_space = ["10.9.0.0/16"]
secondary_vnet_address_space = ["10.15.0.0/16"]
primary_subnet_address_space = ["10.9.0.0/24"]
secondary_subnet_address_space = ["10.15.0.0/24"] 
primary_public_ip_name = "tf-vm-ip"
primary_ip_allocation_method = "Static"
secondary_public_ip_name = "tf-vm-ip-s"
secondary_ip_allocation_method = "Dynamic"
ip_sku = "Standard"
s_ip_sku = "Basic"
nic_name = "tf-vm449"
vm-replication_name = "vm-replication"
disk_type = "Standard_LRS"
recovery_plan_name = "tf-recover-plan"
tagname = "Irfana"



# Add more variables as needed...
