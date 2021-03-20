# About

Active reconnaissance can be very manual work. I wrote this shell script to automate the process.
First the script creates several directories for the tools that it'll run.
It then builds off of those directories to run other tools.

Basic Funtionality:
URL is specified
Directories are created
Sublist3r discovers subdirectories from target URL and places its results into its own folder and appends its results to final.txt
Amass discovers subdirectories from target URL and places its results into its own folder and appends its results to final.txt
HTTProbe uses results from final.txt to probe each target subdirctory to see if a response is received. If received result is appended to alive.txt
Nmap uses alive.txt to scan for active IPs, ports, services. Results are appended to three file formats.
So Masscan can read Nmap's results we must supply a list of IP only. So results are grepped and appended to grepped_ips.txt
Masscan uses grepped_ips.txt to scan for active ports. Results are appended to masscan_results.txt.
