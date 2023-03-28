# Process of adding new token
This technical documentation outlines the required steps that Relay Partners must follow in order to extend the Sygma Bridge with additional tokens (ERC20, ERC721, Substrate Assets). 
**Note: The term `resource` will be used in place of `token` to maintain consistency with the code.**

Upon the addition of a new resource, Relay Partners are only required to execute one step: restarting the relayer when prompted to do so. This ensures the adoption of changes from the **Shared Configuration** ([documentation](https://github.com/sygmaprotocol/sygma-shared-configuration)).

Nonetheless, it is essential to understand the internal process of adding a resource:

1. Sygma administrators must register the new Resource on all relevant chains by registering the [ResourceID](https://github.com/sygmaprotocol/sygma-solidity/blob/master/contracts/Bridge.sol#L144) on the corresponding [Bridge Handlers](https://github.com/sygmaprotocol/sygma-solidity/tree/master/contracts/handlers).
2. If needed, the Resource must be integrated into the FeeOracle, which serves as a source of exchange rates or a new calculation algorithm if the resource represents a different asset type.
3. Once all the necessary ResourceID registrations are completed, the Sygma team will update the **Shared Configuration** ([documentation](https://github.com/sygmaprotocol/sygma-shared-configuration)).
4. Finally, all relayers must be restarted to apply the new configuration settings.


