/**
* @author Kevin Winn
* @date 05/20/2021
* @group Controllers - Aura
* @description 
**/
global class AuraReportChartTypePicklist extends VisualEditor.DynamicPicklist
{
	/**
    * @author Kevin Winn
    * @date May 16, 2020 
    * @description A description for this method
    */
	 global override VisualEditor.DataRow getDefaultValue()
	 {
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('Select a Chart Type','selectChartType');
        return defaultValue;
    }

    /**
    * @author Kevin Winn
    * @date May 16, 2020 
    * @description A description for this method
    */
    global override VisualEditor.DynamicPickListRows getValues() 
    {
        Map<String,String> typeMap = getChartTypes();
        VisualEditor.DynamicPickListRows  results = new VisualEditor.DynamicPickListRows();
        for(String s : typeMap.keySet())
        {
        	results.addRow(new VisualEditor.DataRow(typeMap.get(s),s));
        }
        return results;
    }

    /**
    * @author Kevin Winn
    * @date May 16, 2020 
    * @description A description for this method
    */
    global static Map<String,String> getChartTypes()
    {
    	Map<String,String> results = new Map<String,String>();
    	results.put('pie','Pie Chart');
    	results.put('bar','Bar Chart');
    	results.put('doughnut', 'Doughnut Chart');
    	results.put('radar','Radar Chart');
    	results.put('polar area','Polar Area Chart');
    	results.put('bubble','Bubble Chart');
    	results.put('line','Line Chart');
    	return results;
    }
}