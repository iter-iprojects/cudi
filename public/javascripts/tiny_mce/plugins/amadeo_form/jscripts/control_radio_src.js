/**
 * $Id:  $
 *
 * @author Ondrej Popelka
 * @copyright Copyright © 2006 Ondrej Popelka www.amadeo.cz. All rights reserved.
 */

/* The popup is executed for every radio control inserted, basicaly it then
 has to perform two different tasks:
 a) add another radio to existing group, that is maintain the name, add value, select default value
 b) add a new radio to create a new radio group

//============ functions


/* change popuform mode from edit existing radio to edit new radio and vice versa */
function changeMode(existing) {
	if (existing) {
		document.getElementById('new_name_span').style.display = 'none'
		document.getElementById('old_name_span').style.display = '';
		document.getElementById('default_value_tr').style.display = ''
	} else {
		document.getElementById('old_name_span').style.display = 'none';
		document.getElementById('new_name_span').style.display = '';
		document.getElementById('default_value_tr').style.display = 'none'
	}
	document.getElementById('rd_old').checked = existing;
	document.getElementById('rd_new').checked = !existing;
}


/* called onclick radiobutton rd_mode to change editing mode */
function onChangeMode() {
    changeMode(document.getElementById('rd_old').checked);
}


/* show the default value of radio control (identified by control name) in
	select cb_default */
function showDefaultValue(radioName) {
	var inst = tinyMCE.getInstanceById(tinyMCE.getWindowArg('editor_id'));
	//get all radios
	var radios = tinyMCE.getElementsByAttributeValue(inst.getBody(), "input", "type", "radio");
	var currentValue = document.getElementById('ed_value').value;

	for (var i = 0; i < radios.length; i++) {
		//it is the radio we are looking for and it's checked - is the default one
		if ((radios[i].name == radioName) && radios[i].checked) {
		    if (radios[i].value == currentValue) { /* the radio value equals to current value,
		        and since value is unique (in a group), then it's probably the currently
		        edited radio */
		        selectOption('cb_default', 'current');
		        return true;
			} else {
		        selectOption('cb_default', radios[i].value);
		        return true;
			}
		}
 	}
 	//no item was selected so we assume, that no item is default
    selectOption('cb_default', 'none');
}


/* gets called onchange radiobutton name, loads all values of the currently
	selected radio group to cb_default select control, so that the user
	can choose a default value for the radio group */
function radioGetValues() {
	var radioName = getSelectValue('cb_name');
	var inst = tinyMCE.getInstanceById(tinyMCE.getWindowArg('editor_id'));
	//get all radios
	var radios = tinyMCE.getElementsByAttributeValue(inst.getBody(), "input", "type", "radio");
	var currentValue = document.getElementById('ed_value').value; //get current radio value

	//clear the select box with default values and insert special items
	clearSelect('cb_default');
	addToSelect('cb_default', 'none', tinyMCE.entityDecode(tinyMCE.getLang('lang_amadeo_form_radio_default_none')));
	addToSelect('cb_default', 'current', tinyMCE.entityDecode(tinyMCE.getLang('lang_amadeo_form_radio_default_this')));
	
	/*insert all other items appart from the current value (which is loaded in the edit control
		ed_value and thus can be changed by the user, and thus we can't rely on identifying
		the radiobutton by it) */
	for (var i = 0; i < radios.length; i++) {
	    //add everything but current value
	    if ((radios[i].name == radioName) && !(radios[i].value == currentValue)) {
			addToSelect('cb_default', radios[i].value, radios[i].value);
		}
	}
	showDefaultValue(radioName); //must be called after setting ed_value
}



/* Sets the default radio button in radio group identified by radioName,
	according to the selectedValue or CurrentValue in case selectedValue is
	current radio */
