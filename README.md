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
`npx truffle compile ./{file path}`

- Copy the resulting JSON abi from the ./build/contracts dir into the client/{appName}/src/contract/{nameOfContract}.json
  #### PS: replace texts in {}.
- install brave browser. Dedicate this browser for development.
- IMPORTANT!!!! please please please create a brand new test wallet and address!!!!!
- In another terminal, cd into the clients/ballot or client/{anyOtherAppCreated} dir
- Run `npm install` to install dependencies.
- Run `npm start`
- view the dApp in localhost:{port}.
  #### port is usually 3000
- the app looks like this <br/>
![ballot contract UI](./assets/ballot%20contract%20ui.png)


