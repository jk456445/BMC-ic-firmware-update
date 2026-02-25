BMC Component Maintenance Framework
A lightweight automation framework for managing hardware components via BMC CoAP APIs. This project demonstrates the automation of hardware register manipulation, secure firmware deployment, and asynchronous task tracking.

✨ Key Features
Hardware Protection Toggle: Automates the unlocking of hardware write-protection via I2C/GPIO Expander APIs.

Secure Deployment: Implements sha1sum verification to ensure firmware integrity during transfer.

Async Task Polling: Handles long-running flash tasks with a robust polling logic for success/failure detection.

Modular Config: Decouples hardware addresses (Bus/Slave Addr) from logic for high portability.

🚀 Usage
Bash
chmod +x bmc_updater.sh
./bmc_updater.sh <BMC_IP> <FIRMWARE_IMAGE>
🛠 Tech Stack
Bash: Core automation and flow control.

CoAP: Low-overhead network communication with BMC.

JSON Parsing: Status analysis from API responses.

⚠️ Disclaimer
This project is for technical demonstration only. All API paths, Bus IDs, and Register addresses have been de-identified and replaced with generic values for security purposes.
