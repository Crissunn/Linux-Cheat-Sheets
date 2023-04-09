## Monitoring Server Information

This Python script uses the Paramiko library to monitor various performance metrics of a remote server using SSH. The script connects to the server, executes commands to obtain the current CPU usage, memory usage, disk usage and network latency, and displays the information using Matplotlib bar charts.

### Prerequisites

To run this script, you need to have the following installed:

* Python 3
* Paramiko library
* Matplotlib library

### Usage

The `server` variable must be modified to include the hostname or IP address of the server, along with the SSH port and username to be used for authentication. Additionally, the password variable must also be modified to include the password for the SSH authentication.

The `execute_command()` function uses the Paramiko library to execute the command passed as an argument on the remote server, and returns the output of the command.

The script calculates the CPU usage by executing the `top` command, and uses `grep` and `awk` to extract the CPU usage percentage. The memory usage is calculated using the `free` command and extracting the total used and available memory. The disk usage is calculated using the `df` command and extracting the total disk space used and free.

The network latency is calculated using the `ping` command, and the minimum and maximum latency times are extracted using `grep` and `awk`.

The script creates a single window with subplots for CPU usage, memory usage, disk usage, and network latency, and uses Matplotlib to create bar charts for each metric. The resulting charts are displayed on the screen.

This script can be used as a starting point for monitoring remote servers using SSH and can be customized to include additional performance metrics and visualizations.
