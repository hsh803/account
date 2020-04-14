function balanceControl() {
    let balance = document.getElementById('balance').textContent;
    let amount = document.getElementById('amount').value;
    let control = parseFloat(balance) - parseFloat(amount);
    if (control < 0){
        alert("Not enough balance to transfer money.");
        document.getElementById('amount').value = "";
    } else if (amount === "") {
        alert ("Please fill numbers.");
    }
    else {
        alert("Transfer succeeded.");
    }
}

function createControl() {
    let id = document.getElementById('id').value;
    let name = document.getElementById('name').value;
    let deposit = document.getElementById('deposit').value;
    if (id === "") {
        alert ("Please fill account id.");   
    }
    else if (name === "") {
        alert ("Please fill your name.");
    }
    else if (deposit === "") {
        alert ("Please fill numbers.");
    }
    else {
        alert("Account " + "\"" + id + "\"" + "created.");
    }
}

function amountControl() {
    let title = document.getElementById('title').textContent;
    let amount = document.getElementById('amount').value;
    if (amount === "") {
        alert ("Please fill numbers.");   
    }
    else {
        alert(title + " succeeded.");
    }
}