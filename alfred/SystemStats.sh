top_results=$(top -l 1)
disk_space=$(df -l -H)
output_loa=$(echo "$top_results" | sed 's/,//g' | awk 'FNR==3{
  min1 = $3
  min10 = $4
  min15 = $5
  msg = "1min: "min1"%," " 10mins: "min10"%," " 15mins: " min15"%"
  print msg
}')

output_cpu=$(echo "$top_results" | awk 'FNR==4{
  user_cpu = $3", "
  sys_cpu = $5", "
  idle_cpu = $7
  msg = "User: "user_cpu "Sys: "sys_cpu "Idle: "idle_cpu
  print msg
}')

output_mem=$(echo "$top_results" | sed -E 's/\(//g' | awk 'FNR==7{
  used_mem = $2", "
  wired_mem = $4", "
  unused_mem = $6
  msg = "Used: "used_mem "Wired: "wired_mem "Unused: "unused_mem
  print msg
}')

output_net=$(echo "$top_results" | awk 'FNR==9{
  in_net = $3", "
  out_net = $5
  msg = "In: "in_net "Out: " out_net
  print msg
}')

output_disk=$(echo "$disk_space" | awk 'FNR==3{
  avail_disk = $4
  total_disk = $2
  msg = "Total: "total_disk", " "Avail: "avail_disk
  print msg
}')

cat << EOB
{"items": [
	{
		"valid": false,
		"uid": "cpu",
		"title": "CPU",
		"subtitle": "$output_cpu",
		"icon": {
			"path": "cpu.png"
		}
	},
	{
		"valid": false,
		"uid": "loa",
		"title": "Load AVG",
		"subtitle": "$output_loa",
		"icon": {
			"path": "loa.png"
		}
	},
	{
		"valid": false,
		"uid": "mem",
		"title": "Memory",
		"subtitle": "$output_mem",
		"icon": {
			"path": "ram.png"
		}
	},
	{
		"valid": false,
		"uid": "net",
		"title": "Networks",
		"subtitle": "$output_net",
		"icon": {
			"path": "network.png"
		}
	},
	{
		"valid": false,
		"uid": "net",
		"title": "Disks",
		"subtitle": "$output_disk",
		"icon": {
			"path": "disk.png"
		}
	}
]}
EOB
