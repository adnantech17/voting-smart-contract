from web3 import Web3
import json
# Replace with your Ethereum node URL
w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:8545/"))

# Replace with the path to your contract's ABI JSON file
with open("../build/contracts/Voting.json") as f:
    contract_json = json.load(f)

abi = contract_json["abi"]

# # Replace with the deployed contract address
contract_address = "0xA2ec7D0F786e55c077dBa20dE34eC17D9C54f7C9"

contract = w3.eth.contract(address=contract_address, abi=abi)

def get_vote_count():
    try:
        vote_counts = contract.functions.voteCount().call()
    except:
        vote_counts = [-1]  
    return vote_counts

def perform_vote(id):
    vote_data = [0]*5
    vote_data[id] = 1
    print(vote_data)
    accounts = w3.eth.accounts
    tx_object = {
        "from": accounts[1],
        "gas": 6721975,
    }  
    contract.functions.performVote(vote_data).transact(tx_object)

    print("Vote recorded successfully!")
def submitKey(key):
    accounts = w3.eth.accounts
    tx_object = {
        "from": accounts[1],
        "gas": 6721975,
    }
    result = contract.functions.submitKey(key).call()
    contract.functions.submitKey(key).transact(tx_object)
    print(result)
# # Use the functions to interact with the contract
# perform_vote(3)
# get_vote_count()
# print("here")
def main_menu():
    print("Voting System Menu")
    print("1. Vote for Candidate 1")
    print("2. Vote for Candidate 2")
    print("3. Vote for Candidate 3")
    print("4. Vote for Candidate 4")
    print("5. Vote for Candidate 5")
    print("6. End Voting")
    choice = input("Enter your choice: ")
    return choice

def vote_count_phase():
    print("\n\n\n")
    print("1. Submit a key")
    print("2. Get Vote counting")
    print("3. Exit")
    choice = input("Enter your choice: ")
    if choice == '1':
        key = int(input('Enter the key:'))
        submitKey(key)
    elif choice == '2':
        countedVotes = get_vote_count()
        print("Votes: ")
        print(countedVotes)
    elif choice == '3':
        return
    else:
        print("Invalid choice. Please select a valid option.")
    vote_count_phase()
   
def main():
    while True:
        choice = main_menu()
        try:
            choice = int(choice)
            if(choice >=1 and choice <= 6):
                if choice == 6:
                    print("Voting has ended.\n\n")
                    print(".........Vote Count Phase begun.........\n\n\n")
                    # countedVotes = get_vote_count()
                    # print("Votes: ")
                    # print(countedVotes)
                    vote_count_phase()
                    break
                else:
                    perform_vote(choice-1)
            else:
                print("Invalid choice. Please select a valid option.")
        except:
            print("Invalid choice. Please select a valid option.")




if __name__ == "__main__":
    main()
    
    # print("here")