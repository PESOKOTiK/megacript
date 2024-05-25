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

# Function to open ports with UFW for TCP and UDP
open_ports() {
    read -p "Enter TCP ports to open (separated by space): " -a tcp_ports
    read -p "Enter UDP ports to open (separated by space): " -a udp_ports

    # Open TCP ports
    if [ ${#tcp_ports[@]} -ne 0 ]; then
        echo "Opening TCP ports: ${tcp_ports[@]}"
        for port in "${tcp_ports[@]}"; do
            if [[ $port =~ ^[0-9]+$ ]]; then
                sudo ufw allow $port/tcp
            else
                echo "Invalid port number: $port"
            fi
        done
    else
        echo "No TCP ports specified."
    fi

    # Open UDP ports
    if [ ${#udp_ports[@]} -ne 0 ]; then
        echo "Opening UDP ports: ${udp_ports[@]}"
        for port in "${udp_ports[@]}"; do
            if [[ $port =~ ^[0-9]+$ ]]; then
                sudo ufw allow $port/udp
            else
                echo "Invalid port number: $port"
            fi
        done
    else
        echo "No UDP ports specified."
    fi

    # Enable UFW if not already enabled
    sudo ufw enable
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

# Action 3: Open ports with UFW
read -p "3) Open ports with UFW (y/n)? " ufw_choice
if [[ $ufw_choice == "y" || $ufw_choice == "Y" ]]; then
    open_ports
else
    echo "Skipping opening ports with UFW."
fi

echo "Script completed."
