/**
 * $Id:  $
 *
 * @author Ondrej Popelka
 * @copyright Copyright © 2006 Ondrej Popelka www.amadeo.cz. All rights reserved.
 */


/* initialize popup for inserting fieldset element */
function initFieldset() {
	var inst = tinyMCE.getInstanceById(tinyMCE.getWindowArg('editor_id'));
	var fNode = inst.getFocusElement();
	var found = false;
	do { //find fieldset in document
		if (fNode.nodeName.toLowerCase() == "fieldset") {
			found = true;
			break;
		}
	} while (fNode = fNode.parentNode);
	if (found) {
		editing = fNode; //save element to global variable
		//find legend element and get its' text
		for (var i = 0; i < editing.childNodes.length; i++) {
		    if (editing.childNodes[i].nodeName.toLowerCase() == 'legend') {
		        document.getElementById('ed_legend').value = encodeAttribute(editing.childNodes[i].innerHTML);
		        break;
			}
		}
		//remove prefix from name
		document.getElementById('ed_name').value = editing.id.replace(/^fs_/, '');
	} else {
	    editing = null;
	}
	
}


// insert fieldset
function insertFieldset() {
	var inst = tinyMCE.getInstanceById(tinyMCE.getWindowArg('editor_id'));
	var cName = document.getElementById('ed_name').value;

	//name is mandatory
	if (cName == '') {
		alert(tinyMCE.entityDecode(tinyMCE.getLang('lang_amadeo_form_err_name_mandatory')));
	    return false;
	} else {
	    /* add prefix to name, so that unique filenames have to be maintained only
			within controls of the same type */
	    cName = 'fs_' + cName;
	}

	inst.execCommand('mceBeginUndoLevel');
	if (editing) {
 	    editing.setAttribute('id', cName);
 	    //find the legend element and update the text
		for (var i = 0; i < editing.childNodes.length; i++) {
		    if (editing.childNodes[i].nodeName.toLowerCase() == 'legend') {
		        editing.childNodes[i].innerHTML = document.getElementById('ed_legend').value;
		        break;
			}
		}
 	} else {
 	    //wrap selected content into fieldset
		if (inst.selection.getSelectedHTML()) {
			tinyMCEPopup.execCommand("mceInsertContent", false, '<fieldset ' + makeAttrib('id', cName) + '><legend>' +
				document.getElementById('ed_legend').value + '</legend>' + inst.selection.getSelectedHTML() + '</fieldset>');
		}
	}
	inst.execCommand("mceEndUndoLevel");
	tinyMCEPopup.close();
} //insertFieldset
