#!/bin/bash
#########################################
#                                       #
#     MEGA SCRIPT FROM PESOKOTiK        #
#                                       #
#     for my and maybe yours servers    #
#                                       #
#########################################
# Function to perform apt update and upgrade
update_upgrade() {
    echo "Updating and upgrading system..."
    sudo apt update
    sudo apt upgrade -y
}

# Function to create a swap file
create_swap_file() {
    read -p "Enter the size of the swap file in MB: " swapsize
    if [[ $swapsize =~ ^[0-9]+$ ]]; then
        echo "Creating swap file of size ${swapsize}MB..."
        sudo fallocate -l ${swapsize}M /swapfile
        sudo chmod 600 /swapfile
        sudo mkswap /swapfile
        sudo swapon /swapfile
        echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
        echo "Swap file created and activated."
    else
        echo "Invalid input. Please enter a valid number."
    fi
}

# Main script starts here
echo "Please select an action:"

# Action 1: Update and upgrade system
read -p "1) Update and upgrade system (y/n)? " update_choice
if [[ $update_choice == "y" || $update_choice == "Y" ]]; then
    update_upgrade
else
    echo "Skipping update and upgrade."
fi

# Action 2: Create swap file
read -p "2) Create swap file (y/n)? " swap_choice
if [[ $swap_choice == "y" || $swap_choice == "Y" ]]; then
    create_swap_file
else
    echo "Skipping swap file creation."
fi

echo "Script completed."
