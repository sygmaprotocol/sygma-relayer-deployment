# Adding new token process
This guide describes all necessary steps that's Relaying partners need to take when Sygma bridge is being extended with new token (ERC20, ERC721, Substrate Asset)
**NOTE next we are going to write `resource` instead of `token` to keep correspondence with tech documentation.**

When new resource is getting added there is only step thaat Relaying partners needs to perform, is to restart the relayer when asked, so it applied changes from **Shared configuration** ([doc](https://github.com/sygmaprotocol/sygma-shared-configuration)).

But anyway here are the some internal details about how resource is getting added:

1. Sygma admin should register new Resource on all the chains that should have this resource, by registering [ResourceID](https://github.com/sygmaprotocol/sygma-solidity/blob/master/contracts/Bridge.sol#L144) on [Bridge Handlers](https://github.com/sygmaprotocol/sygma-solidity/tree/master/contracts/handlers)
2. If necessary Resource should be added on FeeOracle (source of rates, or new calcualtion algorithm is resource represents something different)
3. After all the necessary ResourceID's have been registered Sygma team will update **Shared configuration** ([doc](https://github.com/sygmaprotocol/sygma-shared-configuration)).
4. And now all the relayers should be restarted in order to apply new config
 
