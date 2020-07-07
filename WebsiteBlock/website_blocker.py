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
    content = file.read()
    for website in blocking_list:
        if website in content:
            pass
        else:
            file.write(redirect + ' ' + website + '\n')

with open(blocked, 'w+') as file:
    file.write('blocked')

print('Website blocking started')
