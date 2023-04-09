import paramiko
import getpass
import time
import matplotlib.pyplot as plt



server = {"hostname": "192.168.100.8", "port": "22", "username": "escris"}
password = getpass.getpass("write your password: ")

def execute_command(client, command):
    session = client.get_transport().open_session()
    session.exec_command(command)
    result = ""

    while not session.exit_status_ready():
        time.sleep(1)
        while session.recv_ready() or session.recv_stderr_ready():
            if session.recv_ready():
                result += session.recv(1024).decode()
            if session.recv_stderr_ready():
                result += session.recv_stderr(1024).decode()

    return result

if __name__ == "__main__":

    client = paramiko.SSHClient()

    try:
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        client.connect(**server, password=password)

        cpu_usage = execute_command(client, r"top -bn1 | grep Cpu | awk '{print $8}' | awk '{print 100 - $1}'" )
        mem_command = execute_command(client, r"free -m | grep Memoria:").split()
        disk_usage = execute_command(client, "df -h --total | grep total").split()
        net_ms = execute_command(client, f"ping -c 5 -i 0.2 -s 32 {server['hostname']} | grep rtt  ").split("/")

        # Network MS
        net_max = net_ms[5]
        net_min = net_ms[3].split('=')[1].strip()

        # CPU Info
        cpu_free = float(100 - float(cpu_usage)) 

        # Memory Ram Info 
        total_mem_used = mem_command[2]
        total_mem_available = mem_command[6]

        # Disk Info

        disk_used = disk_usage[2].split('G')[0]
        disk_free = disk_usage[3].split('G')[0]

        # Create a single window with subplots for CPU, memory, and disk usage
        fig, axs = plt.subplots(2, 3, figsize=(12, 6))

        # Create a bar plot for CPU usage
        axs[0, 0].bar(["Used", "Free"], [float(cpu_usage), cpu_free])
        axs[0, 0].set_title("CPU %")
        axs[0, 0].set_ylabel("%")
        axs[0, 0].set_ylim(0, 100)


        # Create a bar plot for memory usage
        axs[0, 1].bar(["Used", "Free"], [int(total_mem_used), int(total_mem_available)])
        axs[0, 1].set_title("Memory GB")
        axs[0, 1].set_ylabel("MB")
    
        # Create a bar plot for disk usage
        axs[0, 2].bar(["Used", "Free"], [int(disk_used), int(disk_free)])
        axs[0, 2].set_title("Disk GB")
        axs[0, 2].set_ylabel("GB")

        # Create a bar plot for network usage
        axs[1, 0].bar(["Min", "Max"], [float(net_max), float(net_min)])
        axs[1, 0].set_title("Network ms")
        axs[1, 0].set_ylabel("ms")

        # Show the plots in a single window
        plt.tight_layout()
        plt.show()
        
        client.close()

    except paramiko.ssh_exception.AuthenticationException as e:
        print(f"{e}")
