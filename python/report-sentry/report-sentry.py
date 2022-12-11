import requests
import json
import re
import os
import pandas
import logging
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

title_list = []
count_list = []
culprit_list = []

critical_list = []
critical_count = []
critical_culprit = []

medium_list = []
medium_count = []
medium_culprit = []

need_to_check = []
need_to_check_count = []
need_to_check_culprit = []

fix_immediately_list = []
fix_immediately_count = []
fix_immediately_culprit = []

minor_list = []
minor_count = []
minor_culprit = []

AUTH_TOKEN = os.environ['AUTH_TOKEN']

URL = os.environ['URL']

headers = {'Authorization': f'Bearer {AUTH_TOKEN}'}
response = requests.get(URL, headers=headers)
json_object = json.loads(response.text)  
lengList = len(json_object)

pattern_cirtical = re.compile(r'(Handshake|QueryFailedError|MaxRetriesPerRequestError):?(\s\w+).*|(\w+\s)(ETIMEDOUT|ECONNREFUSED)|.*([Tt][Ii][Kk][Vv]|[Tt][Ii][Dd][Bb]).*')
pattern_medium = re.compile(r'(NotFoundException|CustomHttpException|HttpException|UnauthorizedException|BadRequestException|DuplicatedEntryException|ForbiddenException):(\s\w+.*)|(CancelBetService|PayoutSeamlessService|PlaceBetSeamlessService)(\.\w+.*)')
pattern_need_check = re.compile(r'NotFoundException:(\s\w+.*)')
pattern_fix_immediately = re.compile(r'(TypeError|EntityColumnNotFound):\s(\w+|\[\w+]).*|(\[DecimalError\]\s\w+.*)|(BadRequestException:\sUnexpected\s\w.*)')
pattern_minor = re.compile(r'(PlaceBetSeamlessService|CancelBetService)\.\w+.*')


for num in range(lengList):
    title  = json_object[num]['title']
    culprit = json_object[num]['culprit']
    count = json_object[num]['count']
    title_list.append(title)
    count_list.append(count)
    culprit_list.append(culprit)
    if match := pattern_fix_immediately.search(title):
        fix_immediately_list.append(match.group())
        fix_immediately_count.append(count)
        fix_immediately_culprit.append(culprit)
    elif match := pattern_cirtical.search(title):
        critical_list.append(match.group())
        critical_count.append(count)
        critical_culprit.append(culprit)
    elif match := pattern_need_check.search(title):
        need_to_check.append(match.group())
        need_to_check_count.append(count)
        need_to_check_culprit.append(culprit)
    elif match := pattern_medium.search(title):
        medium_list.append(match.group())
        medium_count.append(count)
        medium_culprit.append(culprit)
    elif match := pattern_minor.search(title):
        minor_list.append(match.group())
        minor_count.append(count)
        minor_culprit.append(culprit)

data = {'fix_immediately': [{'Title (Fix Immediately)': a, 'Count': b, 'Culprit': c} for a, b, c in zip(fix_immediately_list, fix_immediately_count, fix_immediately_culprit)],
        'critical': [{'Title (Critical)': a, 'Count': b, 'Culprit': c} for a, b, c in zip(critical_list, critical_count, critical_culprit)],
        'need_to_check': [{'Title (Need To Check)': a, 'Count': b, 'Culprit': c} for a, b, c in zip(need_to_check, need_to_check_count, need_to_check_culprit )],
        'medium': [{'Title (Medium)': a, 'Count': b, 'Culprit': c} for a, b, c in zip(medium_list, medium_count, medium_culprit )],  
        'minor': [{'Title (Minor)': a, 'Count': b, 'Culprit': c} for a, b, c in zip(minor_list, minor_count, minor_culprit )]  
        }

# Write Mark Down File
file_markdown = 'report.md'
with open(file_markdown, 'w') as file:
    for key in data.keys():
        df = pandas.DataFrame.from_dict(data[key])
        line = df.to_markdown(index=True,tablefmt='grid')
        file.writelines(line)
        file.writelines("\n\n")

#Write Data Format Json
file_json = 'report.json'
format_json = json.dumps(data, indent=2)
with open(file_json, 'w') as file:
    file.write(format_json)

#Send File Mark Down To Slack
client = WebClient(token=os.environ.get("SLACK_BOT_TOKEN"))
logger = logging.getLogger(__name__)


# channel_id = "C04AEP90YQ5"
channel_id = os.environ['CHANNEL_ID']
try:
    result = client.files_upload_v2(
        channels=channel_id,
        initial_comment="Report Weekly Nagagames :smile:",
        file=file_markdown,
    )
    logger.info(result)

except SlackApiError as e:
    logger.error("Error uploading file: {}".format(e))