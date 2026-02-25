🛠️ BMC Component Maintenance Framework
A lightweight automation framework for managing hardware components via BMC CoAP APIs. This project demonstrates professional-grade automation for hardware register manipulation, secure firmware deployment, and asynchronous task tracking.

✨ Key Features
🔒 Hardware Protection Toggle: Automates the unlocking of hardware write-protection via I2C/GPIO Expander APIs before flashing.

🛡️ Secure Deployment: Implements sha1sum verification to ensure end-to-end firmware integrity during transfer.

⏳ Async Task Polling: Handles long-running flash tasks with robust polling logic for success/failure detection.

🧩 Modular Configuration: Decouples hardware addresses (Bus/Slave Addr) from logic for high portability across different platforms.

🚀 Usage
[!IMPORTANT]
Pre-configuration Required: You must update the Bus, Address, Register, and API paths in the script's config section to match your specific hardware environment before execution.

Execution Steps

1.Grant permissions:

  chmod +x bmc_updater.sh

2.Run the updater:

  ./bmc_updater.sh <BMC_IP> <FIRMWARE_IMAGE>

🛠️ Technical Implementation

Protocol: CoAP (Constrained Application Protocol)

Hardware Interface: I2C / SMBus via BMC Bridge

Scripting: POSIX-compliant Bash

⚠️ Disclaimer
This project is for technical demonstration and portfolio purposes only.
To comply with security best practices and NDA requirements:

All API paths, Bus IDs, and Register addresses have been de-identified.

Values have been replaced with generic placeholders.

No vendor-specific proprietary logic is included.
