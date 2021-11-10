/**
* @author Kevin Winn
* @date 05/20/2021
* @group Controllers - Aura
* @description 
**/
global class AuraReportChartReportPicklist extends VisualEditor.DynamicPicklist
{
	/**
    * @author Kevin Winn
    * @date May 16, 2020 
    * @description A description for this method
    */
	 global override VisualEditor.DataRow getDefaultValue()
	 {
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('Select a Report', 'selectReport');
        return defaultValue;
    }

    /**
    * @author Kevin Winn
    * @date May 16, 2020 
    * @description A description for this method
    */
    global override VisualEditor.DynamicPickListRows getValues() 
    {
        Map<String,String> typeMap = getReports();
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
    private static Map<String,String> getReports()
    {
        Map<String,String> results = new Map<String,String>();
        Set<String> denaliFolders = getDenaliFolders();
        for(Report r :[select Id,Name from Report where (Format = 'MATRIX' OR Format = 'Summary') And OwnerId In 
                            (Select Id From Folder Where DeveloperName In: denaliFolders)
                            Order By Name ASC] )
        {
            results.put(r.Id,r.Name);
        }
        return results;
    }

    /**
    * @author Kevin Winn
    * @date May 16, 2020 
    * @description A description for this method
    */
    private static Set<String> getDenaliFolders()
    {
        Set<String> results = new Set<String>();
        results.add('Addeprops');
        return results;
    }
}