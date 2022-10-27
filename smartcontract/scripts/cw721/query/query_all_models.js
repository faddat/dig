const NFT = require("../../bot/nft");
const {get_contract_address} = require("../../utils");

const main = async () => {
    let nft = new NFT();
    await nft.load();

    const contract_addr = await get_contract_address(nft.network_name, "dig_cw721")
    await nft.load_contract(contract_addr);


    console.log("\n =====================\nQuery result is: ");
    let result = await nft.query_all_models();
    console.log(result)
}

main()
    .then(() => { process.exit(0); })
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
