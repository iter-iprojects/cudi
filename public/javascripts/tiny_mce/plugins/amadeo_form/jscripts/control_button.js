function initButton(){var inst=tinyMCE.getInstanceById(tinyMCE.getWindowArg('editor_id'));var focusElm=inst.getFocusElement();var nodeName=focusElm.nodeName.toLowerCase();if((nodeName=="input")&&((focusElm.type=='submit')||(focusElm.type=='reset')||(focusElm.type=='button'))){editing=focusElm;selectOption('cb_class',focusElm.className);document.getElementById('ed_name').value=focusElm.name.replace(/^b_/,'');document.getElementById('ed_desc').value=focusElm.title;document.getElementById('ed_value').value=focusElm.value;}else{editing=null;}}function insertButton(){var inst=tinyMCE.getInstanceById(tinyMCE.getWindowArg('editor_id'));var cName=document.getElementById('ed_name').value;var cDesc=document.getElementById('ed_desc').value;var cValue=document.getElementById('ed_value').value;if(cName==''){alert(tinyMCE.entityDecode(tinyMCE.getLang('lang_amadeo_form_err_name_mandatory')));return false;}else{cName='b_'+cName;}if(cValue==''){alert(tinyMCE.entityDecode(tinyMCE.getLang('lang_amadeo_form_err_value_mandatory')));return false;}if(!editing&&inst.contentWindow.document.getElementById(cName)){alert(tinyMCE.entityDecode(tinyMCE.getLang('lang_amadeo_form_err_name_unique')));return false;}if((className=getSelectValue('cb_class'))=='none'){className='';}switch(getSelectValue('cb_type')){case'submit':typeName='submit';break;case'reset':typeName='reset';break;default:typeName='submit';break;}inst.execCommand('mceBeginUndoLevel');if(editing!=null){editing.className=className;editing.id=cName;editing.name=cName;editing.title=cDesc;editing.type=typeName;editing.value=cValue;}else{html='<input';html+=makeAttrib('type',typeName);html+=makeAttrib('id',cName);html+=makeAttrib('name',cName);html+=makeAttrib('title',cDesc);html+=makeAttrib('class',className);html+=makeAttrib('value',cValue);html+='/>';inst.execCommand('mceInsertContent',false,html);}inst.execCommand("mceEndUndoLevel");tinyMCEPopup.close();}