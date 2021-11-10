({
	emojiSupported: function(component) {
		var node = document.createElement('canvas');
		if (!node.getContext || !node.getContext('2d') ||
			typeof node.getContext('2d').fillText !== 'function')
			return false;
			var ctx = node.getContext('2d');
			ctx.textBaseline = 'top';
			ctx.font = '32px Arial';
			ctx.fillText('\ud83d\ude03', 0, 0);
			return ctx.getImageData(16, 16, 1, 1).data[0] !== 0;
	},
	parseEmoji: function(component,event,helper){
		var emojiCode = component.get('v.emojiCode');
		var hex = '0x';
		var emojiImage = null;
		if(emojiCode.indexOf('-') !== -1){
			var splits = emojiCode.split('-');
			var temp = hex + splits[0];
			emojiImage = temp;
		}else{
			emojiImage = hex + emojiCode;
		}
		component.set('v.emojiImage',String.fromCodePoint(emojiImage));
	},
})