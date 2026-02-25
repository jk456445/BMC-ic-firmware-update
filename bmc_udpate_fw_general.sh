#!/bin/bash

# --- BMC Hardware Interface & Firmware Update Wrapper ---
# Description: A generic framework for managing hardware components via BMC CoAP API.
#              Supports I2C GPIO toggling for write-protection and FW deployment.

# ---------------------------------------------------------
# [CONFIG] - need to change bus and address for real usage
# ---------------------------------------------------------
BMC_IP=$1
FW_IMAGE=$2

I2C_API="api-v1/system/i2c"
UPDATE_API="api-v2/system/update"

TARGET_BUS_GROUP_A="10" 
TARGET_BUS_GROUP_B="11"
DEV_SLAVE_ADDR="0x50"  

REG_DIRECTION="0x00" 
REG_DATA_OUT="0x01"
DATA_BITMASK="{data={0xFF}}" # 通用遮罩

# ---------------------------------------------------------
# [FUNCTIONS]
# ---------------------------------------------------------


check_env() {
    if [ -z "$BMC_IP" ] || [ -z "$FW_IMAGE" ]; then
        echo "Usage: $0 <BMC_IP> <FW_IMAGE>"
        exit 1
    fi
}


unlock_hw_protection() {
    echo "[System] Toggling hardware write-protect pins..."
    
    local CMD_BASE="coap -J coaps+tcp://$BMC_IP/$I2C_API"

    for BUS in $TARGET_BUS_GROUP_A $TARGET_BUS_GROUP_B; do
        #set output direction
        $CMD_BASE/$BUS/$DEV_SLAVE_ADDR/$REG_DIRECTION -c "{byte_count=1}"
        $CMD_BASE/$BUS/$DEV_SLAVE_ADDR/$REG_DIRECTION -c "$DATA_BITMASK" -m PUT
        
        
        $CMD_BASE/$BUS/$DEV_SLAVE_ADDR/$REG_DATA_OUT -c "$DATA_BITMASK" -m PUT
    done
}


process_firmware_update() {
    local IMG=$1
    local IMG_SHA1=$(sha1sum "$IMG" | awk '{print $1}')
    local TASK_ID=$(date "+%Y%m%d%H%M%S")
    local COMPONENT_INDEX="0"

    echo "[Update] Starting deployment for Task: $TASK_ID"

    
    coap -f "$IMG" -m PUT "coaps+tcp://$BMC_IP/$UPDATE_API/$COMPONENT_INDEX/upload"

    #
    coap -J -c "{sha1sum='$IMG_SHA1'}" -m PUT "coaps+tcp://$BMC_IP/$UPDATE_API/$COMPONENT_INDEX/install/$TASK_ID"

    
    echo "[Update] Polling status... (300s interval)"
    sleep 300

    local STATUS_URL="coaps+tcp://$BMC_IP/$UPDATE_API/$COMPONENT_INDEX/status/$TASK_ID"
    local RESP=$(coap -c "{sha1sum='$IMG_SHA1'}" -m GET "$STATUS_URL")
    
    # grep to analysis results
    local RESULT=$(echo "$RESP" | grep -o 'status = "[^"]*"' | cut -d'"' -f2)

    if [ "$RESULT" = "success" ]; then
        echo "[Success] Firmware update completed successfully."
    else
        echo "[Error] Update state: $RESULT. Manual intervention required."
        exit 1
    fi
}

# ---------------------------------------------------------
# [MAIN]
# ---------------------------------------------------------
check_env
unlock_hw_protection
process_firmware_update "$FW_IMAGE"