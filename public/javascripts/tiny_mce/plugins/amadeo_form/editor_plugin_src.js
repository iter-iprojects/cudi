/**
 * $Id: editor_plugin_src.js 42 2006-08-08 14:32:24Z spocke $
 *
 * @author Moxiecode
 * @copyright Copyright © 2004-2006, Moxiecode Systems AB, All rights reserved.
 */

/* Import plugin specific language pack */
tinyMCE.importPluginLanguagePack('amadeo_form');

// Singleton class
var TinyMCE_amadeo_formPlugin = {
	/**
	 * Returns information about the plugin as a name/value array.
	 * The current keys are longname, author, authorurl, infourl and version.
	 *
	 * @returns Name/value array containing information about the plugin.
	 * @type Array 
	 */
	getInfo : function() {
		return {
			longname : 'amadeo_form plugin',
			author : 'Your name',
			authorurl : 'http://www.yoursite.com',
			infourl : 'http://www.yoursite.com/docs/amadeo_form.html',
			version : "1.0"
		};
	},

	/**
	 * Gets executed when a TinyMCE editor instance is initialized.
	 *
	 * @param {TinyMCE_Control} Initialized TinyMCE editor control instance. 
	 */
	initInstance : function(inst) {
		// You can take out plugin specific parameters
		//alert("Initialization parameter:" + tinyMCE.getParam("amadeo_form_someparam", false));

		// Register custom keyboard shortcut
		//inst.addShortcut('ctrl', 't', 'lang_amadeo_form_desc', 'mceamadeo_form');
	},

	/**
	 * Returns the HTML code for a specific control or empty string if this plugin doesn't have that control.
	 * A control can be a button, select list or any other HTML item to present in the TinyMCE user interface.
	 * The variable {$editor_id} will be replaced with the current editor instance id and {$pluginurl} will be replaced
	 * with the URL of the plugin. Language variables such as {$lang_somekey} will also be replaced with contents from
	 * the language packs.
	 *
	 * @param {string} cn Editor control/button name to get HTML for.
	 * @return HTML code for a specific control or empty string.
	 * @type string
	 */
	getControlHTML : function(cn) {
	    if (cn == "amadeo_form") {
  			return 	tinyMCE.getButtonHTML(cn + '_edit', 'lang_amadeo_form_edit', '{$pluginurl}/images/edit.gif', 'mceamadeo_f_edit', true) +
  				tinyMCE.getButtonHTML(cn + '_checkbox', 'lang_amadeo_form_checkbox', '{$pluginurl}/images/checkbox.gif', 'mceamadeo_f_checkbox', true) +
  				tinyMCE.getButtonHTML(cn + '_radio', 'lang_amadeo_form_radio', '{$pluginurl}/images/radio.gif', 'mceamadeo_f_radio', true) +
  				tinyMCE.getButtonHTML(cn + '_select', 'lang_amadeo_form_select', '{$pluginurl}/images/select.gif', 'mceamadeo_f_select', true) +
			  	tinyMCE.getButtonHTML(cn + '_button', 'lang_amadeo_form_button', '{$pluginurl}/images/button.gif', 'mceamadeo_f_button', true) +
			  	tinyMCE.getButtonHTML(cn + '_fieldset', 'lang_amadeo_form_fieldset', '{$pluginurl}/images/fieldset.gif', 'mceamadeo_f_fieldset', true) +
			  	tinyMCE.getButtonHTML(cn + '_unfieldset', 'lang_amadeo_form_unfieldset', '{$pluginurl}/images/unfieldset.gif', 'mceamadeo_f_unfieldset', true);
		}
		return "";
	},

	/**
	 * Executes a specific command, this function handles plugin commands.
	 *
	 * @param {string} editor_id TinyMCE editor instance id that issued the command.
	 * @param {HTMLElement} element Body or root element for the editor instance.
	 * @param {string} command Command name to be executed.
	 * @param {string} user_interface True/false if a user interface should be presented.
	 * @param {mixed} value Custom value argument, can be anything.
	 * @return true/false if the command was executed by this plugin or not.
	 * @type
	 */
	execCommand : function(editor_id, element, command, user_interface, value) {
		// Handle commands
	    var fileName = '';
		var inst = tinyMCE.getInstanceById(editor_id);
		switch (command) {
			// Remember to have the "mce" prefix for commands so they don't intersect with built in ones in the browser.
			case "mceamadeo_f_edit": fileName = 'control_edit.html'; break;
			case "mceamadeo_f_button": fileName = 'control_button.html'; break;
			case "mceamadeo_f_checkbox": fileName= 'control_checkbox.html'; break;
			case "mceamadeo_f_modify": //je z popup menu na prave tlacitko
				var node = inst.getFocusElement();
				switch (node.nodeName) {
				    case 'TEXTAREA': fileName = 'control_edit.html'; break;
					case 'INPUT':
			    		switch (node.type) {
			        		case 'text':
							case 'file':
							case 'password': fileName = 'control_edit.html'; break;
							case 'submit':
							case 'reset':
							case 'button': fileName = 'control_button.html'; break;
				            case 'radio': fileName = 'control_radio.html'; break;
							case 'checkbox': fileName = 'control_checkbox.html'; break;
							default: return false; // Pass to next handler in chain
						}
						break;
					case 'SELECT': fileName = 'control_select.html'; break;
					default: return false; // Pass to next handler in chain
				} //switch
				break;
			case "mceamadeo_f_radio": fileName = 'control_radio.html'; break;
			case "mceamadeo_f_select": fileName = 'control_select.html'; break;
			case "mceamadeo_f_fieldset":
				var selectedText = inst.selection.getSelectedText();
				var focusElm = inst.getFocusElement();
				if (tinyMCE.selectedElement && selectedText && (selectedText.length > 0)) {
					fileName = 'control_fieldset.html'; break;
				} else {
					return false;
				}
			case "mceamadeo_f_unfieldset":
			    /* vymaze fieldset */
				var inst = tinyMCE.getInstanceById(editor_id);
				var fNode = inst.getFocusElement();
			    var found = false;
	    		do {
					if (fNode.nodeName.toLowerCase() == "fieldset") {
						found = true;
						break;
					}
				} while (fNode = fNode.parentNode);
				
				if (found) {
					html = fNode.innerHTML.replace(/<legend>.*?legend>/i, '');
					inst.execCommand('mceBeginUndoLevel');
					if (tinyMCE.isIE) {
						fNode.outerHTML = fNode.innerHTML;
					} else {
						var rng = fNode.ownerDocument.createRange();
						rng.setStartBefore(fNode);
						rng.setEndAfter(fNode);
						rng.deleteContents();
						rng.insertNode(rng.createContextualFragment(html));
					}
				}
				inst.execCommand("mceEndUndoLevel");
				return true;
			default: return false; // Pass to next handler in chain
		}
		if (fileName != '') {
			var amadeo_form = new Array();
			amadeo_form['file'] = '../../plugins/amadeo_form/' + fileName; // Relative to theme
			amadeo_form['width'] = 640;
			amadeo_form['height'] = 480;
			tinyMCE.openWindow(amadeo_form, {editor_id : editor_id, resizable: "yes"});
			// Let TinyMCE know that something was modified
			tinyMCE.triggerNodeChange(false);
			return true;
		}
		// Pass to next handler in chain
		return false;
	},

	/**
	 * Gets called ones the cursor/selection in a TinyMCE instance changes. This is useful to enable/disable
	 * button controls depending on where the user are and what they have selected. This method gets executed
	 * alot and should be as performance tuned as possible.
	 *
	 * @param {string} editor_id TinyMCE editor instance id that was changed.
	 * @param {HTMLNode} node Current node location, where the cursor is in the DOM tree.
	 * @param {int} undo_index The current undo index, if this is -1 custom undo/redo is disabled.
	 * @param {int} undo_levels The current undo levels, if this is -1 custom undo/redo is disabled.
	 * @param {boolean} visual_aid Is visual aids enabled/disabled ex: dotted lines on tables.
	 * @param {boolean} any_selection Is there any selection at all or is there only a cursor.
	 */
	handleNodeChange : function(editor_id, node, undo_index, undo_levels, visual_aid, any_selection) {
		// Select amadeo_form button if parent node is a strong or b
		tinyMCE.switchClass(editor_id + '_amadeo_form_edit', 'mceButtonNormal');
		tinyMCE.switchClass(editor_id + '_amadeo_form_button', 'mceButtonNormal');
		tinyMCE.switchClass(editor_id + '_amadeo_form_checkbox', 'mceButtonNormal');
		tinyMCE.switchClass(editor_id + '_amadeo_form_radio', 'mceButtonNormal');
		tinyMCE.switchClass(editor_id + '_amadeo_form_select', 'mceButtonNormal');
		tinyMCE.switchClass(editor_id + '_amadeo_form_fieldset', 'mceButtonNormal');

		if (node == null) {
			return;
		}

		var inFieldset = false;
		var fNode = node;
		do {
			if (fNode.nodeName.toLowerCase() == "fieldset") {
				tinyMCE.switchClass(editor_id + '_amadeo_form_fieldset', 'mceButtonSelected');
				tinyMCE.switchClass(editor_id + '_amadeo_form_unfieldset', 'mceButtonSelected');
				inFieldset = true;
				break;
			}
		} while (fNode = fNode.parentNode);

		if (!inFieldset) {
			tinyMCE.switchClass(editor_id + '_amadeo_form_unfieldset', 'mceButtonDisabled');
			if (any_selection) {
				tinyMCE.switchClass(editor_id + '_amadeo_form_fieldset', 'mceButtonNormal');
			} else {
				tinyMCE.switchClass(editor_id + '_amadeo_form_fieldset', 'mceButtonDisabled');
			}
		}

		switch (node.nodeName) {
		    case 'TEXTAREA':
				tinyMCE.switchClass(editor_id + '_amadeo_form_edit', 'mceButtonSelected');
				return true;
			case 'INPUT':
			    switch (node.type) {
			        case 'text':
					case 'file':
					case 'password':
						tinyMCE.switchClass(editor_id + '_amadeo_form_edit', 'mceButtonSelected');
						return true;
					case 'submit':
					case 'reset':
					case 'button':
						tinyMCE.switchClass(editor_id + '_amadeo_form_button', 'mceButtonSelected');
						return true;
		            case 'radio':
						tinyMCE.switchClass(editor_id + '_amadeo_form_radio', 'mceButtonSelected');
						return true;
					case 'checkbox':
						tinyMCE.switchClass(editor_id + '_amadeo_form_checkbox', 'mceButtonSelected');
						return true;
					default: return false;
				}
			case 'SELECT': 
				tinyMCE.switchClass(editor_id + '_amadeo_form_select', 'mceButtonSelected');
				return true;
			default: return false;
		} //switch
	}
};

// Adds the plugin class to the list of available TinyMCE plugins
tinyMCE.addPlugin("amadeo_form", TinyMCE_amadeo_formPlugin);
