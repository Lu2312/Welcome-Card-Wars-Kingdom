import subprocess
import sys

def run_ssh_command(cmd_list):
    ssh_cmd = [
        'ssh', 
        '-o', 'StrictHostKeyChecking=no', 
        '-o', 'ConnectTimeout=10', 
        'root@159.89.157.63',
        '; '.join(cmd_list)
    ]
    print(f"Executing remote commands: {cmd_list}")
    process = subprocess.Popen(ssh_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    
    stdout, stderr = process.communicate()
    
    print("STDOUT:")
    print(stdout)
    if stderr:
        print("STDERR:")
        print(stderr)
        
    return process.returncode

print("=== STEP 1: Git Pull ===")
step1 = run_ssh_command([
    "cd /var/www/cardwars-kingdom",
    "git fetch origin",
    "git reset --hard origin/main",
    "git pull origin main"
])

if step1 != 0:
    print("Error during step 1 (Git pull)")
    sys.exit(1)

print("\n=== STEP 2: Install Requirements ===")
step2 = run_ssh_command([
    "cd /var/www/cardwars-kingdom",
    "source venv/bin/activate",
    "pip install -r requirements.txt --quiet",
    "deactivate"
])

if step2 != 0:
    print("Warning: non-zero exit code on pip install, continuing...")

print("\n=== STEP 3: Restart Systemd Service ===")
step3 = run_ssh_command([
    "systemctl restart cardwars-kingdom-net.service"
])

if step3 != 0:
    print("Error during step 3 (Service restart)")
    sys.exit(1)

print("\n=== STEP 4: Verify Service Status ===")
step4 = run_ssh_command([
    "echo 'Service Status:'",
    "systemctl status cardwars-kingdom-net.service --no-pager -l"
])

print("Deployment finished!")
