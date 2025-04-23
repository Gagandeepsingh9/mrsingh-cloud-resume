const count = document.querySelector(".count-number");

async function updateCount() {
    let response = await fetch("__LAMBDA_URL__");
    let data = await response.json();
    count.innerHTML = `${data}`;
}

updateCount();
