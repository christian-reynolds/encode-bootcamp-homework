$(document).ready(() => {
    // Confirmation message
    console.log('web3Bridge.js loaded');

    connectWallet();

    window.ethereum.on('accountsChanged', function (accounts) {
        // Time to reload your interface with accounts[0]!
        connectWallet();
        console.log('Account changed!');
    });

    $('#mint-nft').click(() => {
        $("body").addClass("loading");

        mintNft().then((response) => {
            showNftMetadata();

            $('#success').show();
            $("body").removeClass("loading");
        });
    });

    $('#transfer-nft').click(() => {
        $("body").addClass("loading");
        const tokenId = document.getElementById('transfer-tokenid');
        const address = document.getElementById('transfer-address');

        transferNft(address.value, tokenId.value).then((response => {
            showNftMetadata();
            $("body").removeClass("loading");
            address.value = "";
            tokenId.value = "";
        }));
    });
});

function connectWallet() {
    loadProvider().then((response) => {
        $('#mint-nft').show();
        showNftMetadata();
    });
}

function showNftMetadata() {
    getNftMetadata().then((response) => {
        if (response.length > 0) {
            const newHtml = response.map(meta => `<span>${meta[2]}</span><br/>`);
            $('#account-metadata').html(newHtml.join("")).show();
            $('#transferSpan').show();
        } else {
            $('#account-metadata').html('').hide();
            $('#transferSpan').hide();
        }
    });
}
  
async function addData(newData) {
    const route = 'mintNft';
    const req = { data: newData };
    function update(response) {
        $('#output-text').val(response.path);
    }
    ajaxCall(route, req, update);
}