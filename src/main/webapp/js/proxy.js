function confirmDeleteSchema(formId, uri, schemaFile){
	if(window.confirm("Remove " + schemaFile + " schema for URI " + uri + " ?")){
		document.getElementById(formId).submit();
	}
}
function confirmDeleteMapping(formId, uri){
	if(window.confirm("Remove mapping for URI " + uri + " ?")){
		document.getElementById(formId).submit();
	}
}