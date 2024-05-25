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
        api_call: LegacyMap::<(ContractAddress, u64), Call>,
        api_response: LegacyMap::<(ContractAddress, u64), felt252>,
	}

    #[derive(Drop, Clone, Serde, starknet::Store, starknet::Event)]
    struct Call {
        #[key]
        id: u64,
        address: ContractAddress,
        host: felt252,
        payload: felt252,
        method: felt252,
    }

    #[derive(Drop, Clone, Serde, starknet::Store, starknet::Event)]
    struct Response {
        id: u64,
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
        fn emit_call(ref self: ContractState, host: felt252, payload: felt252, method: felt252) {
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
            self.api_call.write((caller, id), _input);
            self.emit(_event);
        }

        fn save_response(ref self: ContractState, id: u64, response: felt252) {
            let caller = get_caller_address();
            self.api_response.write((caller, id), response);
            let _response = Response {
                id: id,
                address: caller,
                response: response,
            };
            self.emit(_response);
        }

        fn read_response(self: @ContractState, address: ContractAddress, id: u64) -> felt252 {
            return self.api_response.read((address, id));
        }

        fn read_call(self: @ContractState, address: ContractAddress, id: u64) -> Call {
            return self.api_call.read((address, id));
        }
    }

	#[generate_trait]
	impl VHUtilsImpl of VHUtilsTrait {
        fn generate_id(self: @ContractState) -> u64 {
            return get_block_timestamp() + get_block_number();
        }
	}
}