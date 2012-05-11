/* check name while typing to allow only a-z, 0-9, _ and -; and numbers not on the begining, otherwise delete it*/
function validateName(control) {
	control.value = control.value.toLowerCase().replace(/[^a-z_0-9-]*/g, '').replace(/^[0-9]*/, '');
}

/* check number while typing allows only 0-9, and -; otherwise delete it */
function validateNumber(control) {
	control.value = control.value.toLowerCase().replace(/[^0-9-]*/g, '');
}

/* get selected value of a select control */
function getSelectValue(id) {
	if (elm = document.getElementById(id)) {
	    if (elm.selectedIndex >= 0) {
			return elm.options[elm.selectedIndex].value;
		} else {
		    return '';
		}
	} else {
		return '';
	}
}

/* create html for an attribute */
function makeAttrib(attrib, value) {
	return ' ' + attrib + '="' + encodeAttribute(value) + '"';
}

/* encode value for atribute */
function encodeAttribute(value) {
	if (value == "") {
		return "";
	}
	value = value.replace(/&/g, '&amp;');
	value = value.replace(/\"/g, '&quot;');
	value = value.replace(/</g, '&lt;');
	return value.replace(/>/g, '&gt;');
}

/* choose a given option in a select control, so that it's default for the user */
function selectOption(selectId, optionValue) {
	if (elm = document.getElementById(selectId)) {
		for (var i = 0; i < elm.options.length; i++) {
		    elm.options[i].selected = (elm.options[i].value == optionValue);
		}
		return true;
	} else {
		return false;
	}
}


/* add a new value to select while checking if it's there already  */
function addToSelect(selectId, optionValue, optionText) {
	var selectElm = document.getElementById(selectId);
	optionArray = selectElm.options;

	//check if value exists already
	for (var i = 0; i < optionArray.length; i++) {
	    if (optionArray[i].value == optionValue) {
	        return false;
		}
	}

	//create new option and add it to select
	var option = document.createElement('option');
	option.text = optionText;
	option.value = optionValue;
	try {
    	selectElm.add(option, null); //insertion
    } catch(ex) {
    	selectElm.add(option); //for IE ?
    }
    return true;
}


/* clear all options from select */
function clearSelect(selectId) {
	selectElm = document.getElementById(selectId);
	while (selectElm.options.length > 0) {
		selectElm.remove(0);
	}
}
