# Securing OpenSSH 
This script and playbook help you secure your OpenSSH installation in Ubuntu. They perform the following actions:


- Update the operating system
- Install the OpenSSH client and server
- Verify that the ssh service is active and activate it if necessary
- Ensure that ssh is enabled and enable it if necessary
- Change the default port for ssh
- Disable root login through ssh
- Disable password authentication for ssh
- Allow specific users to connect via ssh
- Set the ClientAliveInterval to 300
- Set the ClientAliveCountMax to 0
- Disable ChallengeResponseAuthentication
- Finally, reload the ssh configuration

I hope these steps help you as they have helped me.