({
	doInit: function (component, event, helper) {
		if(!helper.emojiSupported(component)){
			alert('Browser not supported');
		}else{
			helper.parseEmoji(component,event,helper);
		}
	},
})