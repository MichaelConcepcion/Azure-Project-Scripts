echo
echo
echo "---------------------------------------------------"
echo "---------------------------------------------------"
echo 
echo "    ____  ___   ___          __                    "
echo "    |     |__   |__|  |_|   |__   |                "   
echo "    |___   __|  |       |    __|  |                " 
echo
echo "---------------------------------------------------"
echo "---------------------------------------------------"
echo 

echo "Loading variables:"
echo "network_config.sh"
source ./network_config.sh
echo "vm_config.sh"
source ./vm_config.sh
echo "Loaded variabes without error"

function windows_vm_create () {
vm_name=$1
image_name=$2
nic_name=$3

echo "---------------------------------------------------"
echo "VM: $vm_name"
echo "---------------------------------------------------"
echo "Check if it already exists ---"
if [[ $(az vm list -g $RG_NAME -o tsv --query "[?name=='$vm_name']") ]]
then
    echo "exists!"
    az vm show -g $RG_NAME --name $vm_name --query id 
else
    echo "doesn't exist!"
    echo "Do you want to create VM: $vm_name? (yes/no)"
    read -r answer
    if [[ "$answer" == "yes" ]]; then

        az vm create --name $vm_name -g $RG_NAME  \
                --location $LOCATION \
                --admin-password $ADMIN_PW --admin-username $USER_NAME \
                --image  $image_name \
                --size  $VM_SIZE \
                --storage-sku $OS_DISK_SKU \
                --data-disk-delete-option Delete \
                --nics  $nic_name \
                --no-wait
        # if [ $? ]; then echo "Returned Error! Aborting!"; exit 2; fi
    fi
fi
}

function linux_vm_create () {
vm_name=$1
image_name=$2
nic_name=$3

echo "---------------------------------------------------"
echo "VM: $vm_name"
echo "---------------------------------------------------"
echo "Check if it already exists ---"
if [[ $(az vm list -g $RG_NAME -o tsv --query "[?name=='$vm_name']") ]]
then
    echo "exists!"
    az vm show -g $RG_NAME --name $vm_name --query id 
else
    echo "doesn't exist!"
    echo "Do you want to create VM: $vm_name? (yes/no)"
    read -r answer
    if [[ "$answer" == "yes" ]]; then

        az vm create --name $vm_name -g $RG_NAME  \
                --location $LOCATION \
                --admin-password $ADMIN_PW --admin-username $USER_NAME \
                --image  $image_name \
                --size  $VM_SIZE \
                --storage-sku $OS_DISK_SKU \
                --data-disk-delete-option Delete \
                --nics  $nic_name \
                --ssh-key-values $public_sshkey_file \
                --no-wait
        # if [ $? ]; then echo "Returned Error! Aborting!"; exit 2; fi
    fi
fi
}

echo 
echo "---------------------------------------------------"
echo "Virtual Machines"
echo "---------------------------------------------------"
echo

windows_vm_create "$VM_WC" "$VM_IMG_WC" "$NIC_WC"
windows_vm_create "$VM_WS" "$VM_IMG_WS" "$NIC_WS"
linux_vm_create "$VM_LR" "$VM_IMG_LR" "$NIC_LR"
linux_vm_create "$VM_LS" "$VM_IMG_LS" "$NIC_LS"

echo
echo "---------------------------------------------------"
echo "Configuring Auto shutdown for all VMs at 0500 UTC"
echo "---------------------------------------------------"
echo

shutdown_time="0500"

for vm_name in "${vm_list[@]}"
do
echo "---------------------------------------------------------------------"
echo "Creating auto-shutdown schedule for: $vm_name"
echo "---------------------------------------------------------------------"
# read -r answer
# if [[ "$answer" == "yes" ]]; then
    az vm auto-shutdown -g $RG_NAME -n $vm_name --location $LOCATION --time $shutdown_time
# fi
done

echo
echo "---------------------------------------------------"
echo "VMs created without error!"
echo "END!"
echo "---------------------------------------------------"
echo


