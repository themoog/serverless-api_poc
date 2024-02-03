import json
import requests

def proxy_to_ec2(event, context):
    # Extract the proxy path parameter from the event
    path = event['pathParameters']['proxy']
    method = event['httpMethod']
    base_url = 'http://35.178.148.6:5000/'  # Replace with your EC2 instance's IP and port
    
    # Forward the query string parameters, if any
    query_params = event.get('queryStringParameters', {})
    query_string = '?' + '&'.join([f"{key}={value}" for key, value in query_params.items()]) if query_params else ''
    
    # Construct the full URL
    url = f"{base_url}{path}{query_string}"
    
    # Forward the headers, filtering out any that might cause issues
    headers = {key: value for key, value in event['headers'].items() if key.lower() not in ['host', 'content-length']}
    
    # Forward the request to the EC2 instance
    response = requests.request(method=method, url=url, headers=headers, data=event.get('body', None))
    
    # Return the response from the EC2 instance back to the client
    return {
        'statusCode': response.status_code,
        'headers': dict(response.headers),
        'body': response.text
    }
