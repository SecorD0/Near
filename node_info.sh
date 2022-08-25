#!/bin/bash
# Default variables
language="EN"
raw_output="false"

# Options
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/colors.sh) --
option_value(){ echo $1 | sed -e 's%^--[^=]*=%%g; s%^-[^=]*=%%g'; }
while test $# -gt 0; do
	case "$1" in
	-h|--help)
		. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/logo.sh)
		echo
		echo -e "${C_LGn}Functionality${RES}: the script shows information about a Near node"
		echo
		echo -e "Usage: script ${C_LGn}[OPTIONS]${RES}"
		echo
		echo -e "${C_LGn}Options${RES}:"
		echo -e "  -h,  --help               show help page"
		echo -e "  -l,  --language LANGUAGE  use the LANGUAGE for texts"
		echo -e "                            LANGUAGE is '${C_LGn}EN${RES}' (default), '${C_LGn}RU${RES}'"
		echo -e "  -ro, --raw-output         the raw JSON output"		
		echo
		echo -e "You can use either \"=\" or \" \" as an option and value ${C_LGn}delimiter${RES}"
		echo
		echo -e "${C_LGn}Useful URLs${RES}:"
		echo -e "https://github.com/SecorD0/Near/blob/main/node_info.sh - script URL"
		echo -e "         (you can send Pull request with new texts to add a language)"
		echo -e "https://t.me/OnePackage — node Community"
		echo
		return 0 2>/dev/null; exit 0
		;;
	-l*|--language*)
		if ! grep -q "=" <<< $1; then shift; fi
		language=`option_value $1`
		shift
		;;
	-ro|--raw-output)
		raw_output="true"
		shift
		;;
	*|--)
		break
		;;
	esac
done

# Config
daemon="`which near`"
token_name="NEAR"
node_dir="$HOME/.near/"
explorer_url_template="https://explorer.shardnet.near.org/accounts/"
current_block=`wget -qO- http://65.109.26.103:3030/status | jq ".sync_info.latest_block_height"`

