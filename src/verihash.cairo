#[starknet::contract]
mod VH {
	use starknet::get_caller_address;
	use starknet::ContractAddress;
    use starknet::get_block_timestamp;
    use core::starknet::event::EventEmitter;
    use starknet::get_block_number;


	#[storage]
	struct Storage {
		api_call: LegacyMap::<(ContractAddress, u64), Call>, 
        api_response: LegacyMap::<u64, ByteArray>,
	}

    // #[derive(Drop)]
    // enum Method {
    //     GET,
    //     POST,
    //     PUT,
    //     PATCH,
    //     DELETE,
    //     CONNECT,
    //     OPTIONS,
    //     TRACE,
    //     HEAD
    // }


    #[derive(Drop, Clone, Serde, starknet::Store, starknet::Event)]
    struct Call {
        #[key]
        id: u64,
        address: ContractAddress,
        host: ByteArray,
        payload: ByteArray,
        method: ByteArray,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        CallSaved: Call,
    }

	#[external(v0)]
	#[generate_trait]
	impl IVHImpl of IVHTrait {
        fn save_call(ref self: ContractState, host: ByteArray, payload: ByteArray, method: ByteArray) {
            let account = get_caller_address();
            let id = self.generate_id();

            let api_call_input = Call {
                id: id,
                address: account,
                host: host,
                payload: payload,
                method: method,
            };

            let event = api_call_input.clone();
            self.api_call.write((account, id), api_call_input);
            self.emit(event);
        }

        fn save_response(ref self: ContractState, id: u64, response: ByteArray) {
            self.api_response.write(id, response);
        }

        fn read_call(self: @ContractState, address: ContractAddress, id: u64) -> Call {
            return self.api_call.read((address, id));
        }

    }
	#[generate_trait]
	impl VHUtilsImpl of VHUtilsTrait {
        fn generate_id(self: @ContractState) -> u64 {
            return get_block_timestamp() % get_block_number();
        }
	}
}