function setDefaultRadio(radioName, selectedValue, currentValue) {
	var inst = tinyMCE.getInstanceById(tinyMCE.getWindowArg('editor_id'));
	var radios = tinyMCE.getElementsByAttributeValue(inst.getBody(), "input", "type", "radio");

	for (var i = 0; i < radios.length; i++) {
    	radios[i].setAttribute('checked', ''); //removeAttribute doesn't work in IE
	    if ((radios[i].value == selectedValue) || ((radios[i].value == currentValue) && (selectedValue == 'current'))) {
	        //property .checked si not XHTML valid, so it has to be done via setAttribute
			radios[i].setAttribute('checked', 'checked');
			/* cannot break here as other radios in the group might be checked
			    so they'll get unchecked now */
		}
	}
}


/* gets called onclick select cb_name, to load all values of selected radiogroup */
function onChangeName() {
	radioGetValues();
}


//initialize popup for inserting radio button
function initRadio() {
	var inst = tinyMCE.getInstanceById(tinyMCE.getWindowArg('editor_id'));
	radios = tinyMCE.getElementsByAttributeValue(inst.getBody(), "input", "type", "radio");
	var focusElm = inst.getFocusElement();

	//vytvori se seznam jmen vsech radio inputu
	for (var i = 0; i < radios.length; i++) { //addToSelect kontroluje unikatni polozky
		addToSelect('cb_name', radios[i].name, radios[i].name);
	}

	if (document.getElementById('cb_name').options.length > 0) { //nejake radiobutony existuji
		changeMode(true); //mod se prepne na editaci
		if ((focusElm.nodeName.toLowerCase() == 'input') && (focusElm.type.toLowerCase() == 'radio')) { //je nejaky radiobutton vybrany
			document.getElementById('ed_value').value = focusElm.value;
			document.getElementById('ed_desc').value = focusElm.title;
			selectOption('cb_name', focusElm.name);
			editing = focusElm;
		} else {
			editing = null;
		}
		radioGetValues(); //nacte hodnoty radia do selectu cb_default, musi se volat az po nastaveni ed_value
	} else { //zadny radiobutton neexsistuje
		changeMode(false); //mod editace na novy
		editing = null;
	}
}


/* vlozeni/aktualizace radiobuttonu */
function insertRadio() {
	var inst = tinyMCE.getInstanceById(tinyMCE.getWindowArg('editor_id'));
	var cDesc = document.getElementById('ed_desc').value;
	var cValue = document.getElementById('ed_value').value;

	//name is mandatory, but can be either in text field or in select 
	cName = getSelectValue('cb_name');
	//either nothing is selected or, new radio is to be created anyway
	if ((cName == '') || document.getElementById('rd_new').checked) { //check if name is in text field
		var cName = document.getElementById('ed_name').value;
		if (cName == '') {
			alert(tinyMCE.entityDecode(tinyMCE.getLang('lang_amadeo_form_err_name_mandatory')));
		    return false;
		} else {
	    /* add prefix to name, so that unique filenames have to be maintained only
			within controls of the same type */
	    	cName = 'rd_' + cName;
		}
	}
	//radio name is not unique as it identifies a group

	if (cValue == '') { //radio value is mandatory
		alert(tinyMCE.entityDecode(tinyMCE.getLang('lang_amadeo_form_err_value_mandatory')));
	    return false;
	}

	inst.execCommand('mceBeginUndoLevel');
	//edit existing radio
	if (editing != null) {
	    editing.name = cName;
	    editing.title = cDesc;
	    editing.type = 'radio';
	    editing.value = cValue;
	} else {
		html = '<input';
		html += makeAttrib('name', cName);
		html += makeAttrib('title', cDesc);
		html += makeAttrib('type', 'radio');
		html += makeAttrib('value', cValue);
		html += '/>';
		inst.execCommand('mceInsertContent', false, html);
 	}
 	setDefaultRadio(cName, getSelectValue('cb_default'), cValue);
	inst.execCommand("mceEndUndoLevel");
	tinyMCEPopup.close();
} //inserRadio()
