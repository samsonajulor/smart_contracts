# smart_contracts
This repository contains smart contracts and dApps designed collaboratively by web3bridgers of cohort IX.

To contribute to this repository, fork it, and raise a PR against the main branch.

## Contracts are found in the .sol file in the truffle folder.


## How to compile a contract
- Change into the truffle dir
  `cd truffle`
  
- Install truffle globally
`npm install -g truffle`

# OR
- install packages
`npm install`

- Init truffle if truffle-config is absent (optional)
`npx truffle init`

- Compile the contract(s) with either of these commands
`npx truffle compile`
`npx truffle compile --all`
`npx truffle compile ./<file path>`

- Copy the resulting JSON abi from the ./build/contracts dir into the client/<appName>/src/contract/<nameOfContract>.json
  #### PS: replace texts in <>.

- In another terminal, cd into the clients/ballot or client/<anyOtherAppCreated> dir
- Run `npm install` to install dependencies.
- Run `npm start`
- view the dApp in localhost:<port>.
  #### port is usually 3000


