const BallCoin = artifacts.require("BallCoin");

contract('BallCoin', (accounts) => {
  it('should put 10000 BallCoin in the first account', async () => {
    const ballCoinInstance = await BallCoin.deployed();
    const balance = await ballCoinInstance.getBalance.call(accounts[0]);

    assert.equal(balance.valueOf(), 10000, "10000 wasn't in the first account");
  });
  it('should call a function that depends on a linked library', async () => {
    const ballCoinInstance = await BallCoin.deployed();
    const ballCoinBalance = (await ballCoinInstance.getBalance.call(accounts[0])).toNumber();
    const ballCoinEthBalance = (await ballCoinInstance.getBalanceInEth.call(accounts[0])).toNumber();

    assert.equal(ballCoinEthBalance, 2 * ballCoinBalance, 'Library function returned unexpected function, linkage may be broken');
  });
  it('should send coin correctly', async () => {
    const ballCoinInstance = await BallCoin.deployed();

    // Setup 2 accounts.
    const accountOne = accounts[0];
    const accountTwo = accounts[1];

    // Get initial balances of first and second account.
    const accountOneStartingBalance = (await ballCoinInstance.getBalance.call(accountOne)).toNumber();
    const accountTwoStartingBalance = (await ballCoinInstance.getBalance.call(accountTwo)).toNumber();

    // Make transaction from first account to second.
    const amount = 10;
    await ballCoinInstance.sendCoin(accountTwo, amount, { from: accountOne });

    // Get balances of first and second account after the transactions.
    const accountOneEndingBalance = (await ballCoinInstance.getBalance.call(accountOne)).toNumber();
    const accountTwoEndingBalance = (await ballCoinInstance.getBalance.call(accountTwo)).toNumber();


    assert.equal(accountOneEndingBalance, accountOneStartingBalance - amount, "Amount wasn't correctly taken from the sender");
    assert.equal(accountTwoEndingBalance, accountTwoStartingBalance + amount, "Amount wasn't correctly sent to the receiver");
  });
});
