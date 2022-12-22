#!/usr/bin/env python3

from argparse import ArgumentParser
import requests


def check_url(url):
    response = requests.get(url)
    status_url = response.status_code
    if status_url == 200:
        print('Service ok')
    else:    
        print('Service DOWN')
    
parser = ArgumentParser(description="Call Test Service Gamify Studios.")
parser.add_argument('-u', '--url', action='append', required=True)
args = parser.parse_args()

if args.url:
    url =args.url
    for i in range(len(url)):
        print(f"URL #{i+1}")
        check_url(url[i])

 
