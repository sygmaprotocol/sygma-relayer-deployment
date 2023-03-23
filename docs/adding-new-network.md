# Adding new network process
This guide describes all necessary steps thats Relaying partner need to take when Sygma bridge is being extended with new network (EVM or Substrate)
**NOTE next we are going to write `domain` instead of `network` to keep correspondence with tech documentation.**
### Prerequsitives (Sygma team steps)
Initially Sygma team will deploy all necessary [SmartContracts](https://github.com/sygmaprotocol/sygma-solidity/tree/master/docs) (or [Pallets](https://github.com/sygmaprotocol/sygma-substrate-pallets/tree/main/docs)) to the new network and configureate them. Usually new network should contain Bridge, TokenHandlers, FeeHandlers contracts or pallets.  After this done,  Sygma team also configurates other networks by adding newly deployed network as possible destiantion.
After both sides are configurated we should follow to configuration phase.

### Relayers configuration
Relayers has 2 configurations shared and env:
- **Shared configuration** ([doc](https://github.com/sygmaprotocol/sygma-shared-configuration)) contain all the infomation about domains Sygma operates within. This configuration is getting updated by Sygma team
-  **Env configuration** - is the local Relayer configuration that contains secret params eg. Network sender private key and RPC URL [doc](https://github.com/sygmaprotocol/sygma-relayer-deployment#relayer-configuration). It is located in `SYG_DOM` [env variable](https://github.com/sygmaprotocol/sygma-relayer-deployment/blob/main/ecs/task_definition_TESTNET.j2#L66)

Shared configuration will be updated by Sygma team and no necessary steps should be performed by Relaying partners.
Env configuration on the other hand should be changed by Relaying partners according to their CI/CD flows.

**NOTE** both of the configurations are applied by Realyer on start, this is made in order to avoid configuration params missmatch during the update process. So we highly recomend  to updated ENV configuration without restarting Relayer and restart it only after both of the configs are updated.

### Adding new networks steps
- Receve information from Sygma team that new network is properly configurated
- Preapare `Private key` and `RPC url` for the new network
- Topup `Private key` with necessary amount of base currency and setup monitoring for its balance
- Update `SYG_DOM` for your relayers
- Restart Relayer on Sygma team notificaion

