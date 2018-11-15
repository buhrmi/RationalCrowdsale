# RationallyPricedCrowdsale

A crowdsale contract that can be deployed as-is.

The price of the token will change based on token availability using a rational function: When 50% of tokens are sold, the price will double. At 75% it will quadruple, and so on.

## Flatten

```
./solidityFlattener.pl --mainsol=RationallyPricedCrowdsale.sol
```

## Deployment

For example, assume an ERC20 contract at `0x123` with `decimals = 6`, and you want to sell 5000 tokens with a base rate of 20 tokens per ether. You would construct the contract with `token = 0x123`, `baseRate = 20 * 10 ** 6` and `baseAvailability = 5000 * 10 ** 6`.

After deployment, transfer the `baseAvailability` amount of tokens to the contract to make it available for sale.

