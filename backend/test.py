import unittest
from util import process_event, insert_db_call  
import sqlite3

def create_table():
    conn = sqlite3.connect('event_data.db')
    c = conn.cursor()
    c.execute('''CREATE TABLE IF NOT EXISTS api_data
                 (id TEXT, host TEXT, method TEXT, payload TEXT, address TEXT, response TEXT)''')
    conn.commit()
    conn.close()

class TestEventProcessing(unittest.TestCase):

    def setUp(self):
        
        create_table()

    def test_event_processing(self):
    
        event = {
            'id': '1',
            'host': 'https://api.coingecko.com/api/v3/coins/markets',
            'method': 'GET',
            'payload': {'vs_currency': 'usd', 'ids': 'bitcoin'},
            'address': '0xExampleContractAddress'
        }
        process_event(event)

        conn = sqlite3.connect('event_data.db')
        c = conn.cursor()
        c.execute("SELECT * FROM api_data WHERE id = ?", (event['id'],))
        data = c.fetchall()
        self.assertTrue(data)  # Check that data is not empty
        self.assertEqual(len(data), 1)  # Check that exactly one record exists
        self.assertEqual(data[0][1], event['host'])  # Validate that the host matches
        self.assertEqual(len(data[0][5]), 64)  # Check if the response is a valid SHA-256 hash

        conn.close()

    def test_invalid_method(self):
        # Define a mock event with an unsupported method
        event = {
            'id': '2',
            'host': 'https://api.coingecko.com/api/v3/coins/markets',
            'method': 'PUT',  # Unsupported method
            'payload': {'vs_currency': 'usd', 'ids': 'bitcoin'},
            'address': '0xExampleContractAddress'
        }

        response = process_event(event)
        self.assertEqual(response, "Method not supported")

if __name__ == '__main__':
    unittest.main()