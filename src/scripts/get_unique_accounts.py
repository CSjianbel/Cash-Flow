import csv

DATABASE = '../database.csv'

def extract_unique_accounts(csv_file):
    unique_accounts = set()
    with open(csv_file, 'r') as file:
        reader = csv.reader(file)
        for row in reader:
            unique_accounts.add(row[0])
    return unique_accounts

def exportToTmpFile(file, accounts):
    with open(file, 'w') as fp:
        content = ','.join(list(accounts))
        fp.write(content)

if __name__ == "__main__":
    accounts = extract_unique_accounts(DATABASE)
    exportToTmpFile('./unique_accounts_tmp.txt', accounts)


