import csv

import requests
from bs4 import BeautifulSoup

def scrape_stock_data(url):
    # Define headers to mimic a legitimate browser request
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'}

    response = requests.get(url, headers=headers)

    scraper = BeautifulSoup(response.text, 'html.parser')

    table = scraper.find('table')

    # Extract table headers
    headers = [header.text.strip() for header in table.find_all('th')]

    # Extract table rows
    rows = []
    for row in table.find_all('tr'):
        rows.append([val.text.strip() for val in row.find_all('td')])

    # Clean current price
    for row in rows:
        row[2] = row[2].split(' ')[0]

    # Write the data to a CSV file
    with open('stock_data.csv', 'w', newline='') as csv_file:
        writer = csv.writer(csv_file)
        writer.writerow(headers)
        writer.writerows(row for row in rows if row)

if __name__ == "__main__":
    url = "https://www.pesobility.com/stock/blue-chips"
    scrape_stock_data(url)

