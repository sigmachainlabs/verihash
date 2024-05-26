#[starknet::contract]
mod VH {
	use starknet::get_caller_address;
	use starknet::ContractAddress;
    use starknet::get_block_timestamp;
    use core::starknet::event::EventEmitter;
    use starknet::get_block_number;
    use core::poseidon::PoseidonTrait;
    use core::hash::{HashStateTrait, HashStateExTrait};


	#[storage]
	struct Storage {
        owner: ContractAddress,
        api_call: LegacyMap::<u256, Call>,
        api_response: LegacyMap::<u256, Response>,
        last_id: u256,
	}

    #[derive(Drop, Clone, Serde, starknet::Store, starknet::Event)]
    struct Call {
        #[key]
        id: u256,
        address: ContractAddress,
        host: felt252,
        payload: felt252,
        method: felt252,
    }

    #[derive(Drop, Clone, Serde, starknet::Store, starknet::Event)]
    struct Response {
        id: u256,
        address: ContractAddress,
        response: felt252,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        CallSaved: Call,
        CallReponse: Response,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.owner.write(get_caller_address());
    }

	#[external(v0)]
	#[generate_trait]
	impl IVHImpl of IVHTrait {
        fn create_call(ref self: ContractState, host: felt252, payload: felt252, method: felt252) {
            let caller = get_caller_address();
            let id = self.generate_id();

            let _input = Call {
                id: id,
                address: caller,
                host: host,
                payload: payload,
                method: method,
            };

            let _event = _input.clone();
            self.api_call.write(id, _input);
            self.emit(_event);
        }

        fn save_response(ref self: ContractState, id: u256, response: felt252) {
            let caller = get_caller_address();
            let _response = Response {
                id: id,
                address: caller,
                response: response,
            };

            let _event = _response.clone();
            self.api_response.write(id, _response);
            self.emit(_event);
        }

        fn read_response(self: @ContractState, id: u256) -> Response {
            return self.api_response.read(id);
        }

        fn read_call(self: @ContractState, id: u256) -> Call {
            return self.api_call.read(id);
        }

        fn read_call_and_response(self: @ContractState, id: u256) -> (Call, Response) {
            let api_call = self.api_call.read(id);
            let api_response = self.api_response.read(id);
            return (api_call, api_response);
        }

        fn get_owner(self: @ContractState) -> ContractAddress {
            return self.owner.read();
        }
    }

	#[generate_trait]
	impl VHUtilsImpl of VHUtilsTrait {
        fn generate_id(ref self: ContractState) -> u256 {
            let count = self.last_id.read();
            self.last_id.write(count + 1);
            return count + 1;
        }
	}
}