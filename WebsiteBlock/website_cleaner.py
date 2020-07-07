#!/usr/local/bin/python3
host_path = '/etc/hosts'
redirect = '127.0.0.1'
website_list = '/Users/kevinzhuang/Programming/Scripts/python_scripts/website_list.txt'
blocked = '/Users/kevinzhuang/.blocked_status'

blocking_list = []

with open(website_list, 'r') as file:
    raw_block_list = file.readlines()
    for line in raw_block_list:
        blocking_list.append(line[0:-1])

with open(host_path, 'r+') as file:
    content = file.readlines()
    file.seek(0)
    for line in content:
        if not any(website in line for website in blocking_list):
            file.write(line)
    file.truncate()

with open(blocked, 'w+') as file:
    print('Website blocking stopped')
