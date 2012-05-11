/**
 * $Id:  $
 *
 * @author Ondrej Popelka
 * @copyright Copyright © 2006 Ondrej Popelka www.amadeo.cz. All rights reserved.
 */


// initialize popup for inserting checkbox control
function initCheckbox() {
	var inst = tinyMCE.getInstanceById(tinyMCE.getWindowArg('editor_id'));
	var focusElm = inst.getFocusElement();
	var nodeName = focusElm.nodeName.toLowerCase();
	if ((nodeName == "input") && (focusElm.type.toLowerCase() == 'checkbox')) {
		editing = focusElm; //saves control to global variable
		//remove prefix from name
		document.getElementById('ed_name').value = focusElm.name.replace(/^chk_/, '');
		document.getElementById('ed_desc').value = focusElm.title;
		document.getElementById('ed_value').value = focusElm.value;
		document.getElementById('chk_checked').checked = focusElm.checked;
		document.getElementById('chk_valid_mandatory').checked = (focusElm.className.toLowerCase() == 'mandatory');
	} else {
	    editing = null;
	}
}


// insert checkbox control
function insertCheckbox() {
	var inst = tinyMCE.getInstanceById(tinyMCE.getWindowArg('editor_id'));
	var cName = document.getElementById('ed_name').value;
	var cDesc = document.getElementById('ed_desc').value;
	var cValue = document.getElementById('ed_value').value;

	//name is mandatory
	if (cName == '') {
		alert(tinyMCE.entityDecode(tinyMCE.getLang('lang_amadeo_form_err_name_mandatory')));
	    return false;
	} else {
	    /* add prefix to name, so that unique filenames have to be maintained only
			within controls of the same type */
	    cName = 'chk_' + cName;
	}

	//name must be unique
	if (!editing && inst.contentWindow.document.getElementById(cName)) {
		alert(tinyMCE.entityDecode(tinyMCE.getLang('lang_amadeo_form_err_name_unique')));
	    return false;
	}

	//checkbox value is mandatory
	if (cValue == '') { 
		alert(tinyMCE.entityDecode(tinyMCE.getLang('lang_amadeo_form_err_value_mandatory')));
	    return false;
	}

	//get validation class
	if (document.getElementById('chk_valid_mandatory').checked) {
	    className = 'mandatory';
	} else {
	    className = '';
	}
	

	//insert control
	inst.execCommand('mceBeginUndoLevel');
	var isNew = (editing == null);
	if (isNew) {
		editing = inst.getDoc().createElement('input');
	    editing.setAttribute('type', 'checkbox'); /* must be done before
			append child, otherwise the control type can't be changed */
  	}
    editing.id = cName;
    editing.name = cName;
    editing.title = cDesc;
    editing.setAttribute('value', cValue);
    editing.className = className;
   	//editing.setAttribute('checked', 'checked');
	if (isNew) {
		inst.getFocusElement().appendChild(editing);
	}
	
    /* must use setAttribute to set checked to XHTML value checked=checked, otherwise
		only checked is produced */
    if (document.getElementById('chk_checked').checked) {
        editing.checked = true;
    	editing.setAttribute('checked', 'checked');
    } else {
 	  	editing.setAttribute('checked', ''); //IE doesn't work with removeAttribute so this is for IE
        //editing.checked = false;
    	editing.removeAttribute('checked'); /*FF interprets the presence of the attribute as true
    	    even if its' set to null or false */
 	}

	inst.execCommand("mceEndUndoLevel");
	tinyMCEPopup.close();
} //insertCheckbox()
