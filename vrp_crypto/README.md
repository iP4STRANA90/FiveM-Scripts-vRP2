# vrp_crypto
 Crypto Currency


This basically adds crypto currencies to the game. 

You can sell these cryptos to legal buyers which take 5% tax on them and to illegal sellers that take 1% tax.

The illegal sellers are randomly generated around LS

**Functions**: 
```
    user:getCrypto(id)
    @id: the crypto id | string
    > example: user:getCrypto("snailcoin") will return how many of the snailcoins the user has have someone has

    user:setCrypto(id, amount)
    @id: the crypto id, | string
    @amount: how many the crypto should be set to, | float
    > example: user:setCrypto("snailcoin", 15) will set the current amount of the snailcoins to 15    

    user:tryCryptoPayment(id, amount, dry)
    @id: the crypto id, | string
    @amount: how many cryptos that should be taken, | float
    @dry: if it should actually take the cryptos or just return true if the user can take that amount | bool
    > example: user:tryCryptoPayment("snailcoin", 14) then it will take 14 cryptos from the players total.

    user:giveCrypto(id, amount)
    @id: the crypto id, | string
    @amount: how many cryptos that should be given, | float
    > example: user:giveCrypto("snailcoin", 10) will give the user 10 more cryptos to their total
```
