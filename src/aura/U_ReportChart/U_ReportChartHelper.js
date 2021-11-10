({
	onInit : function(component,event,helper) {
        var chartType = component.get('v.selectedChartType');
        var reportId = component.get('v.selectedReport');
        if(reportId.length > 1 && chartType.length > 1){
            this.CreateChart(component,event,helper);
        }
	},
	CreateChart : function(component,event,helper) {
        var result;
        var ctype = component.get('v.selectedChartType');
        var reportId = component.get('v.selectedReport');
        var red = component.get('v.primaryRed');
        var green = component.get('v.primaryGreen');
        var blue = component.get('v.primaryBlue');
        if(ctype == 'polar area'){
            let values = ctype.split(' ');
            let firstChar = values[0];
            let secondChar = values[1];
            ctype = firstChar + '' + secondChar.charAt(0).toUpperCase() + secondChar.slice(1);
        }
        var action = component.get('c.getReportData');
        action.setParams({
        	reportId : reportId
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var reportResult = JSON.parse(response.getReturnValue());
                var data = [];
                var Label= [];
                if(null !== (reportResult.groupingsDown.groupings)) {
                    for(var i = 0; i < (reportResult.groupingsDown.groupings.length); i++) {
                        var tLabel = reportResult.groupingsDown.groupings[i].label;
                        Label.push(tLabel);
                        var tKey = reportResult.groupingsDown.groupings[i].key;
                        var tValue = reportResult.factMap[tKey + '!T'].aggregates[0].value;
                        data.push(tValue);
                    }
                }
                //Create chart
                result = component.find('chartContainer').get('v.value');
                if(result){
                    result.destroy();
                }
                var el = component.find('denaliChart').getElement();
                var ctx = el.getContext('2d');
                var background_color = new Array();
                for(var i = 0; i < Label.length; i++) {
                    var w,x,y,z;
                    //w = parseInt(Math.random()*255);
                    //x = parseInt(Math.random()*255);
                    //y = parseInt(Math.random()*255);
                    z = i == 0 ? 0.09 : (1 - (0.09 + i/Label.length));
                    background_color.push('rgba('+ red+ ',' + green + ',' + blue + ',' + z +')');  
                }
                result = new Chart(ctx, {
                    type: ctype,
                    data: {
                        labels: Label,
                        datasets: [
                            {
                                label: 'Data',
                                fillColor: background_color,
                                backgroundColor: background_color,
                                strokeColor: 'rgba(220,220,220,1)',                
                                data: data
                            }
                        ]
                    },
                    options: {
                        responsive:true,
                        hover: {
                            mode: 'none'
                        },
                        scales: {
                            yAxes: [{
                                ticks: {
                                    beginAtZero:true
                                }
                            }]
                        }
                    }
                });
                result.update();
            } else if(state === 'ERROR'){
				var errors = response.getError();
				if(errors){
					if(errors[0] && errors[0].message){
						console.log('ERROR: ' + errors[0].message);
					} else{
						console.log('ERROR: Unknown ' + response.getError());
					}
				} else{
					console.log('Something went wrong.  Please try again');
				}
			}
            
        });
        $A.enqueueAction(action);
    },
})