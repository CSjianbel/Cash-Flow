import csv

import requests
from bs4 import BeautifulSoup

def scrape_stock_data(url):
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'}

    response = requests.get(url, headers=headers)
    scraper = BeautifulSoup(response.text, 'html.parser')

    table = scraper.find('table')
    headers = [header.text.strip() for header in table.find_all('th')]

    rows = [[val.text.strip() for val in row.find_all('td')] for row in table.find_all('tr')]

    for row in rows:
        row[2] = row[2].split(' ')[0]

    with open('.stock_data.csv', 'w', newline='') as csv_file:
        writer = csv.writer(csv_file, delimiter='\t')
        writer.writerow(headers)
        writer.writerows(row for row in rows if row)

if __name__ == "__main__":
    url = "https://www.pesobility.com/stock/blue-chips"
    scrape_stock_data(url)

