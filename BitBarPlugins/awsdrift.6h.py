#!/usr/local/bin/python3

import boto3
from botocore.exceptions import ClientError

regions = ["ap-southeast-2"]
alarms = []
in_alarm = False


def check_auto_scalling(alarm):
    for dimension in alarm.get("Dimensions", []):
        if dimension.get("Name", "") == "AutoScalingGroupName":
            return True
    return False


try:
    for region in regions:
        client = boto3.client("cloudwatch", region_name=region)
        paginator = client.get_paginator("describe_alarms")
        for result in paginator.paginate():
            metric_alarms = result.get("MetricAlarms", [])
            for alarm in metric_alarms:
                if check_auto_scalling(alarm):
                    continue
                if alarm.get("StateValue", "") == "ALARM":
                    in_alarm = True
                alarms.append(
                    {"Name": alarm.get("AlarmName"), "State": alarm.get("StateValue")}
                )
    if in_alarm:
        print("⚠")
    else:
        print("☁")
    print("---")
    for alarm in alarms:
        print("%s  %s" % (alarm["Name"], alarm["State"]))
except ClientError as e:
    print("☠")
    print("---")
    print(e)
