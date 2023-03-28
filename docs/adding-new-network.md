# Process of adding a new network (domain)
This guide outlines the necessary steps that Relay Partners must follow when extending the Sygma Bridge with a new network (EVM or Substrate).
**Note: The term `domain` will be used in place of `network` to maintain consistency with the code.**

### Prerequisites (Sygma Team Steps)
Initially, the Sygma team will deploy all required [SmartContracts](https://github.com/sygmaprotocol/sygma-solidity/tree/master/docs) (or [Pallets](https://github.com/sygmaprotocol/sygma-substrate-pallets/tree/main/docs)) to the new network and configure them. 
Typically, a new network should contain Bridge, TokenHandlers, and FeeHandlers contracts or pallets. 
After this step, the Sygma team will also configure other networks by adding the newly deployed network as a possible destination.
Once both sides are configured, the process moves to the configuration phase.

### Relayers Configuration
Relayers have two configurations: shared and env:
- **Shared configuration** ([doc](https://github.com/sygmaprotocol/sygma-shared-configuration)) contains information about the domains Sygma operates within. The Sygma team updates this configuration.
- **Env configuration** - This local Relayer configuration contains secret parameters, e.g., Network sender private key and RPC URL [doc](https://github.com/sygmaprotocol/sygma-relayer-deployment#relayer-configuration). It is located in the `SYG_DOM` [env variable](https://github.com/sygmaprotocol/sygma-relayer-deployment/blob/main/ecs/task_definition_TESTNET.j2#L66).

The Sygma team will update the Shared configuration, and no further steps are required from the Relay Partners. However, Relay Partners must modify the Env configuration according to their CI/CD flows.

**NOTE** Both configurations are applied by the Relayer at startup to avoid configuration parameter mismatches during the update process. It is highly recommended to update the ENV configuration without restarting the Relayer and only restart it after both configurations have been updated.

### Adding New Network Steps
1. Receive confirmation from the Sygma team that the new network is properly configured.
2. Prepare the `Private key` and `RPC URL` for the new network.
3. Top up the `Private key` with the necessary amount of base currency and set up monitoring for its balance.
4. Update the `SYG_DOM` variable for your relayers.
5. Restart the Relayer upon Sygma team notification.