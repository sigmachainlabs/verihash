from starknet_py.hash.address import compute_address
from starknet_py.net.account.account import Account
from starknet_py.net.full_node_client import FullNodeClient
from starknet_py.net.signer.stark_curve_signer import KeyPair

# First, make sure to generate private key and salt

key_pair = KeyPair.from_private_key(" ")

# Compute an address
address = compute_address(
    salt=salt,
    class_hash=class_hash,  # class_hash of the Account declared on the Starknet
    constructor_calldata=[key_pair.public_key],
    deployer_address=0,
)

print(address)