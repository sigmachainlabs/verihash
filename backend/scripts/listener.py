import asyncio
from starknet_py.contract import Contract
from starknet_py.net.account.account import Account
from starknet_py.net.models.chains import StarknetChainId
from starknet_py.net.signer.stark_curve_signer import KeyPair
from starknet_py.net.full_node_client import FullNodeClient
from dataclasses import dataclass

client = FullNodeClient(node_url="https://starknet-sepolia.public.blastapi.io/rpc/v0_7")

account = Account(
    client=client,
    address="0x76bdf959a39886e730d3aab41caee59d847f3ecc28d2b4f34db99bdfe81940a",
    key_pair=KeyPair(private_key="", 
                     public_key="0x1ea78131e5d15b2aac3079c2ab342d51a278773f81c2d809294f4a3212c2add"),
    chain=StarknetChainId.SEPOLIA,
)

@dataclass
class TupleDataclass:
    id: int
    address: int
    host: int
    payload: int
    method: int

async def listen_new_ids(contract_address, start_id=0):
    contract = await Contract.from_address(provider=account, address=contract_address)
    current_id = start_id
    while True:
        try:
            response = await contract.functions["read_call"].call(id=current_id)
            if response:
                # Directly accessing the TupleDataclass instance from the tuple
                data_instance = response[0]
                # Access fields directly for output
                if data_instance.id != 0:
                    print(f"New data found for ID {current_id}: ID={data_instance.id}, Address={data_instance.address}, Host={data_instance.host}, Payload={data_instance.payload}, Method={data_instance.method}")
                else:
                    print(f"Empty ID found at {current_id}. Skipping to next.")
            else:
                print(f"No new data at ID {current_id}")
        except IndexError:
            print(f"IndexError for ID {current_id}: response data is {response}")
        except Exception as e:
            print(f"An error occurred at ID {current_id}: {str(e)}")
        current_id += 1
        await asyncio.sleep(1)  


if __name__ == '__main__':
    contract_address = "0x079b587c6e75cb38b210fc12e37662c9f518d0025b7e67ac82c080501a105937"
    asyncio.run(listen_new_ids(contract_address))
