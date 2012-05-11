/**
 * $Id:  $
 *
 * @author Ondrej Popelka
 * @copyright Copyright © 2006 Ondrej Popelka www.amadeo.cz. All rights reserved.
 */


/* initialize popup for inserting edit control, edit control includes both
	input type: text, file, password and textarea element */
function initEdit() {
	var inst = tinyMCE.getInstanceById(tinyMCE.getWindowArg('editor_id'));
	var focusElm = inst.getFocusElement();
	var nodeName = focusElm.nodeName.toLowerCase();
	if (((nodeName == "input")
			&& ((focusElm.type == 'text') || (focusElm.type == 'password') || (focusElm.type == 'file')))
			|| (nodeName == "textarea")) {
		//focused element is what we consider as an edit control
		editing = focusElm; //save to global var for later reference
		
		//fill the popup form
		//determine multi line (textarea) or single line (input) control
		var singleLine = (nodeName != "textarea");
		if (singleLine) {
	        selectOption('cb_type', focusElm.type.toLowerCase());
		} else {
		    selectOption('cb_type', 'multi');
		}
		/* edit control may contain several classes, for validation and for
			styling, parse them now and fill the popup form */
		classes = focusElm.className.toLowerCase().split(' ');
		document.getElementById('chk_valid_mandatory').selected = false;
		for (var i = 0; i < classes.length; i++) {
		    switch (classes[i]) {
				case 'mandatory': document.getElementById('chk_valid_mandatory').checked = true; break;
				case 'email': selectOption('cb_validation', 'email'); break;
				case 'number': selectOption('cb_validation', 'number'); break;
				default: selectOption('cb_class', classes[i]);
			}
		}
		//remove prefix from name
		document.getElementById('ed_name').value = focusElm.name.replace(/^ed_/, '');
		document.getElementById('ed_desc').value = focusElm.title;
		if (singleLine) {
			document.getElementById('ed_value').value = focusElm.value;
		} else {
			document.getElementById('ed_value').value = encodeAttribute(focusElm.innerHTML);
		}
	} else {
	    editing = null;
	}
}


//insert edit control
function insertEdit() {
	var inst = tinyMCE.getInstanceById(tinyMCE.getWindowArg('editor_id'));
	var className = getSelectValue('cb_class');
	var typeName = getSelectValue('cb_type');
	var cName = document.getElementById('ed_name').value;
	var cDesc = document.getElementById('ed_desc').value;
	var validation = getSelectValue('cb_validation');
	var cValue = document.getElementById('ed_value').value;

	var classes = Array();
	var singleLine = (typeName != 'multi');

	//name is mandatory
	if (cName == '') {
		alert(tinyMCE.entityDecode(tinyMCE.getLang('lang_amadeo_form_err_name_mandatory')));
	    return false;
	} else {
	    /* add prefix to name, so that unique filenames have to be maintained only
			within controls of the same type */
	    cName = 'ed_' + cName;
	}

	//name must be unique
	if (!editing && inst.contentWindow.document.getElementById(cName)) {
		alert(tinyMCE.entityDecode(tinyMCE.getLang('lang_amadeo_form_err_name_unique')));
	    return false;
	}

	//validation for text means no type validation, otherwise save the class
	if (validation != 'text') {
	    classes.push(validation);
	}

	//get style class
	if (className != 'none') { 
	    classes.push(className);
	}

	//get validation class
	if (document.getElementById('chk_valid_mandatory').checked) {
	    classes.push('mandatory');
	}

	//insert edit control
	inst.execCommand('mceBeginUndoLevel');
	/* control changed from multiline to single line or the otherway; so the
	    element must be removed */
	if (editing && (((editing.nodeName.toLowerCase() == 'textarea') && singleLine) ||
	    ((editing.nodeName.toLowerCase() == 'input') && !singleLine))) {
		editing.innerHTML = ''; //otherwise the contents of textara would remain in document
		inst.execCommand('mceReplaceContent', false, ''); //delete element
		editing = null;
	}

	if (editing != null) {//edit existing element
	    editing.id = cName;
	    editing.name = cName;
	    editing.title = cDesc;
	    editing.className = classes.join(' ');
		if (singleLine) {
			switch (typeName) {
				case 'password': editing.type = 'password'; break;
				case 'file': editing.type = 'file'; break;
				default: editing.type = 'text'; break;
			}
		}
		if (singleLine) {
		    if (typeName != 'file') { //value cannot be set for type file
				editing.setAttribute('value', cValue);
		    	//editing.value = cValue; - not working ?!?
		    }
		} else {
			editing.innerHTML = cValue;
		}
	} else {
		if (singleLine) {
			html = '<input';
			html += makeAttrib('type', typeName);
		} else {
			html = '<textarea';
		}

		html += makeAttrib('id', cName);
		html += makeAttrib('name', cName);
		html += makeAttrib('title', cDesc);
		html += makeAttrib('class', classes.join(' '));
		if (singleLine) {
		    if (typeName != 'file') { //value cannot be set for type file
				html += makeAttrib('value', cValue);
			}
			html += '/>';
		} else {
			html += '>' + cValue + '</textarea>';
		}
		inst.execCommand('mceInsertContent', false, html);
 	}
	inst.execCommand("mceEndUndoLevel");
	tinyMCEPopup.close();
} //insert Edit
