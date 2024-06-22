# VeriHash
### Enabling smart contracts to seamlessly integrate and verify real-time, off-chain data.
[Presentation Link](https://www.canva.com/design/DAGFs-q0Z54/jEi0reXNsP0GcoouWQhDnQ/edit?utm_content=DAGFs-q0Z54&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton)

----
## Current Limitations
Oracles are limited by predefined data, which limits developers' and solutions' freedom to seamlessly interact with off-chain data. 
### Rigid Data Sources
Developers must depend on the oracle provider's selection of data feeds, which may not always align with the specific needs or nuances of their applications.
### Lack of Customization
Developers cannot tailor these processes to suit specific requirements of their applications, such as filtering, aggregation, or transformation of data before it is delivered.

----
## Solution
### Full Flexibility
Unprecedented flexibility in accessing and integrating external data directly into blockchain applications
### Proof Generation
Independent on-chain proof of the API response.
### On-Chain Verification
Anyone can verify the proof of the API results directly on the blockchain.
- **Native Integration**: Developers can natively integrate VeriHash's smart contracts into their blockchain applications.
- **Function Trigger**: The _emit_call_ function in the contract receives the API endpoint and payload as arguments, triggering a event to perform the API call.
- **Data Verification**: A Merkle tree is constructed with the API response, timestamp, and metadata, enabling anyone to verify the authenticity of the entire or partial API response on the blockchain.
- **On-Chain Data Handling**: VeriHash supports on-chain data transformation and computation, allowing developers to access predefined methods or create custom ones for enhanced functionality.
----
