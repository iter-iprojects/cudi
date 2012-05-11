/**
 * $Id:  $
 *
 * @author Ondrej Popelka
 * @copyright Copyright © 2006 Ondrej Popelka www.amadeo.cz. All rights reserved.
 */
 
 
// initialize popup for inserting button control
function initButton() {
	var inst = tinyMCE.getInstanceById(tinyMCE.getWindowArg('editor_id'));
	var focusElm = inst.getFocusElement();
	var nodeName = focusElm.nodeName.toLowerCase();
	if ((nodeName == "input") && ((focusElm.type == 'submit') || (focusElm.type == 'reset') || (focusElm.type == 'button'))) {
	    //focused element is a button, fill popup form
		editing = focusElm; //store edited element in global var
		selectOption('cb_class', focusElm.className);
		//remove prefix from name
		document.getElementById('ed_name').value = focusElm.name.replace(/^b_/, '');
		document.getElementById('ed_desc').value = focusElm.title;
		document.getElementById('ed_value').value = focusElm.value;
	} else {
	    editing = null;
	}
} //initButton()


//insert button control
function insertButton() {
	var inst = tinyMCE.getInstanceById(tinyMCE.getWindowArg('editor_id'));
	var cName = document.getElementById('ed_name').value;
	var cDesc = document.getElementById('ed_desc').value;
	var cValue = document.getElementById('ed_value').value;

	//button name is mandatory
	if (cName == '') {
		alert(tinyMCE.entityDecode(tinyMCE.getLang('lang_amadeo_form_err_name_mandatory')));
	    return false;
	} else {
	    /* add prefix to name, so that unique filenames have to be maintained only
			within controls of the same type */
	    cName = 'b_' + cName;
	}

	//button value (description) is mandatory
	if (cValue == '') {
		alert(tinyMCE.entityDecode(tinyMCE.getLang('lang_amadeo_form_err_value_mandatory')));
		return false;
	}

	//button name must be unique
	if (!editing && inst.contentWindow.document.getElementById(cName)) {
		alert(tinyMCE.entityDecode(tinyMCE.getLang('lang_amadeo_form_err_name_unique')));
	    return false;
	}

	//get design class
	if ((className = getSelectValue('cb_class')) == 'none') { 
	    className = '';
	}

	//get button type
	switch (getSelectValue('cb_type')) {
		case 'submit': typeName = 'submit'; break;
		case 'reset': typeName = 'reset'; break;
		default: typeName = 'submit'; break;
	}

	//insert control
	inst.execCommand('mceBeginUndoLevel');
	if (editing != null) {
	    editing.className = className;
	    editing.id = cName;
	    editing.name = cName;
	    editing.title = cDesc;
	    editing.type = typeName;
	    editing.value = cValue;
	} else {
		html = '<input';
		html += makeAttrib('type', typeName);
		html += makeAttrib('id', cName);
		html += makeAttrib('name', cName);
		html += makeAttrib('title', cDesc);
		html += makeAttrib('class', className);
		html += makeAttrib('value', cValue);
		html += '/>';
		inst.execCommand('mceInsertContent', false, html);
 	}
	inst.execCommand("mceEndUndoLevel");
	tinyMCEPopup.close();
} //insertButton()

