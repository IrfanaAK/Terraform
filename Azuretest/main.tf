provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm"{
    resource_group_name = "cloud-demo"
    storage_account_name = "testcloud001423"
    container_name = "terraform"
    key = "terraformtest1.tfstate"
 }
}

# Define the existing virtual network and subnet
data "azurerm_subnet" "existing_subnet" {
  #for_each = var.resourcedetails
  name                 = var.subnetname     #each.value.subnet_name
  virtual_network_name = var.vnetname      #azurerm_virtual_network.myvnet[each.key].name
  resource_group_name  = var.RG    #data.azurerm_resource_group.existing_rg.name
}

# Create a public IP address
resource "azurerm_public_ip" "vm_public_ip" {
  count               = length(var.vm_names)
  name                = "public-ip-${var.vm_names[count.index]}"
  location            = var.location
  resource_group_name = var.RG
  allocation_method   = "Dynamic"
  sku                 = "Basic" 
  tags = {
    "Project" = "${var.project}"
    "Duration" = "${var.duration}"
    "Owner" = "${var.owner}"
  }
}

# Define the network interface for the VM and attach the public IP
resource "azurerm_network_interface" "vm_nic" {
  count               = length(var.vm_names)
  name                = "${var.vm_names[count.index]}"
  location            = var.location
  resource_group_name = var.RG

  ip_configuration {
    name                          = "${var.vm_names[count.index]}"
    subnet_id                     = data.azurerm_subnet.existing_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.ip[count.index]
    public_ip_address_id          = element(azurerm_public_ip.vm_public_ip.*.id, count.index)
  }
  tags = {
    "Project" = "${var.project}"
    "Duration" = "${var.duration}"
    "Owner" = "${var.owner}"
  }
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "main" {
     count                 = length(var.vm_names)
    name                  = "${var.vm_names[count.index]}"
    location              = var.location #azurerm_resource_group.myrg[each.key].location
    resource_group_name   = var.RG   #data.azurerm_resource_group.existing_rg.name
    network_interface_ids = [element(azurerm_network_interface.vm_nic.*.id, count.index)]
    size                  =  var.vm_size

 admin_username = "${var.username}"
 admin_password = "${var.password}"
 disable_password_authentication = false

 os_disk {
 name = "main-os-disk-${var.vm_names[count.index]}"
 caching = "ReadWrite"
 storage_account_type = "${var.disktype}"
}

 source_image_id = "${var.sourceimageid}"

 # zone = "${var.zone}"

 boot_diagnostics {
    storage_account_uri = "${var.bootdiagnostic}"
  }

  tags = {
    "Project" = "${var.project}"
    "Duration" = "${var.duration}"
    "Owner" = "${var.owner}"
  }
}

# creating data disk
resource "azurerm_managed_disk" "source1" {
depends_on = [azurerm_linux_virtual_machine.main]
for_each = var.data_disk
  name                 = each.value.disk_name
  location             = var.location
  resource_group_name  = var.RG   #data.azurerm_resource_group.existing_rg.name
  storage_account_type = "${var.datadisktype}"
  create_option        = "Empty"
  disk_size_gb         = each.value.disk_size
  # zone                 = "${var.zone}"

  tags = {
    "Project" = "${var.project}"
    "Duration" = "${var.duration}"
    "Owner" = "${var.owner}"
  }
}

# Attach the disk to the existing virtual machine
resource "azurerm_virtual_machine_data_disk_attachment" "source2" {
depends_on = [azurerm_linux_virtual_machine.main,azurerm_managed_disk.source1]
  for_each = var.data_disk
  managed_disk_id    = lookup({for k, source1 in azurerm_managed_disk.source1 : k => source1.id}, each.value.disk_name, "what?")
  virtual_machine_id = each.value.vm_name
  lun                = each.value.lun
  caching            = "ReadWrite"
}
