/**
 * $Id:  $
 *
 * @author Ondrej Popelka
 * @copyright Copyright © 2006 Ondrej Popelka www.amadeo.cz. All rights reserved.
 */

//initialize sorting
direction = 1;
sortType = '';

/* add empty line for option of existing select control to the table of options, thus
	creating a table in which all options can be edited */
function addOption() {
	var table = document.getElementById('options_table');
	var num = table.rows.length;
  	var tr = table.insertRow(num);
  	//first line of table is titles, thus rows are indexed from 1
  	var td0 = tr.insertCell(0);
  	var td1 = tr.insertCell(1);
  	var td2 = tr.insertCell(2);
  	var td3 = tr.insertCell(3);
  	td0.innerHTML = '<input type="radio" name="rd_default" value="' + num + '" id="rd_default_' + num + '"/>';
  	td1.innerHTML = '<input type="text" id="ed_option_value_' + num + '" name="ed_option_value_' + num + '" class="medium_input" onkeyup="validateName(this)"/>'
  	td2.innerHTML = '<input type="text" id="ed_option_text_' + num + '" name="ed_option_text_' + num + '" class="medium_input"/>';
  	td3.innerHTML = '<input type="text" id="ed_option_pr_' + num + '" name="ed_option_pr_' + num + '" value="' + num * 2 + '" class="small_input" onkeyup="validateNumber(this)"/>';
}

function sortText() { //sort table lines by text
	if (sortType == 'text') {
	    direction = -direction;
	} else {
	    direction = 1;
	}
	sortType = 'text';
	doSort(cmpText);
}

function sortPriority() { //sort table lines by priority
	if (sortType == 'priority') {
	    direction = -direction;
	} else {
	    direction = 1;
	}
	sortType = 'priority';
	doSort(cmpPriority);
}

function sortValue() { //sort table lines by value
	if (sortType == 'value') {
	    direction = -direction;
	} else {
	    direction = 1;
	}
	sortType = 'value';
	doSort(cmpValue);
}

function doSort(sortProc) { //prepare table and do the sorting
	var table = document.getElementById('options_table');
	var num = table.rows.length;
	var values = Array();
  	//first line of table is titles, thus rows are indexed from 1
  	/*copy lines from the table into array of values (can't use
	  	sort directly on table.rows anyway) */
	for (var i = 1; i < num; i++) { 
	    values[i-1] = Array(
	    		document.getElementById('ed_option_value_' + i).value,
	    		document.getElementById('ed_option_text_' + i).value,
	    		document.getElementById('ed_option_pr_' + i).value
			);
	}
	values.sort(sortProc); //do the actual sorting
  	//first line of table is titles, thus rows are indexed from 1
	for (var i = 1; i < num; i++) { 
   		document.getElementById('ed_option_value_' + i).value = values[i-1][0];
   		document.getElementById('ed_option_text_' + i).value = values[i-1][1];
   		document.getElementById('ed_option_pr_' + i).value = values[i-1][2];
	}
}

//compare by option names
function cmpText(v1,v2) {
  	if (v1[1] > v2[1]) {
    	return direction;
	}
	if (v1[1] < v2[1]) {
	    return direction * -1;
	}
	return 0;
} //cmpName


//compare by option values
function cmpValue(v1,v2) {
  	if (v1[0] > v2[0]) {
    	return direction;
	}
	if (v1[0] < v2[0]) {
	    return direction * -1;
	}
	return 0;
} //cmpName


//commmpare by priorities
function cmpPriority(v1,v2) {
	return direction * (parseFloat(v1[2]) - parseFloat(v2[2]));
} //cmpName



// initialize popup form for inserting select control
function initSelect() {
	var inst = tinyMCE.getInstanceById(tinyMCE.getWindowArg('editor_id'));
	var focusElm = inst.getFocusElement();
	var nodeName = focusElm.nodeName.toLowerCase();
	if (nodeName == "select") {
		editing = focusElm; //store the element for later use
		selectOption('cb_class', focusElm.className);
		//remove name prefix
		document.getElementById('ed_name').value = focusElm.name.replace(/^cb_/, '');
		document.getElementById('ed_desc').value = focusElm.title;
		var table = document.getElementById('options_table');
		var len = table.rows.length;
		for (var i = 0; i < editing.childNodes.length; i++) {
		  	//first line of table is titles, thus rows are indexed from 1
			//firs line of table is already defined in HTML, so fill it
			document.getElementById('ed_option_value_' + (i + 1)).value = editing.childNodes[i].value;
			document.getElementById('ed_option_text_' + (i + 1)).value = encodeAttribute(editing.childNodes[i].innerHTML);
			document.getElementById('ed_option_pr_' + (i + 1)).value = (i + 1) * 2; /*renumber the values, so that
			    the items can be swaped easily */
			if (editing.childNodes[i].selected) {
				document.getElementById('rd_default_' + (i + 1)).checked = true;
			}
			/* add another empty line, the table should always and with empty line
			    for quick adding a new option */
		    addOption();
		}
	} else {
	    editing = null;
	}
}


//insert select control
function insertSelect() {
	var inst = tinyMCE.getInstanceById(tinyMCE.getWindowArg('editor_id'));
	var className = getSelectValue('cb_class');
	var cName = document.getElementById('ed_name').value;
	var cDesc = document.getElementById('ed_desc').value;

	//name is mandatory
	if (cName == '') {
		alert(tinyMCE.entityDecode(tinyMCE.getLang('lang_amadeo_form_err_name_mandatory')));
	    return false;
	} else {
	    /* add prefix to name, so that unique filenames have to be maintained only
			within controls of the same type */
	    cName = 'cb_' + cName;
	}

	//name must be unique
	if (!editing && inst.contentWindow.document.getElementById(cName)) {
		alert(tinyMCE.entityDecode(tinyMCE.getLang('lang_amadeo_form_err_name_unique')));
	    return false;
	}

	//get style class
	if (className == 'none') {
	    className = '';
	}

	/*insert select in document, must definitely be in dom, to correctly
		handle options in all browsers */
	inst.execCommand('mceBeginUndoLevel');

	if (editing == null) { 	//new element
		editing = inst.getDoc().createElement('select');
		inst.getFocusElement().appendChild(editing);
	} else { //delete everything inside, will regenerate later
		editing.innerHTML = '';
	}
	
    editing.id = cName;
    editing.name = cName;
    editing.title = cDesc;
    editing.className = className;

	//add options to select
	var table = document.getElementById('options_table');
	var oValue, oText, optElm;
	//first line of table is titles, thus rows are indexed from 1
	for (var i = 1; i < table.rows.length; i++) {
		oValue = document.getElementById('ed_option_value_' + i).value;
		oText = document.getElementById('ed_option_text_' + i).value;
		if ((oValue != '') && (oText != '')) { //both value and caption must be entered
		    optElm = inst.getDoc().createElement('option');
		    optElm.value = oValue;
			optElm.innerHTML = oText;
			if (document.getElementById('rd_default_' + i).checked) {
			    optElm.setAttribute('selected', 'selected');
			}
			editing.appendChild(optElm);
		}
	} //for

	inst.execCommand("mceEndUndoLevel");
	tinyMCEPopup.close();
} //insertSelect