# Functions
printf_n(){ printf "$1\n" "${@:2}"; }
main() {
	# Texts
	if [ "$language" = "RU" ]; then
		local t_net="\nСеть:                       ${C_LGn}%s${RES}"
		local t_ni="ID ноды:                    ${C_LGn}%s${RES}"
		local t_nv="Версия ноды:                ${C_LGn}%s${RES}"
		local t_lb="Последний блок:             ${C_LGn}%s${RES}"
		local t_sy1="Нода синхронизирована:      ${C_LR}нет${RES}"
		local t_sy2="Осталось нагнать:           ${C_LR}%d-%d=%d${RES}"
		local t_sy3="Нода синхронизирована:      ${C_LGn}да${RES}"
		
		local t_vai="\nAccount ID валидатора:      ${C_LGn}%s${RES}"
		local t_eu="Страница в эксплорере:      ${C_LGn}%s${RES}"
		
		local t_ace1="Активен в текущей эпохе:    ${C_LGn}да${RES}"
		local t_ace2="Активен в текущей эпохе:    ${C_LR}нет${RES}"

		local t_ane1="Активен в следующей эпохе:  ${C_LGn}да${RES}"
		local t_ane2="Активен в следующей эпохе:  ${C_LR}нет${RES}"
		
		local t_del="Делегировано токенов:       ${C_LGn}%.4f${RES} ${token_name}"
		local t_ut="Аптайм:                     ${C_LGn}%s${RES}\n"

	# Send Pull request with new texts to add a language - https://github.com/SecorD0/Near/blob/main/node_info.sh
	#elif [ "$language" = ".." ]; then
	else
		local t_net="\nNetwork:                      ${C_LGn}%s${RES}"
		local t_ni="Node ID:                      ${C_LGn}%s${RES}"
		local t_nv="Node version:                 ${C_LGn}%s${RES}"
		local t_lb="Latest block height:          ${C_LGn}%s${RES}"
		local t_sy1="Node is synchronized:         ${C_LR}no${RES}"
		local t_sy2="It remains to catch up:       ${C_LR}%d-%d=%d${RES}"
		local t_sy3="Node is synchronized:         ${C_LGn}yes${RES}"
		
		local t_vai="\nValidator Account ID:         ${C_LGn}%s${RES}"
		local t_eu="Page in explorer:             ${C_LGn}%s${RES}"
		
		local t_ace1="Active in the current epoch:  ${C_LGn}yes${RES}"
		local t_ace2="Active in the current epoch:  ${C_LR}no${RES}"
		
		local t_ane1="Active in the next epoch:     ${C_LGn}yes${RES}"
		local t_ane2="Active in the next epoch:     ${C_LR}no${RES}"
		
		local t_del="Delegated tokens:             ${C_LGn}%.4f${RES} ${token_name}"
		local t_ut="Uptime:                       ${C_LGn}%s${RES}\n"
	fi
	
	# Actions
	sudo apt install jq bc -y &>/dev/null
	local local_rpc=`jq -r ".rpc.addr" "$node_dir/config.json"`
	local status=`wget -qO- "$local_rpc/status"`
	local network=`jq -r ".chain_id" <<< "$status"`
	local node_id=`jq -r ".node_key" <<< "$status"`
	local node_version=`jq -r ".version.build" <<< "$status"`
	local latest_block_height=`jq -r ".sync_info.latest_block_height" <<< "$status"`
	local syncing=`jq -r ".sync_info.syncing" <<< "$status"`
	
	local validator_account_id=`jq -r ".validator_account_id" <<< "$status"`
	if [ -n "$validator_account_id" ]; then local explorer_url="${explorer_url_template}${validator_account_id}"; fi
	
	local validator_info=`near validators current | grep "$validator_account_id"`
	if [ -n "$validator_info" ]; then
		local validator_current_epoch="true"
	else
		local validator_current_epoch="false"
	fi
		
	local validator_next_epoch=`near validators next | grep "$validator_account_id"`
	if [ -n "$validator_next_epoch" ]; then
		local validator_next_epoch="true"
	else
		local validator_next_epoch="false"
	fi
		
	if [ -n "$validator_info" ]; then
		local delegated=`awk '{print $4}' <<< "$validator_info" | sed "s%,%%"`
		local uptime=`awk '{print $8}' <<< "$validator_info" | sed "s%,%%"`
	fi

	# Output
	if [ "$raw_output" = "true" ]; then
		printf_n '{"network": "%s", "node_id": "%s", "node_version": "%s", "latest_block_height": %d, "syncing": %b, "validator_account_id": "%s", "explorer_url": "%s", "validator_current_epoch": %b, "validator_next_epoch": %b, "delegated": %d, "uptime": "%s"}' \
"$network" \
"$node_id" \
"$node_version" \
"$latest_block_height" \
"$syncing" \
"$validator_account_id" \
"$explorer_url" \
"$validator_current_epoch" \
"$validator_next_epoch" \
"$delegated" \
"$uptime" 2>/dev/null
	else
		printf_n "$t_net" "$network"
		printf_n "$t_ni" "$node_id"
		printf_n "$t_nv" "$node_version"
		printf_n "$t_lb" "$latest_block_height"
		if [ "$syncing" = "true" ]; then
			local diff=`bc -l <<< "$current_block-$latest_block_height"`
			printf_n "$t_sy1"
			printf_n "$t_sy2" "$current_block" "$latest_block_height" "$diff"	
		else
			printf_n "$t_sy3"
		fi
		
		printf_n "$t_vai" "$validator_account_id"
		printf_n "$t_eu" "$explorer_url"
		if [ "$validator_current_epoch" = "true" ]; then
			printf_n "$t_ace1"
		else
			printf_n "$t_ace2"
		fi
		if [ "$validator_next_epoch" = "true" ]; then
			printf_n "$t_ane1"
		else
			printf_n "$t_ane2"
		fi
		
		if [ -n "$validator_info" ]; then
			printf_n "$t_del" "$delegated"
			printf_n "$t_ut" "$uptime"
		fi
	fi
}

main
