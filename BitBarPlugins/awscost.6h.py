#!/usr/local/bin/python3

from datetime import datetime

from boto3.session import Session

session = Session(region_name="us-east-1", profile_name="master")

alarm = session.client("cloudwatch")
client = session.client("ce")


response = alarm.describe_alarms(
    AlarmNames=["BillingAlarm"],
)
alarm_state = response["MetricAlarms"][0].get("StateValue")

if alarm_state == "OK":
    print(" | size=18 font='DroidSansMono Nerd Font'")
    print("---")
    print("Alarm state OK.")
elif alarm_state == "INSUFFICIENT_DATA":
    print(" | size=18 font='DroidSansMono Nerd Font'")
    print("---")
    print("Alarm is in an UNKNOWN state?")
else:
    month = datetime.now().month
    year = datetime.now().year
    next_month = month + 1 if month != 12 else 1

    # format month
    month = str(month) if len(str(month)) != 1 else "0" + str(month)
    next_month = str(next_month) if len(str(next_month)) != 1 else "0" + str(next_month)

    start = "%s-%s-01" % (year, month)
    end = "%s-%s-01" % (year, next_month)

    response = client.get_cost_and_usage(
        TimePeriod={"Start": start, "End": end},
        Granularity="MONTHLY",
        Metrics=[
            "AmortizedCost",
        ],
    )

    total_dict = response["ResultsByTime"][0]["Total"].get("AmortizedCost")
    amount = (
        round(float(total_dict.get("Amount", 0.00)), 2)
        if total_dict.get("Amount", 0.00) > 0
        else 0.00
    )

    print("$%s %s" % (amount, total_dict.get("Unit")))
    print("---")
    print("Caution! Monitor your aws spending!")
