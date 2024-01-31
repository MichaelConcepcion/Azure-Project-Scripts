source ./logos.sh
echo "Loading variables:"
echo "network_config.sh"
source ./network_config.sh
echo "backend_config.sh"
source ./backend_config.sh
echo "Loaded variabes without error"

echo 
echo "---------------------------------------------------"
echo "Delting Netwrok Interface Cards"
echo "---------------------------------------------------"
echo
for nic_name in "${nic_list[@]}"
do
echo "---------------------------------------------------"
echo "Check if exist: $nic_name"
echo "---------------------------------------------------"
if [[ $(az network nic list -g $RG_NAME -o tsv --query "[?name=='$nic_name']") ]]
then
    echo "exists!"
    echo "Deleteing NIC: $nic_name"
    az network nic delete -g $RG_NAME --name $nic_name --yes
fi
done


echo "All Netwrok Interface Cards were deleted successfully!"
echo "NIC List"
az network nic list -g $RG_NAME --out table
