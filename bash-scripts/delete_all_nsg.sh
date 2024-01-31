echo "Loading variables:"
echo "network_config.sh"
source ./network_config.sh
echo "backend_config.sh"
source ./backend_config.sh
echo "Loaded variabes without error"

echo 
echo "---------------------------------------------------"
echo "Delting Netwrok Security Groups"
echo "---------------------------------------------------"
echo
for nsg_name in "${nsg_list[@]}"
do
echo "---------------------------------------------------"
echo "Check if exist: $nsg_name"
echo "---------------------------------------------------"
if [[ $(az network nsg list -g $RG_NAME -o tsv --query "[?name=='$nsg_name']") ]]
then
    echo "exists!"
    echo "Deleteing NSG: $nsg_name"
    az network nsg delete -g $RG_NAME --name $nsg_name --yes
fi
done

echo "All Netwrok Security Groups were deleted successfully!"
echo "NSG List"
az network nsg list -g $RG_NAME --out table

