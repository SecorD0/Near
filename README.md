<h1><p align="center">Near | Stake Wars III</p></h1>

<p align="center"><img src="https://user-images.githubusercontent.com/25284138/186029873-8b831fa3-4876-4844-b9e5-aaea2d153750.jpg"></p>

<p align="center"><a href="https://t.me/OnePackage">1package</a></p>



<h1><p align="center">Content</p></h1>

- Content
- [Server requirements](#Server-requirements)
- [Challenge 001](#Challenge-001)
- [Challenge 002](#Challenge-002)
  - [Start a node](#Start-a-node)
  - [Becoming a Validator](#Becoming-a-Validator)
- [Challenge 003](#Challenge-003)
  - [Staking pool](#Staking-pool)
  - [Pinging](#Pinging)
- [Challenge 004](#Challenge-004)
- [Updating](#Updating)
- [Hardforks](#Hardforks)
  - [27.07.22](#27.07.22)
  - [21.07.22](#21.07.22)
- [Actions](#Actions)
- [Useful commands](#Useful-commands)
- [Useful links](#Useful-links)
- [1package](#1package)
- [Acknowledgments](#Acknowledgments)



<h1><p align="center">Server requirements</p></h1>
<p align="right"><a href="#Content">To the content</a></p>

⠀Minimal (VPS/VDS/DS): 4 CPU, 8 GB RAM, 500 GB SSD, Ubuntu 20.04

⠀Suitable servers:
- [Hetzner — CPX21, DS AX41](https://hetzner.cloud/?ref=VLYST6YYvi30)
- [Contabo — VPS L](https://contabo.com/en/vps/vps-l-ssd/?image=ubuntu.267&qty=1&contract=1&storage-type=vps-l-800-gb-ssd)



<h1><p align="center">Challenge 001</p></h1>
<p align="right"><a href="#Content">To the content</a></p>
<p align="right"><a href="https://github.com/near/stakewars-iii/blob/main/challenges/001.md">Source page</a></p>

⠀[Create](https://wallet.shardnet.near.org/) a wallet.

<p align="center"><img src="https://user-images.githubusercontent.com/25284138/186030542-7a609d79-6db3-4254-9014-1949efbd4d23.png"></p>

⠀Enter you username and click the button.

<p align="center"><img src="https://user-images.githubusercontent.com/25284138/186030737-9c2786a8-e809-4d45-b290-fef9290c6d83.png"></p>

⠀Choose the mnemonic phrase, click the button, save it in a safe place and pass the memory verification.

<p align="center"><img src="https://user-images.githubusercontent.com/25284138/186030758-4c33349c-3abf-4d0d-bddd-fa1d4a1c6254.png"></p>

⠀Recover the created wallet.

<p align="center"><img src="https://user-images.githubusercontent.com/25284138/186030807-41b5ad6b-8287-402f-8a2e-09d18a612722.png"></p>



<h1><p align="center">Challenge 002</p></h1>
<p align="right"><a href="#Content">To the content</a></p>
<p align="right"><a href="https://github.com/near/stakewars-iii/blob/main/challenges/002.md">Source page</a></p>


<h2><p align="center">Start a node</p></h2>

⠀Check if your server has the right CPU features
```sh
lscpu | grep -P '(?=.*avx )(?=.*sse4.2 )(?=.*cx16 )(?=.*popcnt )' > /dev/null && echo "Supported" || echo "Not supported"
```

⠀Update packages
```sh
sudo apt update && sudo apt upgrade -y
```

⠀Install the required packages
```sh
sudo apt install wget jq bc build-essential -y
```

⠀Install Rust
```sh
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/installers/rust.sh)
```

⠀Clone the repo
```sh
git clone https://github.com/near/nearcore
```

⠀Go to the project folder
```sh
cd $HOME/nearcore
```

⠀Switch to the latest commit
```sh
git checkout `wget -qO- https://raw.githubusercontent.com/near/stakewars-iii/main/commit.md`
```

⠀Check the current branch
```sh
git branch
```

⠀Build the binary
```sh
cargo build -p neard --release --features shardnet
```

⠀Move binary to the folder with all binaries
```sh
mv $HOME/nearcore/target/release/neard /usr/bin/
```

⠀Leave the project folder
```sh
cd
```

⠀Initialize the node
```sh
neard --home $HOME/.near init --chain-id shardnet --download-genesis
```

⠀

<p align="center"><ins>Save the file</ins></p>

```sh
echo $HOME/.near/node_key.json
```

⠀

⠀Download the config file
```sh
wget -O $HOME/.near/config.json https://s3-us-west-1.amazonaws.com/build.nearprotocol.com/nearcore-deploy/shardnet/config.json
```

⠀Edit the config
```sh
sed -i -e 's%"archive": false%"archive": true%' $HOME/.near/config.json
```

⠀Create a service file
```sh
printf "[Unit]
Description=Near node
After=network-online.target

[Service]
User=$USER
ExecStart=`which neard` --home $HOME/.near run
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/neard.service
```

⠀Start the service file
```sh
sudo systemctl daemon-reload
sudo systemctl enable neard
sudo systemctl restart neard
```

⠀Add a command to view a log of the node in the system as a variable
```sh
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/miscellaneous/insert_variable.sh) -n near_log -v "sudo journalctl -fn 100 -u neard" -a
```


<h2><p align="center">Becoming a Validator</p></h2>

⠀Install Node.js
```sh
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/installers/nodejs.sh)
```

⠀Install npm
```sh
sudo apt install npm -y
```

⠀Install near-cli
```sh
sudo npm install -g near-cli
```

⠀Insert variable with network name
```sh
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/miscellaneous/insert_variable.sh) -n NEAR_ENV -v "shardnet"
```

⠀Login
```sh
near login
```

⠀Answer `n`.

⠀Go to the link through the browser on your PC.

<p align="center"><img src="https://user-images.githubusercontent.com/25284138/186031569-0a7efe73-94b7-4dec-98d5-e83a82406d1c.png"></p>

⠀And grant access

<p align="center"><img src="https://user-images.githubusercontent.com/25284138/186031622-7de8fb8e-859e-446c-8941-6d22445743bb.png"></p>

<p align="center"><img src="https://user-images.githubusercontent.com/25284138/186031642-3b6f4996-3b5b-429d-8665-09b7f64bbafa.png"></p>

<p align="center"><img src="https://user-images.githubusercontent.com/25284138/186031657-4713f8f7-f57e-4fc8-a281-3b7c013dac17.png"></p>

<p align="center"><img src="https://user-images.githubusercontent.com/25284138/186031670-e896a4ce-f503-49fd-97a2-05bf7e7ebf90.png"></p>

⠀Enter an address of the connected account.

<p align="center"><img src="https://user-images.githubusercontent.com/25284138/186031750-8b5cf1ed-b3c6-42d8-b1dc-0d29caba62ca.png"></p>

⠀Add a wallet Account ID in the system as a variable
```sh
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/miscellaneous/insert_variable.sh) -n near_account_id
```

⠀Check if the file exists
```sh
cat $HOME/.near/validator_key.json
```

⠀If doesn't exist, create it
```sh
near generate-key "${near_account_id}.factory.shardnet.near"
```

⠀

<p align="center"><ins>Save the folder</ins></p>

```sh
echo $HOME/.near-credentials/shardnet/
```

⠀

⠀Copy the file generated to shardnet folder
```sh
cp "$HOME/.near-credentials/shardnet/${near_account_id}.shardnet.near.json" $HOME/.near/validator_key.json
```

⠀Edit it
```sh
sed -i -e "s%.shardnet.near%.factory.shardnet.near%; s%private_key%secret_key%" $HOME/.near/validator_key.json
```

⠀Restart the node
```sh
systemctl restart neard
```



<h1><p align="center">Challenge 003</p></h1>
<p align="right"><a href="#Content">To the content</a></p>
<p align="right"><a href="https://github.com/near/stakewars-iii/blob/main/challenges/003.md">Source page</a></p>


<h2><p align="center">Staking pool</p></h2>

⠀Add a wallet Pool ID in the system as a variable
```sh
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/miscellaneous/insert_variable.sh) -n near_pool_id
```

⠀Create staking pool
```sh
near call factory.shardnet.near create_staking_pool '{"staking_pool_id": "'${near_pool_id}'", "owner_id": "'${near_account_id}'.shardnet.near", "stake_public_key": "'"`jq -r '.public_key' "/root/.near/validator_key.json"`"'", "reward_fee_fraction": {"numerator": 5, "denominator": 100}, "code_hash":"DD428g9eqLL8fWUxv8QSpVFzyHi1Qd16P8ephYCTmMSZ"}' --accountId  "${near_account_id}.shardnet.near" \
--amount 30 --gas 300000000000000
```

<p align="center"><img src="https://user-images.githubusercontent.com/25284138/186032116-659ca8db-5e86-489e-b41e-f89da87ceb2f.png"></p>

⠀Delegate more tokens
```sh
near call "${near_pool_id}.factory.shardnet.near" deposit_and_stake --accountId "${near_account_id}.shardnet.near" --gas 300000000000000 \
--amount 500
```


<h2><p align="center">Pinging</p></h2>

⠀You should ping each epoch with the command below to keep reported rewards current
```sh
near call "${near_pool_id}.factory.shardnet.near" ping '{}' --accountId "${near_account_id}.shardnet.near" \
--gas 300000000000000
```



<h1><p align="center">Challenge 004</p></h1>
<p align="right"><a href="#Content">To the content</a></p>
<p align="right"><a href="https://github.com/near/stakewars-iii/blob/main/challenges/004.md">Source page</a></p>

⠀Add a command to view the information about the node in the system as a variable
```sh
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/miscellaneous/insert_variable.sh) -n near_node_info -v ". <(wget -qO- https://raw.githubusercontent.com/SecorD0/Near/main/node_info.sh) 2> /dev/null" -a
```

⠀Enter command to view the information
```sh
near_node_info
```

<p align="center"><img src="https://user-images.githubusercontent.com/25284138/186032142-46fd11d3-a9d6-4ad1-b214-c0abd8c6a6db.png"></p>



<h1><p align="center">Updating</p></h1>
<p align="right"><a href="#Content">To the content</a></p>


⠀Go to the project folder
```sh
cd $HOME/nearcore
```

⠀Create a branch with the source repository
```sh
git remote add upstream https://github.com/near/nearcore
```

⠀Update the local branch to the current branch
```sh
git fetch upstream
```

⠀Switch to the latest commit
```sh
git checkout `wget -qO- https://raw.githubusercontent.com/near/stakewars-iii/main/commit.md`
```

⠀Check the current branch
```sh
git branch
```

⠀Build the binary
```sh
cargo build -p neard --release --features shardnet
```

⠀Leave the project folder
```sh
cd
```

⠀Make backup of the config
```sh
cp $HOME/.near/config.json $HOME/.near/config.json.back
```

⠀Make backup of the previous binary
```sh
mv /usr/bin/neard $HOME
```

⠀Stop the node
```sh
sudo systemctl stop neard
```

⠀Move binary to the folder with all binaries
```sh
mv $HOME/nearcore/target/release/neard /usr/bin/
```

⠀Restart the node
```sh
sudo systemctl restart neard
```

⠀View the log to make sure the node is running 
```sh
near_log
```



<h1><p align="center">Hardforks</p></h1>
<p align="right"><a href="#Content">To the content</a></p>


<h2><p align="center">27.07.22</p></h2>

⠀Insert hardfork commit as a variable
```sh
commit="0d7f272afabc00f4a076b1c89a70ffc62466efe9"
```

⠀Follow the steps in the «[Actions](#Content)» subsection.


<h2><p align="center">21.07.22</p></h2>

⠀Insert hardfork commit as a variable
```sh
commit="0f81dca95a55f975b6e54fe6f311a71792e21698"
```

⠀Follow the steps in the «[Actions](#Content)» subsection.


<h2><p align="center">Actions</p></h2>

⠀Go to the project folder
```sh
cd $HOME/nearcore
```

⠀Create a branch with the source repository
```sh
git remote add upstream https://github.com/near/nearcore
```

⠀Update the local branch to the current branch
```sh
git fetch upstream
```

⠀Switch to the special commit
```sh
git checkout $commit
```

⠀Check the current branch
```sh
git branch
```

⠀Build the binary
```sh
cargo build -p neard --release --features shardnet
```

⠀Make backup of the previous binary
```sh
mv /usr/bin/neard $HOME
```

⠀Stop the node
```sh
sudo systemctl stop neard
```

⠀Move binary to the folder with all binaries
```sh
mv $HOME/nearcore/target/release/neard /usr/bin/
```

⠀Delete previous data
```sh
rm -rf $HOME/.near/{data,genesis.json}
```

⠀Download the genesis file
```sh
wget -O $HOME/.near/genesis.json https://s3-us-west-1.amazonaws.com/build.nearprotocol.com/nearcore-deploy/shardnet/genesis.json
```

⠀Download the config file
```sh
wget -O $HOME/.near/config.json https://s3-us-west-1.amazonaws.com/build.nearprotocol.com/nearcore-deploy/shardnet/config.json
```

⠀Edit the config
```sh
sed -i -e 's%"archive": false%"archive": true%' $HOME/.near/config.json
```

⠀Restart the node
```sh
sudo systemctl restart neard
```

⠀View the log to make sure the node is running 
```sh
near_log
```



<h1><p align="center">Useful commands</p></h1>
<p align="right"><a href="#Content">To the content</a></p>

⠀To view the node's log
```sh
near_log
sudo journalctl -fn 100 -u neard
```

⠀To view the information about the node
```sh
near_node_info
```

⠀To view validators in the current epoch
```sh
near validators current
near validators current | grep "$near_pool_id"
```

⠀To view validators in the next epoch
```sh
near validators next
near validators next | grep "$near_pool_id"
```

⠀To ping
```sh
near call "${near_pool_id}.factory.shardnet.near" ping '{}' --accountId "${near_account_id}.shardnet.near" \
--gas 300000000000000
```

⠀To restart the node
```sh
systemctl restart neard
```



<h1><p align="center">Useful links</p></h1>
<p align="right"><a href="#Content">To the content</a></p>

<p align="center"><a href="https://near.org/stakewars/">Event website</a> | <a href="https://github.com/near/nearcore">GitHub binary</a> | <a href="https://github.com/near/stakewars-iii/tree/main/challenges">GitHub challenges</a></p>

<p align="center"><a href="https://wallet.shardnet.near.org/">Wallet</a> | <a href="https://explorer.shardnet.near.org/">Explorer</a></p>



<h1><p align="center">1package</p></h1>
<p align="right"><a href="#Content">To the content</a></p>

<p align="center"><a href="https://t.me/OnePackage">Telegram</a> (RU) | <a href="https://t.me/OnePackage_Chat">Chat</a> (RU) | <a href="https://discord.gg/dnDaVqeWZe">Discord</a> (RU) | <a href="https://twitter.com/1package_">Twitter</a> | <a href="https://learning.1package.io/">Learning</a> | <a href="https://t.me/Admitix_News/2">Admitix</a></p>



<h1><p align="center">Express your gratitude</p></h1>
<p align="right"><a href="#Content">To the content</a></p>

⠀You can express your gratitude to the bot developers by sending fund to crypto wallets!
- Ethereum-like address (Ethereum, BSC, Moonbeam, etc.): `0x55AD64372bf4452759D577453521eb502001529A`
- USDT TRC-20: `TQvc5ruZPUSrs7riWeeekka5FjCGAiQ2wE`
- SOL: `8zpWbtTxmubgqcBXHQ129YbZszVp3WUcYc6a34peam3h`
- BTC: `bc1qnuwkg5ph0r8s332kle6jz2qmxe9ls36z9yt9ws`
