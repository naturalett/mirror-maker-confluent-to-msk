import json
import os
import requests
import argparse

from requests import Response
from typing import Iterator
from utils import headers, logger

def get_environment_data(source_cluster, destination_cluster, environment):
    script_directory = os.path.dirname(os.path.abspath(__file__))
    env_path = os.path.join(script_directory, f'{environment}/{destination_cluster}/{source_cluster}')
    region_data = []

    if not os.path.exists(env_path):
        return region_data
    if os.path.isdir(env_path):
        region_data = []
        for file_name in os.listdir(env_path):
            if file_name.endswith('.json'):
                file_path = os.path.join(env_path, file_name)
                with open(file_path, 'r') as file:
                    try:
                        json_content = json.load(file)
                        region_data.append(json_content)
                    except json.JSONDecodeError:
                        print(f"Error decoding JSON in {file_path}")
    return region_data

def push_config(host: str, config: dict, name: str) -> Response:
    r = requests.put(
        url=f"https://{host}/connectors/{name}/config",
        headers=headers,
        json=config
    )
    print(r)
    return r

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Mirror Maker Connector')
    parser.add_argument('-env', '--environment', help='Environment to deploy')
    parser.add_argument('-dc', '--destination_cluster', help='Destination cluster to deploy')
    parser.add_argument('-sc', '--source_cluster', help='Source cluster')
    args = parser.parse_args()

    configs = get_environment_data(args.source_cluster, args.destination_cluster, args.environment)
    for config in configs:
        host = f'mm2-{args.source_cluster}-to-{args.destination_cluster}.naturalint.com'
        logger.info(f"Put new config for hostname: {host}")
        try:
            push_config(host, config, config['name'])
            logger.info(f"Put new config for connector: {config['name']}")
        except:
            logger.error(f"Invalid config for connector: {config['name']}")