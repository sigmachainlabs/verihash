import requests
import sqlite3
import json
import hashlib


def create_table():
    conn = sqlite3.connect('event_data.db')
    c = conn.cursor()
    c.execute('''CREATE TABLE IF NOT EXISTS api_data
                 (id TEXT, host TEXT, method TEXT, payload TEXT, address TEXT, response TEXT)''')
    conn.commit()
    conn.close()

def get_hash(input_text):
    return hashlib.sha256(input_text.encode()).hexdigest()

def insert_db_call(id, host, method, payload, address, response):
    conn = sqlite3.connect('event_data.db')
    c = conn.cursor()
    c.execute("INSERT INTO api_data VALUES (?, ?, ?, ?, ?, ?)",
              (id, host, method, payload, address, response))
    conn.commit()
    conn.close()

def process_event(event):
    # Unpacking    event
    id = event['id']
    host = event['host']
    method = event['method']
    payload = event['payload']
    address = event['address']

    # API call
    try:
        if method.upper() == 'POST':
            response = requests.post(host, json=payload)
        elif method.upper() == 'GET':
            response = requests.get(host, params=payload)
        else:
            return "Method not supported"

        response = get_hash(response.text)
    except Exception as e:
        response = get_hash(str(e))

    insert_db_call(id, host, method, json.dumps(payload), address, response)


    #Starks call contract insert 