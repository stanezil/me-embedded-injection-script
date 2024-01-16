#!/bin/bash

# Prompt user for Aqua username
read -p "Enter Aqua username: " AQUA_USER

# Prompt user for Aqua password
read -sp "Enter Aqua password: " AQUA_PASSWORD
echo

# Prompt user for Aqua gateway URL
read -p "Enter Aqua gateway URL (e.g., your-aqua-gateway:port): " AQUA_GATEWAY

# Prompt user for enforcer group token
read -p "Enter Aqua Enforcer Group Token: " AQUA_ME_ENFORCERGROUP_TOKEN

# Prompt user for source container image name and tagging
read -p "Enter source container image name and tagging (e.g., myimage:tag): " SRC_IMAGE

# Prompt user for output container image name and tagging
read -p "Enter output container image name and tagging (e.g., myimage:tag): " DST_IMAGE

# Yellow text color
YELLOW='\033[1;33m'
NC='\033[0m'  # No color

echo -e "${YELLOW}Downloading aquactl...${NC}"
# Download aquactl binary
wget --user "$AQUA_USER" --password "$AQUA_PASSWORD" https://get.aquasec.com/aquactl/v3/aquactl
chmod +x aquactl

echo -e "${YELLOW}Downloading MicroEnforcer...${NC}"
# Download MicroEnforcer
wget --user "$AQUA_USER" --password "$AQUA_PASSWORD" https://download.aquasec.com/micro-enforcer/2022.4.460/x86/microenforcer
chmod +x microenforcer

echo -e "${YELLOW}Executing aquactl to inject...${NC}"

# Execute Aqua CLI to inject and display output in real-time
sudo ./aquactl inject --src-image "$SRC_IMAGE" --dst-image "$DST_IMAGE" \
                      --microenforcer-binary ./microenforcer --aqua-server "$AQUA_GATEWAY" \
                      --aqua-token "$AQUA_ME_ENFORCERGROUP_TOKEN" --new-ld-preload 2>&1 | while IFS= read -r line; do
    echo -e "${YELLOW}$line${NC}"
done

echo -e "${YELLOW}Cleaning up downloaded files...${NC}"
# Clean up downloaded files
rm -f aquactl microenforcer

echo -e "${YELLOW}Script execution completed.${NC}"