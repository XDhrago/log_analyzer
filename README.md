# Apache Log File Analyzer

A Bash script that provides an interactive menu to analyze Apache log files. It offers various utilities such as listing IPs, checking for known hacker tools, and generating reports based on log data.

## Features

- ✅ Define and change the log file path
- 📄 View the first and last lines of the log file
- 🔍 Filter log entries by specific IP addresses
- 📊 List all involved IPs and show the top 5
- 🛡️ Detect usage of known hacker tools (Nmap, Nikto, Nessus, curl)
- 🧾 Generate a comprehensive report
- 🧼 Clear the screen
- ❌ Exit the script

## Requirements

- Bash (Linux/macOS)
- Apache log file (e.g., `access.log`)

## Usage

### 1. Make the script executable:
   ```bash
   chmod +x script_analyzer.sh
   ```

### 2. Run the script
./script_analyzer.sh


### 3. Follow the on-screen menu to interact with the log file.
#### Menu Options
- Define log file path – Set the path to your Apache log file.
- Show first and last lines – Display the first and last 5 lines of the log.
- Show lines for specific IP – Filter and show entries for a given IP.
- List involved IPs – List all unique IPs found in the log.
- Top 5 involved IPs – Show the top 5 IPs based on request count.
- Check for known hacker tools – Scan for tools like Nmap, Nikto, Nessus, and curl.
- Generate full report – Combines top IPs, their log entries, and tool detection.
- Clear the screen
- Exit

## Notes
- The script includes IP validation to ensure correct input.
- Color-coded output improves readability.
- Designed for educational and administrative use.
## License
This project is licensed under the MIT License.

## Author
Marcos Pereira – Contributions welcome!

