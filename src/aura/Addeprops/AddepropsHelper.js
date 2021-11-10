({
	onInit: function (component,event,helper) {
		let action = component.get('c.getAllAddeprops');
		action.setCallback(this,function(response){
			let state = response.getState();
			console.log(state);
			if(state === "SUCCESS" || state === "DRAFT"){
				component.set('v.data',response.getReturnValue());
			} else if(state === "ERROR"){
				console.log(JSON.stringify(response.getError()));
				component.set('v.error',JSON.stringify(response.getError()));
			} else if(state === "INCOMPLETE"){
				alert("Response incomplete.  Please try again.  If the issue persists please check your internet connection.");
			} else{
				alert("An unknown error occurred.");
			}
		});
		$A.enqueueAction(action);
	}
})