#!/usr/local/bin/python3
from boto3.session import Session

session = Session(profile_name="master")
budget_client = session.client("budgets")

response = budget_client.describe_budget(
    AccountId=session.client("sts").get_caller_identity()["Account"],
    BudgetName="TOTAL_COST",
)
actual_spend = response["Budget"]["CalculatedSpend"]["ActualSpend"]
forecast_spend = response["Budget"]["CalculatedSpend"]["ForecastedSpend"]

print(
    "$%s %s"
    % (
        round(float(actual_spend["Amount"]), 2),
        actual_spend["Unit"],
    )
)
print("---")
print(
    "$%s %s"
    % (
        round(float(forecast_spend["Amount"]), 2),
        forecast_spend["Unit"],
    )
)
