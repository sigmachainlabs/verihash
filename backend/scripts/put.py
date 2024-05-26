from starknet_py.contract import Contract
from starknet_py.net.full_node_client import FullNodeClient
from starknet_py.net.account.account import Account
from starknet_py.net.models.chains import StarknetChainId
from starknet_py.net.signer.stark_curve_signer import KeyPair
import asyncio
# Creates an instance of account which is already deployed
# Account using transaction version=1 (has __validate__ function)
client = FullNodeClient(node_url="https://starknet-sepolia.public.blastapi.io/rpc/v0_7")
account = Account(
    client=client,
    address="0x76bdf959a39886e730d3aab41caee59d847f3ecc28d2b4f34db99bdfe81940a",
    key_pair=KeyPair(private_key="",
    public_key="0x1ea78131e5d15b2aac3079c2ab342d51a278773f81c2d809294f4a3212c2add"),
    chain=StarknetChainId.SEPOLIA,
)

async def con_f_a(account):
    contract = await Contract.from_address(provider=account, address=0x079b587c6e75cb38b210fc12e37662c9f518d0025b7e67ac82c080501a105937)
    invocation = await contract.functions["create_call"].invoke_v3(host="0x68747470733a2f2f6170692e61676", payload="0x6e616d653d6d65656c6164", method="0x01", auto_estimate=True)
    await invocation.wait_for_acceptance()
    print(invocation)

if __name__ == '__main__':
    asyncio.run(con_f_a(account))

