({
    doInit : function(component, event, helper) {
        helper.onInit(component,event,helper);
    },
    scriptsLoaded : function(component,event,helper) {
        var chartType = component.get('v.selectedChartType');
        var reportId = component.get('v.selectedReportId');
        if(!(chartType == null && reportId == null)){
            helper.onInit(component,event,helper);
        }   
    },
    onSelectReportChange : function(component, event, helper) {
        component.set('v.isChartReady',true);
        component.set('v.selectedReport',event.getSource().get('v.value'));
        helper.CreateChart(component);
    },
    onSelectChartTypeChange : function(component, event, helper) {
        component.set('v.isChartReady',true);
        component.set('v.selectedChartType',event.getSource().get('v.value'));
        helper.CreateChart(component);
    },
    showSpinner: function(component, event, helper) {
        component.set('v.showSpinner', true); 
    },
    hideSpinner : function(component,event,helper) {   
        component.set('v.showSpinner', false);
    }
})